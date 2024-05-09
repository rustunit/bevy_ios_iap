//
//  File.swift
//  
//
//  Created by Stephan on 26.04.24.
//

import StoreKit
import RustXcframework


public func ios_iap_products(products:RustVec<RustString>)
{
    Task {
        //TODO: wrap in do catch for error handling
        
        var productIds:[String] = []
        for p in products {
            productIds.append(p.as_str().toString())
        }
        
        let products = try await Product.products(for: productIds)
        
        let rust_products = RustVec<IosIapProduct>()
        
        for product in products {
            let type = if product.type == Product.ProductType.consumable {
                 IosIapProductType.new_consumable(false)
            } else if product.type == Product.ProductType.nonConsumable {
                 IosIapProductType.new_consumable(true)
            } else if product.type == Product.ProductType.nonRenewable {
                IosIapProductType.new_non_renewable()
            } else {
                 IosIapProductType.new_auto_renewable()
            }
            
            rust_products.push(value: IosIapProduct.new(product.id, product.displayPrice, product.displayName, product.description, Double(truncating: product.price as NSNumber), type))
        }
        
        products_received(rust_products)
   }
}

public func ios_iap_purchase(id: RustString)
{
    Task {
        do {
            let productIds = [id.toString()]
            let products = try await Product.products(for: productIds)
            
            if products.isEmpty {
                return purchase_processed(IosIapPurchaseResult.unknown(id.toString()))
            }
            
            let purchase  = try await products.first!.purchase()
            
            let result = switch purchase {
            case .success(let transactionResult):
                IosIapPurchaseResult.success(convert_transaction(transactionResult.unsafePayloadValue))
            case .userCancelled:
                IosIapPurchaseResult.canceled(id.toString())
            case .pending:
                IosIapPurchaseResult.pending(id.toString())
            }
            
            purchase_processed(result)
        } catch {
            purchase_processed(IosIapPurchaseResult.error(error.localizedDescription))
        }
   }
}

public func ios_iap_init()
{
    TransactionObserver.init()
}

public func ios_iap_transaction_finish(id: UInt64) {
    Task {
        do {
            for await t in Transaction.unfinished {
                // ignore un-signed/verified transactions
                guard case .verified(let transaction) = t else {
                    continue
                }
                
                if transaction.id == id {
                    await transaction.finish()
                    transaction_finished(IosIapTransactionFinished.finished(convert_transaction(transaction)))
                    return;
                }
            }
            
            transaction_finished(IosIapTransactionFinished.unknown(id))
        } catch {
            transaction_finished(IosIapTransactionFinished.error(error.localizedDescription))
        }
    }
}

public func ios_iap_transactions_all() {
    Task {
        //TODO: wrap in do catch for error handling
        
        var transactions = RustVec<IosIapTransaction>.init()
        
        for await t in Transaction.all {
            //only return signed/verified transactions
            guard case .verified(let transaction) = t else {
                continue
            }
            
            transactions.push(value:convert_transaction(transaction))
        }
        
        all_transactions(transactions)
    }
}

public func ios_iap_transactions_current_entitlements() {
    Task {
        //TODO: wrap in do catch for error handling
        
        var transactions = RustVec<IosIapTransaction>.init()
        
        for await t in Transaction.currentEntitlements {
            //only return signed/verified transactions
            guard case .verified(let transaction) = t else {
                continue
            }
            
            transactions.push(value:convert_transaction(transaction))
        }
        
        current_entitlements(transactions)
    }
}

public func convert_transaction(_ transaction: (Transaction)) -> IosIapTransaction {
   let type = if transaction.productType == Product.ProductType.consumable {
       IosIapProductType.new_consumable(false)
   } else if transaction.productType == Product.ProductType.nonConsumable {
       IosIapProductType.new_consumable(true)
   } else if transaction.productType == Product.ProductType.nonRenewable {
       IosIapProductType.new_non_renewable()
   } else {
       IosIapProductType.new_auto_renewable()
   }
   
   let reason = if transaction.reason == Transaction.Reason.purchase {
       IosIapTransactionReason.purchase()
   } else  {
       IosIapTransactionReason.renewal()
   }
   
   let env = if transaction.environment == AppStore.Environment.xcode {
       IosIapEnvironment.xcode()
   } else if transaction.environment == AppStore.Environment.sandbox {
       IosIapEnvironment.sandbox()
   } else {
       IosIapEnvironment.production()
   }
   
   let store = IosIapStorefront.storefront(transaction.storefront.id, transaction.storefront.countryCode)
   
   var t  = IosIapTransaction.new_transaction(transaction.id, transaction.productID, transaction.appBundleID, UInt64(transaction.purchaseDate.timeIntervalSince1970), Int32(transaction.purchasedQuantity),  transaction.storefrontCountryCode, UInt64(transaction.signedDate.timeIntervalSince1970), transaction.isUpgraded, type, reason, env, store)
   
   if let revocationDate = transaction.revocationDate {
       IosIapTransaction.add_revocation(t, UInt64(revocationDate.timeIntervalSince1970))
   }
   
   if let expirationDate = transaction.expirationDate {
       IosIapTransaction.add_expiration(t, UInt64(expirationDate.timeIntervalSince1970))
   }
   
   return t
}

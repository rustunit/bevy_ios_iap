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
        var productIds:[String] = []
        for p in products {
            productIds.append(p.as_str().toString())
        }
        
        let products = try await Product.products(for: productIds)
//        print("products:\n \(products)")
        
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
        let productIds = [id.toString()]
        let products = try await Product.products(for: productIds)
        let purchase  = try! await products[0].purchase()
//        print("purchase:\n \(purchase)")
        
        let result = switch purchase {
        case .success(_):
            IosIapPurchaseResult.success()
        case .userCancelled:
            IosIapPurchaseResult.canceled()
        case .pending:
            IosIapPurchaseResult.pending()
        }
        
        purchase_processed(result)
   }
}

public func ios_iap_init()
{
    TransactionObserver.init()
}

public func ios_iap_transaction_finish(id: UInt64) {
    Task {
        for await t in Transaction.unfinished {
            // ignore un-signed/verified transactions
            guard case .verified(let transaction) = t else {
                continue
            }
            
            if transaction.id == id {
                await transaction.finish()
            }
        }
    }
}

public func ios_iap_transactions_all() {
    Task {
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
       IosIapTransactionReason.purchase()
   }
   
   let env = if transaction.environment == AppStore.Environment.xcode {
       IosIapEnvironment.xcode()
   } else if transaction.environment == AppStore.Environment.sandbox {
       IosIapEnvironment.sandbox()
   } else {
       IosIapEnvironment.production()
   }
   
   let store = IosIapStorefront.storefront(transaction.storefront.id, transaction.storefront.countryCode)
   
   var t  = IosIapTransaction.new_transaction(transaction.id, transaction.productID, transaction.productID, UInt64(transaction.purchaseDate.timeIntervalSince1970), Int32(transaction.purchasedQuantity),  transaction.storefrontCountryCode, UInt64(transaction.signedDate.timeIntervalSince1970), transaction.isUpgraded, type, reason, env, store)
   
   if let revocationDate = transaction.revocationDate {
       IosIapTransaction.add_revocation(t, UInt64(revocationDate.timeIntervalSince1970))
   }
   
   if let expirationDate = transaction.expirationDate {
       IosIapTransaction.add_expiration(t, UInt64(expirationDate.timeIntervalSince1970))
   }
   
   return t
}

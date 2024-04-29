import StoreKit

final class TransactionObserver {
    
    var updates: Task<Void, Never>? = nil
    
    init() {
        updates = newTransactionListenerTask()
    }


    deinit {
        // Cancel the update handling task when you deinitialize the class.
        updates?.cancel()
    }
    
    private func newTransactionListenerTask() -> Task<Void, Never> {
        Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                self.handle(updatedTransaction: verificationResult)
            }
        }
    }
    
    private func handle(updatedTransaction verificationResult: VerificationResult<Transaction>) {
        guard case .verified(let transaction) = verificationResult else {
            // Ignore unverified transactions.
            print("unverified:\n \(verificationResult)")
            return
        }
        
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
        
        transaction_update(t)
    }
    
}

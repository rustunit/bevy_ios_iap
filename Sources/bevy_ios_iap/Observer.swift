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
        
        let t = convert_transaction(transaction)
        
        transaction_update(t)
    }
    
}

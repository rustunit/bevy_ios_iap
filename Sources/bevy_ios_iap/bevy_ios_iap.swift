import RustXcframework 
public func products_received(_ request: Int64, _ response: IosIapProductsResponse) {
    __swift_bridge__$products_received(request, {response.isOwned = false; return response.ptr;}())
}
public func all_transactions(_ request: Int64, _ response: IosIapTransactionResponse) {
    __swift_bridge__$all_transactions(request, {response.isOwned = false; return response.ptr;}())
}
public func current_entitlements(_ request: Int64, _ response: IosIapTransactionResponse) {
    __swift_bridge__$current_entitlements(request, {response.isOwned = false; return response.ptr;}())
}
public func purchase_processed(_ request: Int64, _ result: IosIapPurchaseResponse) {
    __swift_bridge__$purchase_processed(request, {result.isOwned = false; return result.ptr;}())
}
public func transaction_update(_ t: IosIapTransaction) {
    __swift_bridge__$transaction_update({t.isOwned = false; return t.ptr;}())
}
public func transaction_finished(_ request: Int64, _ t: IosIapTransactionFinishResponse) {
    __swift_bridge__$transaction_finished(request, {t.isOwned = false; return t.ptr;}())
}
@_cdecl("__swift_bridge__$ios_iap_init")
public func __swift_bridge__ios_iap_init () {
    ios_iap_init()
}

@_cdecl("__swift_bridge__$ios_iap_products")
public func __swift_bridge__ios_iap_products (_ request: Int64, _ products: UnsafeMutableRawPointer) {
    ios_iap_products(request: request, products: RustVec(ptr: products))
}

@_cdecl("__swift_bridge__$ios_iap_purchase")
public func __swift_bridge__ios_iap_purchase (_ request: Int64, _ id: UnsafeMutableRawPointer) {
    ios_iap_purchase(request: request, id: RustString(ptr: id))
}

@_cdecl("__swift_bridge__$ios_iap_transactions_all")
public func __swift_bridge__ios_iap_transactions_all (_ request: Int64) {
    ios_iap_transactions_all(request: request)
}

@_cdecl("__swift_bridge__$ios_iap_transactions_current_entitlements")
public func __swift_bridge__ios_iap_transactions_current_entitlements (_ request: Int64) {
    ios_iap_transactions_current_entitlements(request: request)
}

@_cdecl("__swift_bridge__$ios_iap_transaction_finish")
public func __swift_bridge__ios_iap_transaction_finish (_ request: Int64, _ transaction_id: UInt64) {
    ios_iap_transaction_finish(request: request, transaction_id: transaction_id)
}


public class IosIapTransactionFinishResponse: IosIapTransactionFinishResponseRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapTransactionFinishResponse$_free(ptr)
        }
    }
}
extension IosIapTransactionFinishResponse {
    class public func finished(_ t: IosIapTransaction) -> IosIapTransactionFinishResponse {
        IosIapTransactionFinishResponse(ptr: __swift_bridge__$IosIapTransactionFinishResponse$finished({t.isOwned = false; return t.ptr;}()))
    }

    class public func error<GenericIntoRustString: IntoRustString>(_ e: GenericIntoRustString) -> IosIapTransactionFinishResponse {
        IosIapTransactionFinishResponse(ptr: __swift_bridge__$IosIapTransactionFinishResponse$error({ let rustString = e.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }

    class public func unknown(_ id: UInt64) -> IosIapTransactionFinishResponse {
        IosIapTransactionFinishResponse(ptr: __swift_bridge__$IosIapTransactionFinishResponse$unknown(id))
    }
}
public class IosIapTransactionFinishResponseRefMut: IosIapTransactionFinishResponseRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapTransactionFinishResponseRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapTransactionFinishResponse: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapTransactionFinishResponse$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapTransactionFinishResponse$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapTransactionFinishResponse) {
        __swift_bridge__$Vec_IosIapTransactionFinishResponse$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapTransactionFinishResponse$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapTransactionFinishResponse(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapTransactionFinishResponseRef> {
        let pointer = __swift_bridge__$Vec_IosIapTransactionFinishResponse$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapTransactionFinishResponseRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapTransactionFinishResponseRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapTransactionFinishResponse$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapTransactionFinishResponseRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapTransactionFinishResponseRef> {
        UnsafePointer<IosIapTransactionFinishResponseRef>(OpaquePointer(__swift_bridge__$Vec_IosIapTransactionFinishResponse$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapTransactionFinishResponse$len(vecPtr)
    }
}


public class IosIapTransactionResponse: IosIapTransactionResponseRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapTransactionResponse$_free(ptr)
        }
    }
}
extension IosIapTransactionResponse {
    class public func done(_ items: RustVec<IosIapTransaction>) -> IosIapTransactionResponse {
        IosIapTransactionResponse(ptr: __swift_bridge__$IosIapTransactionResponse$done({ let val = items; val.isOwned = false; return val.ptr }()))
    }

    class public func error<GenericIntoRustString: IntoRustString>(_ error: GenericIntoRustString) -> IosIapTransactionResponse {
        IosIapTransactionResponse(ptr: __swift_bridge__$IosIapTransactionResponse$error({ let rustString = error.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }
}
public class IosIapTransactionResponseRefMut: IosIapTransactionResponseRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapTransactionResponseRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapTransactionResponse: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapTransactionResponse$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapTransactionResponse$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapTransactionResponse) {
        __swift_bridge__$Vec_IosIapTransactionResponse$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapTransactionResponse$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapTransactionResponse(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapTransactionResponseRef> {
        let pointer = __swift_bridge__$Vec_IosIapTransactionResponse$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapTransactionResponseRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapTransactionResponseRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapTransactionResponse$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapTransactionResponseRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapTransactionResponseRef> {
        UnsafePointer<IosIapTransactionResponseRef>(OpaquePointer(__swift_bridge__$Vec_IosIapTransactionResponse$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapTransactionResponse$len(vecPtr)
    }
}


public class IosIapProductsResponse: IosIapProductsResponseRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapProductsResponse$_free(ptr)
        }
    }
}
extension IosIapProductsResponse {
    class public func done(_ items: RustVec<IosIapProduct>) -> IosIapProductsResponse {
        IosIapProductsResponse(ptr: __swift_bridge__$IosIapProductsResponse$done({ let val = items; val.isOwned = false; return val.ptr }()))
    }

    class public func error<GenericIntoRustString: IntoRustString>(_ error: GenericIntoRustString) -> IosIapProductsResponse {
        IosIapProductsResponse(ptr: __swift_bridge__$IosIapProductsResponse$error({ let rustString = error.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }
}
public class IosIapProductsResponseRefMut: IosIapProductsResponseRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapProductsResponseRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapProductsResponse: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapProductsResponse$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapProductsResponse$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapProductsResponse) {
        __swift_bridge__$Vec_IosIapProductsResponse$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapProductsResponse$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapProductsResponse(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapProductsResponseRef> {
        let pointer = __swift_bridge__$Vec_IosIapProductsResponse$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapProductsResponseRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapProductsResponseRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapProductsResponse$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapProductsResponseRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapProductsResponseRef> {
        UnsafePointer<IosIapProductsResponseRef>(OpaquePointer(__swift_bridge__$Vec_IosIapProductsResponse$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapProductsResponse$len(vecPtr)
    }
}


public class IosIapRevocationReason: IosIapRevocationReasonRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapRevocationReason$_free(ptr)
        }
    }
}
public class IosIapRevocationReasonRefMut: IosIapRevocationReasonRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapRevocationReasonRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapRevocationReasonRef {
    class public func developer_issue() -> IosIapRevocationReason {
        IosIapRevocationReason(ptr: __swift_bridge__$IosIapRevocationReason$developer_issue())
    }

    class public func other() -> IosIapRevocationReason {
        IosIapRevocationReason(ptr: __swift_bridge__$IosIapRevocationReason$other())
    }
}
extension IosIapRevocationReason: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapRevocationReason$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapRevocationReason$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapRevocationReason) {
        __swift_bridge__$Vec_IosIapRevocationReason$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapRevocationReason$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapRevocationReason(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapRevocationReasonRef> {
        let pointer = __swift_bridge__$Vec_IosIapRevocationReason$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapRevocationReasonRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapRevocationReasonRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapRevocationReason$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapRevocationReasonRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapRevocationReasonRef> {
        UnsafePointer<IosIapRevocationReasonRef>(OpaquePointer(__swift_bridge__$Vec_IosIapRevocationReason$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapRevocationReason$len(vecPtr)
    }
}


public class IosIapCurrency: IosIapCurrencyRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapCurrency$_free(ptr)
        }
    }
}
extension IosIapCurrency {
    class public func new<GenericIntoRustString: IntoRustString>(_ identifier: GenericIntoRustString, _ is_iso_currency: Bool) -> IosIapCurrency {
        IosIapCurrency(ptr: __swift_bridge__$IosIapCurrency$new({ let rustString = identifier.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), is_iso_currency))
    }
}
public class IosIapCurrencyRefMut: IosIapCurrencyRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapCurrencyRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapCurrency: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapCurrency$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapCurrency$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapCurrency) {
        __swift_bridge__$Vec_IosIapCurrency$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapCurrency$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapCurrency(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapCurrencyRef> {
        let pointer = __swift_bridge__$Vec_IosIapCurrency$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapCurrencyRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapCurrencyRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapCurrency$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapCurrencyRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapCurrencyRef> {
        UnsafePointer<IosIapCurrencyRef>(OpaquePointer(__swift_bridge__$Vec_IosIapCurrency$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapCurrency$len(vecPtr)
    }
}


public class IosIapSubscriptionRenewalState: IosIapSubscriptionRenewalStateRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapSubscriptionRenewalState$_free(ptr)
        }
    }
}
public class IosIapSubscriptionRenewalStateRefMut: IosIapSubscriptionRenewalStateRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapSubscriptionRenewalStateRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapSubscriptionRenewalStateRef {
    class public func subscribed() -> IosIapSubscriptionRenewalState {
        IosIapSubscriptionRenewalState(ptr: __swift_bridge__$IosIapSubscriptionRenewalState$subscribed())
    }

    class public func expired() -> IosIapSubscriptionRenewalState {
        IosIapSubscriptionRenewalState(ptr: __swift_bridge__$IosIapSubscriptionRenewalState$expired())
    }

    class public func in_billing_retry_period() -> IosIapSubscriptionRenewalState {
        IosIapSubscriptionRenewalState(ptr: __swift_bridge__$IosIapSubscriptionRenewalState$in_billing_retry_period())
    }

    class public func in_grace_period() -> IosIapSubscriptionRenewalState {
        IosIapSubscriptionRenewalState(ptr: __swift_bridge__$IosIapSubscriptionRenewalState$in_grace_period())
    }

    class public func revoked() -> IosIapSubscriptionRenewalState {
        IosIapSubscriptionRenewalState(ptr: __swift_bridge__$IosIapSubscriptionRenewalState$revoked())
    }
}
extension IosIapSubscriptionRenewalState: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapSubscriptionRenewalState$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapSubscriptionRenewalState$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapSubscriptionRenewalState) {
        __swift_bridge__$Vec_IosIapSubscriptionRenewalState$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionRenewalState$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapSubscriptionRenewalState(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapSubscriptionRenewalStateRef> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionRenewalState$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapSubscriptionRenewalStateRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapSubscriptionRenewalStateRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionRenewalState$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapSubscriptionRenewalStateRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapSubscriptionRenewalStateRef> {
        UnsafePointer<IosIapSubscriptionRenewalStateRef>(OpaquePointer(__swift_bridge__$Vec_IosIapSubscriptionRenewalState$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapSubscriptionRenewalState$len(vecPtr)
    }
}


public class IosIapSubscriptionStatus: IosIapSubscriptionStatusRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapSubscriptionStatus$_free(ptr)
        }
    }
}
extension IosIapSubscriptionStatus {
    class public func new(_ state: IosIapSubscriptionRenewalState, _ transaction: IosIapTransaction) -> IosIapSubscriptionStatus {
        IosIapSubscriptionStatus(ptr: __swift_bridge__$IosIapSubscriptionStatus$new({state.isOwned = false; return state.ptr;}(), {transaction.isOwned = false; return transaction.ptr;}()))
    }
}
public class IosIapSubscriptionStatusRefMut: IosIapSubscriptionStatusRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapSubscriptionStatusRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapSubscriptionStatus: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapSubscriptionStatus$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapSubscriptionStatus$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapSubscriptionStatus) {
        __swift_bridge__$Vec_IosIapSubscriptionStatus$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionStatus$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapSubscriptionStatus(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapSubscriptionStatusRef> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionStatus$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapSubscriptionStatusRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapSubscriptionStatusRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionStatus$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapSubscriptionStatusRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapSubscriptionStatusRef> {
        UnsafePointer<IosIapSubscriptionStatusRef>(OpaquePointer(__swift_bridge__$Vec_IosIapSubscriptionStatus$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapSubscriptionStatus$len(vecPtr)
    }
}


public class IosIapSubscriptionPeriodUnit: IosIapSubscriptionPeriodUnitRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapSubscriptionPeriodUnit$_free(ptr)
        }
    }
}
public class IosIapSubscriptionPeriodUnitRefMut: IosIapSubscriptionPeriodUnitRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapSubscriptionPeriodUnitRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapSubscriptionPeriodUnitRef {
    class public func day() -> IosIapSubscriptionPeriodUnit {
        IosIapSubscriptionPeriodUnit(ptr: __swift_bridge__$IosIapSubscriptionPeriodUnit$day())
    }

    class public func week() -> IosIapSubscriptionPeriodUnit {
        IosIapSubscriptionPeriodUnit(ptr: __swift_bridge__$IosIapSubscriptionPeriodUnit$week())
    }

    class public func month() -> IosIapSubscriptionPeriodUnit {
        IosIapSubscriptionPeriodUnit(ptr: __swift_bridge__$IosIapSubscriptionPeriodUnit$month())
    }

    class public func year() -> IosIapSubscriptionPeriodUnit {
        IosIapSubscriptionPeriodUnit(ptr: __swift_bridge__$IosIapSubscriptionPeriodUnit$year())
    }
}
extension IosIapSubscriptionPeriodUnit: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapSubscriptionPeriodUnit$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapSubscriptionPeriodUnit$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapSubscriptionPeriodUnit) {
        __swift_bridge__$Vec_IosIapSubscriptionPeriodUnit$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionPeriodUnit$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapSubscriptionPeriodUnit(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapSubscriptionPeriodUnitRef> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionPeriodUnit$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapSubscriptionPeriodUnitRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapSubscriptionPeriodUnitRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionPeriodUnit$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapSubscriptionPeriodUnitRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapSubscriptionPeriodUnitRef> {
        UnsafePointer<IosIapSubscriptionPeriodUnitRef>(OpaquePointer(__swift_bridge__$Vec_IosIapSubscriptionPeriodUnit$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapSubscriptionPeriodUnit$len(vecPtr)
    }
}


public class IosIapSubscriptionPeriod: IosIapSubscriptionPeriodRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapSubscriptionPeriod$_free(ptr)
        }
    }
}
extension IosIapSubscriptionPeriod {
    class public func new(_ unit: IosIapSubscriptionPeriodUnit, _ value: Int32) -> IosIapSubscriptionPeriod {
        IosIapSubscriptionPeriod(ptr: __swift_bridge__$IosIapSubscriptionPeriod$new({unit.isOwned = false; return unit.ptr;}(), value))
    }
}
public class IosIapSubscriptionPeriodRefMut: IosIapSubscriptionPeriodRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapSubscriptionPeriodRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapSubscriptionPeriod: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapSubscriptionPeriod$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapSubscriptionPeriod$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapSubscriptionPeriod) {
        __swift_bridge__$Vec_IosIapSubscriptionPeriod$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionPeriod$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapSubscriptionPeriod(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapSubscriptionPeriodRef> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionPeriod$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapSubscriptionPeriodRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapSubscriptionPeriodRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionPeriod$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapSubscriptionPeriodRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapSubscriptionPeriodRef> {
        UnsafePointer<IosIapSubscriptionPeriodRef>(OpaquePointer(__swift_bridge__$Vec_IosIapSubscriptionPeriod$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapSubscriptionPeriod$len(vecPtr)
    }
}


public class IosIapSubscriptionInfo: IosIapSubscriptionInfoRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapSubscriptionInfo$_free(ptr)
        }
    }
}
extension IosIapSubscriptionInfo {
    class public func new<GenericIntoRustString: IntoRustString>(_ group_id: GenericIntoRustString, _ period: IosIapSubscriptionPeriod, _ is_eligible_for_intro_offer: Bool, _ state: RustVec<IosIapSubscriptionStatus>) -> IosIapSubscriptionInfo {
        IosIapSubscriptionInfo(ptr: __swift_bridge__$IosIapSubscriptionInfo$new({ let rustString = group_id.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), {period.isOwned = false; return period.ptr;}(), is_eligible_for_intro_offer, { let val = state; val.isOwned = false; return val.ptr }()))
    }
}
public class IosIapSubscriptionInfoRefMut: IosIapSubscriptionInfoRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapSubscriptionInfoRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapSubscriptionInfo: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapSubscriptionInfo$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapSubscriptionInfo$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapSubscriptionInfo) {
        __swift_bridge__$Vec_IosIapSubscriptionInfo$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionInfo$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapSubscriptionInfo(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapSubscriptionInfoRef> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionInfo$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapSubscriptionInfoRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapSubscriptionInfoRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapSubscriptionInfo$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapSubscriptionInfoRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapSubscriptionInfoRef> {
        UnsafePointer<IosIapSubscriptionInfoRef>(OpaquePointer(__swift_bridge__$Vec_IosIapSubscriptionInfo$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapSubscriptionInfo$len(vecPtr)
    }
}


public class IosIapStorefront: IosIapStorefrontRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapStorefront$_free(ptr)
        }
    }
}
extension IosIapStorefront {
    class public func storefront<GenericIntoRustString: IntoRustString>(_ id: GenericIntoRustString, _ country_code: GenericIntoRustString) -> IosIapStorefront {
        IosIapStorefront(ptr: __swift_bridge__$IosIapStorefront$storefront({ let rustString = id.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), { let rustString = country_code.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }
}
public class IosIapStorefrontRefMut: IosIapStorefrontRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapStorefrontRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapStorefront: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapStorefront$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapStorefront$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapStorefront) {
        __swift_bridge__$Vec_IosIapStorefront$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapStorefront$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapStorefront(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapStorefrontRef> {
        let pointer = __swift_bridge__$Vec_IosIapStorefront$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapStorefrontRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapStorefrontRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapStorefront$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapStorefrontRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapStorefrontRef> {
        UnsafePointer<IosIapStorefrontRef>(OpaquePointer(__swift_bridge__$Vec_IosIapStorefront$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapStorefront$len(vecPtr)
    }
}


public class IosIapEnvironment: IosIapEnvironmentRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapEnvironment$_free(ptr)
        }
    }
}
public class IosIapEnvironmentRefMut: IosIapEnvironmentRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapEnvironmentRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapEnvironmentRef {
    class public func sandbox() -> IosIapEnvironment {
        IosIapEnvironment(ptr: __swift_bridge__$IosIapEnvironment$sandbox())
    }

    class public func production() -> IosIapEnvironment {
        IosIapEnvironment(ptr: __swift_bridge__$IosIapEnvironment$production())
    }

    class public func xcode() -> IosIapEnvironment {
        IosIapEnvironment(ptr: __swift_bridge__$IosIapEnvironment$xcode())
    }
}
extension IosIapEnvironment: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapEnvironment$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapEnvironment$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapEnvironment) {
        __swift_bridge__$Vec_IosIapEnvironment$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapEnvironment$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapEnvironment(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapEnvironmentRef> {
        let pointer = __swift_bridge__$Vec_IosIapEnvironment$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapEnvironmentRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapEnvironmentRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapEnvironment$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapEnvironmentRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapEnvironmentRef> {
        UnsafePointer<IosIapEnvironmentRef>(OpaquePointer(__swift_bridge__$Vec_IosIapEnvironment$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapEnvironment$len(vecPtr)
    }
}


public class IosIapTransactionReason: IosIapTransactionReasonRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapTransactionReason$_free(ptr)
        }
    }
}
public class IosIapTransactionReasonRefMut: IosIapTransactionReasonRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapTransactionReasonRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapTransactionReasonRef {
    class public func renewal() -> IosIapTransactionReason {
        IosIapTransactionReason(ptr: __swift_bridge__$IosIapTransactionReason$renewal())
    }

    class public func purchase() -> IosIapTransactionReason {
        IosIapTransactionReason(ptr: __swift_bridge__$IosIapTransactionReason$purchase())
    }
}
extension IosIapTransactionReason: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapTransactionReason$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapTransactionReason$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapTransactionReason) {
        __swift_bridge__$Vec_IosIapTransactionReason$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapTransactionReason$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapTransactionReason(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapTransactionReasonRef> {
        let pointer = __swift_bridge__$Vec_IosIapTransactionReason$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapTransactionReasonRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapTransactionReasonRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapTransactionReason$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapTransactionReasonRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapTransactionReasonRef> {
        UnsafePointer<IosIapTransactionReasonRef>(OpaquePointer(__swift_bridge__$Vec_IosIapTransactionReason$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapTransactionReason$len(vecPtr)
    }
}


public class IosIapTransaction: IosIapTransactionRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapTransaction$_free(ptr)
        }
    }
}
extension IosIapTransaction {
    class public func new_transaction<GenericIntoRustString: IntoRustString>(_ id: UInt64, _ product_id: GenericIntoRustString, _ app_bundle_id: GenericIntoRustString, _ purchase_date: UInt64, _ original_purchase_date: UInt64, _ purchased_quantity: Int32, _ storefront_country_code: GenericIntoRustString, _ signed_date: UInt64, _ is_upgraded: Bool, _ original_id: UInt64, _ json_representation: GenericIntoRustString, _ product_type: IosIapProductType, _ reason: IosIapTransactionReason, _ environment: IosIapEnvironment, _ storefront: IosIapStorefront) -> IosIapTransaction {
        IosIapTransaction(ptr: __swift_bridge__$IosIapTransaction$new_transaction(id, { let rustString = product_id.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), { let rustString = app_bundle_id.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), purchase_date, original_purchase_date, purchased_quantity, { let rustString = storefront_country_code.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), signed_date, is_upgraded, original_id, { let rustString = json_representation.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), {product_type.isOwned = false; return product_type.ptr;}(), {reason.isOwned = false; return reason.ptr;}(), {environment.isOwned = false; return environment.ptr;}(), {storefront.isOwned = false; return storefront.ptr;}()))
    }

    class public func add_revocation(_ t: IosIapTransactionRefMut, _ date: UInt64) {
        __swift_bridge__$IosIapTransaction$add_revocation(t.ptr, date)
    }

    class public func add_expiration(_ t: IosIapTransactionRefMut, _ date: UInt64) {
        __swift_bridge__$IosIapTransaction$add_expiration(t.ptr, date)
    }

    class public func add_currency(_ t: IosIapTransactionRefMut, _ currency: IosIapCurrency) {
        __swift_bridge__$IosIapTransaction$add_currency(t.ptr, {currency.isOwned = false; return currency.ptr;}())
    }

    class public func add_currency_code<GenericIntoRustString: IntoRustString>(_ t: IosIapTransactionRefMut, _ code: GenericIntoRustString) {
        __swift_bridge__$IosIapTransaction$add_currency_code(t.ptr, { let rustString = code.intoRustString(); rustString.isOwned = false; return rustString.ptr }())
    }

    class public func revocation_reason(_ t: IosIapTransactionRefMut, _ reason: IosIapRevocationReason) {
        __swift_bridge__$IosIapTransaction$revocation_reason(t.ptr, {reason.isOwned = false; return reason.ptr;}())
    }

    class public func web_order_line_item_id<GenericIntoRustString: IntoRustString>(_ t: IosIapTransactionRefMut, _ id: GenericIntoRustString) {
        __swift_bridge__$IosIapTransaction$web_order_line_item_id(t.ptr, { let rustString = id.intoRustString(); rustString.isOwned = false; return rustString.ptr }())
    }

    class public func subscription_group_id<GenericIntoRustString: IntoRustString>(_ t: IosIapTransactionRefMut, _ id: GenericIntoRustString) {
        __swift_bridge__$IosIapTransaction$subscription_group_id(t.ptr, { let rustString = id.intoRustString(); rustString.isOwned = false; return rustString.ptr }())
    }

    class public func app_account_token<GenericIntoRustString: IntoRustString>(_ t: IosIapTransactionRefMut, _ uuid: GenericIntoRustString) {
        __swift_bridge__$IosIapTransaction$app_account_token(t.ptr, { let rustString = uuid.intoRustString(); rustString.isOwned = false; return rustString.ptr }())
    }
}
public class IosIapTransactionRefMut: IosIapTransactionRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapTransactionRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapTransaction: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapTransaction$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapTransaction$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapTransaction) {
        __swift_bridge__$Vec_IosIapTransaction$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapTransaction$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapTransaction(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapTransactionRef> {
        let pointer = __swift_bridge__$Vec_IosIapTransaction$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapTransactionRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapTransactionRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapTransaction$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapTransactionRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapTransactionRef> {
        UnsafePointer<IosIapTransactionRef>(OpaquePointer(__swift_bridge__$Vec_IosIapTransaction$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapTransaction$len(vecPtr)
    }
}


public class IosIapStoreKitError: IosIapStoreKitErrorRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapStoreKitError$_free(ptr)
        }
    }
}
extension IosIapStoreKitError {
    class public func network_error<GenericIntoRustString: IntoRustString>(_ e: GenericIntoRustString) -> IosIapStoreKitError {
        IosIapStoreKitError(ptr: __swift_bridge__$IosIapStoreKitError$network_error({ let rustString = e.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }

    class public func system_error<GenericIntoRustString: IntoRustString>(_ e: GenericIntoRustString) -> IosIapStoreKitError {
        IosIapStoreKitError(ptr: __swift_bridge__$IosIapStoreKitError$system_error({ let rustString = e.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }
}
public class IosIapStoreKitErrorRefMut: IosIapStoreKitErrorRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapStoreKitErrorRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapStoreKitErrorRef {
    class public func unknown() -> IosIapStoreKitError {
        IosIapStoreKitError(ptr: __swift_bridge__$IosIapStoreKitError$unknown())
    }

    class public func user_cancelled() -> IosIapStoreKitError {
        IosIapStoreKitError(ptr: __swift_bridge__$IosIapStoreKitError$user_cancelled())
    }

    class public func not_available_in_storefront() -> IosIapStoreKitError {
        IosIapStoreKitError(ptr: __swift_bridge__$IosIapStoreKitError$not_available_in_storefront())
    }

    class public func not_entitled() -> IosIapStoreKitError {
        IosIapStoreKitError(ptr: __swift_bridge__$IosIapStoreKitError$not_entitled())
    }
}
extension IosIapStoreKitError: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapStoreKitError$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapStoreKitError$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapStoreKitError) {
        __swift_bridge__$Vec_IosIapStoreKitError$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapStoreKitError$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapStoreKitError(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapStoreKitErrorRef> {
        let pointer = __swift_bridge__$Vec_IosIapStoreKitError$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapStoreKitErrorRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapStoreKitErrorRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapStoreKitError$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapStoreKitErrorRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapStoreKitErrorRef> {
        UnsafePointer<IosIapStoreKitErrorRef>(OpaquePointer(__swift_bridge__$Vec_IosIapStoreKitError$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapStoreKitError$len(vecPtr)
    }
}


public class IosIapPurchaseError: IosIapPurchaseErrorRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapPurchaseError$_free(ptr)
        }
    }
}
public class IosIapPurchaseErrorRefMut: IosIapPurchaseErrorRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapPurchaseErrorRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapPurchaseErrorRef {
    class public func invalid_quantity() -> IosIapPurchaseError {
        IosIapPurchaseError(ptr: __swift_bridge__$IosIapPurchaseError$invalid_quantity())
    }

    class public func product_unavailable() -> IosIapPurchaseError {
        IosIapPurchaseError(ptr: __swift_bridge__$IosIapPurchaseError$product_unavailable())
    }

    class public func purchase_not_allowed() -> IosIapPurchaseError {
        IosIapPurchaseError(ptr: __swift_bridge__$IosIapPurchaseError$purchase_not_allowed())
    }

    class public func ineligible_for_offer() -> IosIapPurchaseError {
        IosIapPurchaseError(ptr: __swift_bridge__$IosIapPurchaseError$ineligible_for_offer())
    }

    class public func invalid_offer_identifier() -> IosIapPurchaseError {
        IosIapPurchaseError(ptr: __swift_bridge__$IosIapPurchaseError$invalid_offer_identifier())
    }

    class public func invalid_offer_price() -> IosIapPurchaseError {
        IosIapPurchaseError(ptr: __swift_bridge__$IosIapPurchaseError$invalid_offer_price())
    }

    class public func invalid_offer_signature() -> IosIapPurchaseError {
        IosIapPurchaseError(ptr: __swift_bridge__$IosIapPurchaseError$invalid_offer_signature())
    }

    class public func missing_offer_parameters() -> IosIapPurchaseError {
        IosIapPurchaseError(ptr: __swift_bridge__$IosIapPurchaseError$missing_offer_parameters())
    }
}
extension IosIapPurchaseError: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapPurchaseError$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapPurchaseError$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapPurchaseError) {
        __swift_bridge__$Vec_IosIapPurchaseError$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapPurchaseError$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapPurchaseError(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapPurchaseErrorRef> {
        let pointer = __swift_bridge__$Vec_IosIapPurchaseError$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapPurchaseErrorRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapPurchaseErrorRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapPurchaseError$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapPurchaseErrorRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapPurchaseErrorRef> {
        UnsafePointer<IosIapPurchaseErrorRef>(OpaquePointer(__swift_bridge__$Vec_IosIapPurchaseError$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapPurchaseError$len(vecPtr)
    }
}


public class IosIapPurchaseResponse: IosIapPurchaseResponseRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapPurchaseResponse$_free(ptr)
        }
    }
}
extension IosIapPurchaseResponse {
    class public func success(_ t: IosIapTransaction) -> IosIapPurchaseResponse {
        IosIapPurchaseResponse(ptr: __swift_bridge__$IosIapPurchaseResponse$success({t.isOwned = false; return t.ptr;}()))
    }

    class public func canceled<GenericIntoRustString: IntoRustString>(_ id: GenericIntoRustString) -> IosIapPurchaseResponse {
        IosIapPurchaseResponse(ptr: __swift_bridge__$IosIapPurchaseResponse$canceled({ let rustString = id.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }

    class public func pending<GenericIntoRustString: IntoRustString>(_ id: GenericIntoRustString) -> IosIapPurchaseResponse {
        IosIapPurchaseResponse(ptr: __swift_bridge__$IosIapPurchaseResponse$pending({ let rustString = id.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }

    class public func unknown<GenericIntoRustString: IntoRustString>(_ id: GenericIntoRustString) -> IosIapPurchaseResponse {
        IosIapPurchaseResponse(ptr: __swift_bridge__$IosIapPurchaseResponse$unknown({ let rustString = id.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }

    class public func error<GenericIntoRustString: IntoRustString>(_ e: GenericIntoRustString) -> IosIapPurchaseResponse {
        IosIapPurchaseResponse(ptr: __swift_bridge__$IosIapPurchaseResponse$error({ let rustString = e.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }

    class public func purchase_error<GenericIntoRustString: IntoRustString>(_ error: IosIapPurchaseError, _ localized_description: GenericIntoRustString) -> IosIapPurchaseResponse {
        IosIapPurchaseResponse(ptr: __swift_bridge__$IosIapPurchaseResponse$purchase_error({error.isOwned = false; return error.ptr;}(), { let rustString = localized_description.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }

    class public func storekit_error<GenericIntoRustString: IntoRustString>(_ error: IosIapStoreKitError, _ localized_description: GenericIntoRustString) -> IosIapPurchaseResponse {
        IosIapPurchaseResponse(ptr: __swift_bridge__$IosIapPurchaseResponse$storekit_error({error.isOwned = false; return error.ptr;}(), { let rustString = localized_description.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }
}
public class IosIapPurchaseResponseRefMut: IosIapPurchaseResponseRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapPurchaseResponseRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapPurchaseResponse: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapPurchaseResponse$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapPurchaseResponse$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapPurchaseResponse) {
        __swift_bridge__$Vec_IosIapPurchaseResponse$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapPurchaseResponse$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapPurchaseResponse(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapPurchaseResponseRef> {
        let pointer = __swift_bridge__$Vec_IosIapPurchaseResponse$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapPurchaseResponseRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapPurchaseResponseRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapPurchaseResponse$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapPurchaseResponseRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapPurchaseResponseRef> {
        UnsafePointer<IosIapPurchaseResponseRef>(OpaquePointer(__swift_bridge__$Vec_IosIapPurchaseResponse$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapPurchaseResponse$len(vecPtr)
    }
}


public class IosIapProductType: IosIapProductTypeRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapProductType$_free(ptr)
        }
    }
}
extension IosIapProductType {
    class public func new_consumable(_ non: Bool) -> IosIapProductType {
        IosIapProductType(ptr: __swift_bridge__$IosIapProductType$new_consumable(non))
    }
}
public class IosIapProductTypeRefMut: IosIapProductTypeRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapProductTypeRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapProductTypeRef {
    class public func new_non_renewable() -> IosIapProductType {
        IosIapProductType(ptr: __swift_bridge__$IosIapProductType$new_non_renewable())
    }

    class public func new_auto_renewable() -> IosIapProductType {
        IosIapProductType(ptr: __swift_bridge__$IosIapProductType$new_auto_renewable())
    }
}
extension IosIapProductType: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapProductType$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapProductType$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapProductType) {
        __swift_bridge__$Vec_IosIapProductType$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapProductType$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapProductType(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapProductTypeRef> {
        let pointer = __swift_bridge__$Vec_IosIapProductType$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapProductTypeRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapProductTypeRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapProductType$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapProductTypeRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapProductTypeRef> {
        UnsafePointer<IosIapProductTypeRef>(OpaquePointer(__swift_bridge__$Vec_IosIapProductType$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapProductType$len(vecPtr)
    }
}


public class IosIapProduct: IosIapProductRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapProduct$_free(ptr)
        }
    }
}
extension IosIapProduct {
    class public func new<GenericIntoRustString: IntoRustString>(_ id: GenericIntoRustString, _ display_price: GenericIntoRustString, _ display_name: GenericIntoRustString, _ description: GenericIntoRustString, _ price: Double, _ product_type: IosIapProductType) -> IosIapProduct {
        IosIapProduct(ptr: __swift_bridge__$IosIapProduct$new({ let rustString = id.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), { let rustString = display_price.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), { let rustString = display_name.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), { let rustString = description.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), price, {product_type.isOwned = false; return product_type.ptr;}()))
    }

    class public func subscription(_ t: IosIapProductRefMut, _ info: IosIapSubscriptionInfo) {
        __swift_bridge__$IosIapProduct$subscription(t.ptr, {info.isOwned = false; return info.ptr;}())
    }
}
public class IosIapProductRefMut: IosIapProductRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapProductRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapProduct: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapProduct$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapProduct$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapProduct) {
        __swift_bridge__$Vec_IosIapProduct$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapProduct$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapProduct(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapProductRef> {
        let pointer = __swift_bridge__$Vec_IosIapProduct$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapProductRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapProductRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapProduct$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapProductRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapProductRef> {
        UnsafePointer<IosIapProductRef>(OpaquePointer(__swift_bridge__$Vec_IosIapProduct$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapProduct$len(vecPtr)
    }
}




import RustXcframework 
public func products_received(_ products: RustVec<IosIapProduct>) {
    __swift_bridge__$products_received({ let val = products; val.isOwned = false; return val.ptr }())
}
public func all_transactions(_ transactions: RustVec<IosIapTransaction>) {
    __swift_bridge__$all_transactions({ let val = transactions; val.isOwned = false; return val.ptr }())
}
public func purchase_processed(_ result: IosIapPurchaseResult) {
    __swift_bridge__$purchase_processed({result.isOwned = false; return result.ptr;}())
}
public func transaction_update(_ t: IosIapTransaction) {
    __swift_bridge__$transaction_update({t.isOwned = false; return t.ptr;}())
}
public func transaction_finished(_ t: IosIapTransactionFinished) {
    __swift_bridge__$transaction_finished({t.isOwned = false; return t.ptr;}())
}
@_cdecl("__swift_bridge__$ios_iap_init")
public func __swift_bridge__ios_iap_init () {
    ios_iap_init()
}

@_cdecl("__swift_bridge__$ios_iap_products")
public func __swift_bridge__ios_iap_products (_ products: UnsafeMutableRawPointer) {
    ios_iap_products(products: RustVec(ptr: products))
}

@_cdecl("__swift_bridge__$ios_iap_purchase")
public func __swift_bridge__ios_iap_purchase (_ id: UnsafeMutableRawPointer) {
    ios_iap_purchase(id: RustString(ptr: id))
}

@_cdecl("__swift_bridge__$ios_iap_transactions_all")
public func __swift_bridge__ios_iap_transactions_all () {
    ios_iap_transactions_all()
}

@_cdecl("__swift_bridge__$ios_iap_transaction_finish")
public func __swift_bridge__ios_iap_transaction_finish (_ id: UInt64) {
    ios_iap_transaction_finish(id: id)
}


public class IosIapTransactionFinished: IosIapTransactionFinishedRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapTransactionFinished$_free(ptr)
        }
    }
}
extension IosIapTransactionFinished {
    class public func finished(_ t: IosIapTransaction) -> IosIapTransactionFinished {
        IosIapTransactionFinished(ptr: __swift_bridge__$IosIapTransactionFinished$finished({t.isOwned = false; return t.ptr;}()))
    }

    class public func error<GenericIntoRustString: IntoRustString>(_ e: GenericIntoRustString) -> IosIapTransactionFinished {
        IosIapTransactionFinished(ptr: __swift_bridge__$IosIapTransactionFinished$error({ let rustString = e.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }

    class public func unknown(_ id: UInt64) -> IosIapTransactionFinished {
        IosIapTransactionFinished(ptr: __swift_bridge__$IosIapTransactionFinished$unknown(id))
    }
}
public class IosIapTransactionFinishedRefMut: IosIapTransactionFinishedRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapTransactionFinishedRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapTransactionFinished: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapTransactionFinished$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapTransactionFinished$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapTransactionFinished) {
        __swift_bridge__$Vec_IosIapTransactionFinished$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapTransactionFinished$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapTransactionFinished(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapTransactionFinishedRef> {
        let pointer = __swift_bridge__$Vec_IosIapTransactionFinished$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapTransactionFinishedRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapTransactionFinishedRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapTransactionFinished$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapTransactionFinishedRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapTransactionFinishedRef> {
        UnsafePointer<IosIapTransactionFinishedRef>(OpaquePointer(__swift_bridge__$Vec_IosIapTransactionFinished$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapTransactionFinished$len(vecPtr)
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
    class public func new_transaction<GenericIntoRustString: IntoRustString>(_ id: UInt64, _ product_id: GenericIntoRustString, _ app_bundle_id: GenericIntoRustString, _ purchase_date: UInt64, _ purchased_quantity: Int32, _ storefront_country_code: GenericIntoRustString, _ signed_date: UInt64, _ is_upgraded: Bool, _ product_type: IosIapProductType, _ reason: IosIapTransactionReason, _ environment: IosIapEnvironment, _ storefront: IosIapStorefront) -> IosIapTransaction {
        IosIapTransaction(ptr: __swift_bridge__$IosIapTransaction$new_transaction(id, { let rustString = product_id.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), { let rustString = app_bundle_id.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), purchase_date, purchased_quantity, { let rustString = storefront_country_code.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), signed_date, is_upgraded, {product_type.isOwned = false; return product_type.ptr;}(), {reason.isOwned = false; return reason.ptr;}(), {environment.isOwned = false; return environment.ptr;}(), {storefront.isOwned = false; return storefront.ptr;}()))
    }

    class public func add_revocation(_ t: IosIapTransactionRefMut, _ date: UInt64) {
        __swift_bridge__$IosIapTransaction$add_revocation(t.ptr, date)
    }

    class public func add_expiration(_ t: IosIapTransactionRefMut, _ date: UInt64) {
        __swift_bridge__$IosIapTransaction$add_expiration(t.ptr, date)
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


public class IosIapPurchaseResult: IosIapPurchaseResultRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$IosIapPurchaseResult$_free(ptr)
        }
    }
}
extension IosIapPurchaseResult {
    class public func unknown<GenericIntoRustString: IntoRustString>(_ id: GenericIntoRustString) -> IosIapPurchaseResult {
        IosIapPurchaseResult(ptr: __swift_bridge__$IosIapPurchaseResult$unknown({ let rustString = id.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }

    class public func error<GenericIntoRustString: IntoRustString>(_ e: GenericIntoRustString) -> IosIapPurchaseResult {
        IosIapPurchaseResult(ptr: __swift_bridge__$IosIapPurchaseResult$error({ let rustString = e.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }
}
public class IosIapPurchaseResultRefMut: IosIapPurchaseResultRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class IosIapPurchaseResultRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension IosIapPurchaseResultRef {
    class public func success() -> IosIapPurchaseResult {
        IosIapPurchaseResult(ptr: __swift_bridge__$IosIapPurchaseResult$success())
    }

    class public func canceled() -> IosIapPurchaseResult {
        IosIapPurchaseResult(ptr: __swift_bridge__$IosIapPurchaseResult$canceled())
    }

    class public func pending() -> IosIapPurchaseResult {
        IosIapPurchaseResult(ptr: __swift_bridge__$IosIapPurchaseResult$pending())
    }
}
extension IosIapPurchaseResult: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_IosIapPurchaseResult$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_IosIapPurchaseResult$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: IosIapPurchaseResult) {
        __swift_bridge__$Vec_IosIapPurchaseResult$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_IosIapPurchaseResult$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (IosIapPurchaseResult(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapPurchaseResultRef> {
        let pointer = __swift_bridge__$Vec_IosIapPurchaseResult$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapPurchaseResultRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<IosIapPurchaseResultRefMut> {
        let pointer = __swift_bridge__$Vec_IosIapPurchaseResult$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return IosIapPurchaseResultRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<IosIapPurchaseResultRef> {
        UnsafePointer<IosIapPurchaseResultRef>(OpaquePointer(__swift_bridge__$Vec_IosIapPurchaseResult$as_ptr(vecPtr)))
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_IosIapPurchaseResult$len(vecPtr)
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




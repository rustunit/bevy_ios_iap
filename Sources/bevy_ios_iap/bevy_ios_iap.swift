import RustXcframework 
public func products_received(_ products: RustVec<IosIapProduct>) {
    __swift_bridge__$products_received({ let val = products; val.isOwned = false; return val.ptr }())
}
@_cdecl("__swift_bridge__$bevy_ios_iap_swift_init")
func __swift_bridge__bevy_ios_iap_swift_init (_ foo: UnsafeMutableRawPointer, _ products: UnsafeMutableRawPointer) {
    bevy_ios_iap_swift_init(foo: RustString(ptr: foo), products: RustVec(ptr: products))
}

@_cdecl("__swift_bridge__$ios_iap_purchase")
func __swift_bridge__ios_iap_purchase (_ id: UnsafeMutableRawPointer) {
    ios_iap_purchase(id: RustString(ptr: id))
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




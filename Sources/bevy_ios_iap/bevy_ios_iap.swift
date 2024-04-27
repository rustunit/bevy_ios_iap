@_cdecl("__swift_bridge__$bevy_ios_iap_swift_init")
func __swift_bridge__bevy_ios_iap_swift_init (_ foo: UnsafeMutableRawPointer, _ products: UnsafeMutableRawPointer) {
    bevy_ios_iap_swift_init(foo: RustString(ptr: foo), products: RustVec(ptr: products))
}




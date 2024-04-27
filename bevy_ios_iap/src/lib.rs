pub fn init() {
    bevy_ios_iap_swift_init(
        "foo".into(),
        vec!["com.rustunit.zoolitaire.levelunlock".into()],
    );
}

use ffi::bevy_ios_iap_swift_init;

type Foo = Box<dyn FnOnce(u8, i32) -> bool>;

#[swift_bridge::bridge]
mod ffi {

    // #[swift_bridge(swift_repr = "struct")]
    // struct Config {
    //     products: Vec<String>,
    // }

    extern "Swift" {

        //
        fn bevy_ios_iap_swift_init(foo: String, products: Vec<String>);
    }
}

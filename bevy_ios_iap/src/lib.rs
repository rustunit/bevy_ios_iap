mod native;

pub fn init() {
    #[cfg(target_os = "ios")]
    native::bevy_ios_iap_swift_init(
        "foo".into(),
        vec!["com.rustunit.zoolitaire.levelunlock".into()],
    );
}

pub fn purchase(id: String) {
    #[cfg(target_os = "ios")]
    native::ios_iap_purchase(id);
}

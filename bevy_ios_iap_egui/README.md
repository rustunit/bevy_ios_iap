# bevy_ios_iap_egui

This helper crate is for interacting with the ios iap api from within your bevy app. It is using [egui](https://github.com/emilk/egui) for the ui.

![demo](../assets/demo.gif)

> Demo from our game using this crate: [zoolitaire.com](https://zoolitaire.com)

# Usage

for now the crate is not published on crates, so it has to be used as a git dependency:

```toml
bevy_ios_iap_egui = { git = "https://github.com/rustunit/bevy_ios_iap.git" }
```

add this to your code:

```rust
// initialize the plugin with the product ids your app uses.
app.add_plugins(IosIapEguiPlugin {
    products_ids: vec!["com.yourapp.product1".into()],
});

// in your system you can toggle the ui with the following command:
commands.trigger(IosIapEguiOpen::Toggle);
```
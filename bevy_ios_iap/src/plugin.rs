use bevy_app::prelude::*;
use bevy_ecs::prelude::*;

use crate::transaction::IosIapTransaction;
use crate::{
    IosIapProductsResponse, IosIapPurchaseResponse, IosIapTransactionFinishResponse,
    IosIapTransactionResponse,
};

/// All possible responses for communication from the native iOS (Swift) side to Rust/Bevy as a reaction to a method call / request.
#[derive(Event, Clone, Debug)]
pub enum IosIapResponse {
    /// Triggered by calls to [`get_products`][crate::get_products]
    Products((i64, IosIapProductsResponse)),
    /// Triggered by calls to [`purchase`][crate::purchase]
    Purchase((i64, IosIapPurchaseResponse)),
    /// Triggered in response to calls to [`finish_transaction`][crate::finish_transaction]
    TransactionFinished((i64, IosIapTransactionFinishResponse)),
    /// Triggered in response to calls to [`all_transactions`][crate::all_transactions]
    AllTransactions((i64, IosIapTransactionResponse)),
    /// Triggered in response to calls to [`current_entitlements`][crate::current_entitlements]
    CurrentEntitlements((i64, IosIapTransactionResponse)),
}

/// Events for pro-active communication from native iOS (Swift) side to Rust/Bevy that are not a direct response to a request.
#[non_exhaustive]
#[derive(Event, Clone, Debug)]
pub enum IosIapEvents {
    /// Triggered automatically by TransactionObserver registered by [`init`][crate::init]
    /// for every update on any Transaction while the app is running.
    TransactionUpdate(IosIapTransaction),
}

/// Bevy plugin to integrate access to iOS StoreKit2
#[allow(dead_code)]
pub struct IosIapPlugin {
    auto_init: bool,
}

impl IosIapPlugin {
    /// create plugin and define whether it will call [`init`][`crate::init`] automatically right on startup.
    pub fn new(auto_init: bool) -> Self {
        Self { auto_init }
    }
}

impl Plugin for IosIapPlugin {
    fn build(&self, app: &mut App) {
        app.add_plugins(crate::request::plugin);

        #[cfg(not(target_os = "ios"))]
        {
            app.add_event::<IosIapEvents>();
            app.add_event::<IosIapResponse>();
        }

        #[cfg(target_os = "ios")]
        {
            use bevy_crossbeam_event::{CrossbeamEventApp, CrossbeamEventSender};

            app.add_crossbeam_event::<IosIapEvents>();

            let sender = app
                .world()
                .get_resource::<CrossbeamEventSender<IosIapEvents>>()
                .unwrap()
                .clone();

            crate::native::set_sender_events(sender);

            app.add_crossbeam_event::<IosIapResponse>();

            let sender = app
                .world()
                .get_resource::<CrossbeamEventSender<IosIapResponse>>()
                .unwrap()
                .clone();

            crate::native::set_sender_response(sender);

            if self.auto_init {
                crate::native::ios_iap_init();
            }
        }
    }
}

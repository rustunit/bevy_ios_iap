use bevy_app::prelude::*;
use bevy_ecs::prelude::*;

use crate::transaction::IosIapTransaction;
use crate::{IosIapProduct, IosIapPurchaseResult, IosIapTransactionFinished};

/// All events for communication from native iOS (Swift) side to Rust/Bevy
#[derive(Event, Clone, Debug)]
pub enum IosIapEvents {
    /// Triggered by calls to [`get_products`][crate::get_products]
    Products(Vec<IosIapProduct>),
    /// Triggered by calls to [`purchase`][crate::purchase]
    Purchase(IosIapPurchaseResult),
    /// Triggered automatically by TransactionObserver registered by [`init`][crate::init]
    /// for every update on any Transaction while app is running.
    Transaction(IosIapTransaction),
    /// Triggered in response to calls to [`finish_transaction`][crate::finish_transaction]
    TransactionFinished(IosIapTransactionFinished),
    /// Triggered in response to calls to [`all_transactions`][crate::all_transactions]
    AllTransactions(Vec<IosIapTransaction>),
    /// Triggered in response to calls to [`current_entitlements`][crate::current_entitlements]
    CurrentEntitlements(Vec<IosIapTransaction>),
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
        #[cfg(not(target_os = "ios"))]
        {
            app.add_event::<IosIapEvents>();
        }

        #[cfg(target_os = "ios")]
        {
            use bevy_crossbeam_event::{CrossbeamEventApp, CrossbeamEventSender};

            app.add_crossbeam_event::<IosIapEvents>();

            let sender = app
                .world
                .get_resource::<CrossbeamEventSender<IosIapEvents>>()
                .unwrap()
                .clone();

            crate::native::set_sender(sender);

            if self.auto_init {
                crate::native::ios_iap_init();
            }
        }
    }
}

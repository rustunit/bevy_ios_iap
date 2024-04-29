use bevy_app::prelude::*;
use bevy_ecs::prelude::*;

use crate::transaction::IosIapTransaction;
use crate::{IosIapProduct, IosIapPurchaseResult};

///
#[derive(Event, Clone, Debug)]
pub enum IosIapEvents {
    Products(Vec<IosIapProduct>),
    Purchase(IosIapPurchaseResult),
    Transaction(IosIapTransaction),

    /// async response to `all_transaction` request
    AllTransactions(Vec<IosIapTransaction>),
}

///
#[allow(dead_code)]
pub struct IosIapPlugin {
    auto_init: bool,
}

impl IosIapPlugin {
    ///
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

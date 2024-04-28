use bevy_app::prelude::*;
use bevy_ecs::prelude::*;

use crate::{IosIapProduct, IosIapPurchaseResult};

#[derive(Event, Clone, Debug)]
pub enum IosIapEvents {
    Products(Vec<IosIapProduct>),
    Purchase(IosIapPurchaseResult),
}

#[allow(dead_code)]
#[derive(Default)]
pub struct IosIapPlugin;

impl Plugin for IosIapPlugin {
    fn build(&self, app: &mut App) {
        // app.init_non_send_resource::<IosNotificationsResource>();

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
        }
    }
}
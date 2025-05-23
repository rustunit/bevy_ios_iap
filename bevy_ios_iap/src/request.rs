use std::marker::PhantomData;

use bevy_app::{App, PreUpdate};
use bevy_ecs::{
    prelude::*,
    system::{EntityCommands, IntoObserverSystem, SystemParam},
};

use crate::{
    IosIapProductsResponse, IosIapPurchaseResponse, IosIapTransactionFinishResponse,
    IosIapTransactionResponse, plugin::IosIapResponse,
};

#[derive(Event, Debug)]
pub struct CurrentEntitlements(pub IosIapTransactionResponse);

#[derive(Event, Debug)]
pub struct Products(pub IosIapProductsResponse);

#[derive(Event, Debug)]
pub struct Purchase(pub IosIapPurchaseResponse);

#[derive(Event, Debug)]
pub struct FinishTransaction(pub IosIapTransactionFinishResponse);

#[derive(Event, Debug)]
pub struct AllTransactions(pub IosIapTransactionResponse);

#[derive(Resource, Default)]
struct BevyIosIapSate {
    request_id: i64,
}

#[derive(Component)]
#[component(storage = "SparseSet")]
struct RequestCurrentEntitlements;

#[derive(Component)]
#[component(storage = "SparseSet")]
struct RequestProducts;

#[derive(Component)]
#[component(storage = "SparseSet")]
struct RequestPurchase;

#[derive(Component)]
#[component(storage = "SparseSet")]
struct RequestFinishTransaction;

#[derive(Component)]
#[component(storage = "SparseSet")]
struct RequestAllTransactions;

#[derive(Component)]
struct RequestId(i64);

#[derive(Component)]
struct RequestEntity;

#[derive(SystemParam)]
pub struct BevyIosIap<'w, 's> {
    commands: Commands<'w, 's>,
    res: ResMut<'w, BevyIosIapSate>,
}

impl BevyIosIap<'_, '_> {
    pub fn current_entitlements(&mut self) -> BevyIosIapRequestBuilder<'_, CurrentEntitlements> {
        let id = self.res.request_id;
        self.res.request_id += 1;
        crate::methods::current_entitlements(id);
        BevyIosIapRequestBuilder::new(self.commands.spawn((
            RequestCurrentEntitlements,
            RequestId(id),
            RequestEntity,
        )))
    }

    pub fn products(&mut self, products: Vec<String>) -> BevyIosIapRequestBuilder<'_, Products> {
        let id = self.res.request_id;
        self.res.request_id += 1;
        crate::methods::get_products(id, products);
        BevyIosIapRequestBuilder::new(self.commands.spawn((
            RequestProducts,
            RequestId(id),
            RequestEntity,
        )))
    }

    pub fn purchase(&mut self, product_id: String) -> BevyIosIapRequestBuilder<'_, Purchase> {
        let id = self.res.request_id;
        self.res.request_id += 1;
        crate::methods::purchase(id, product_id);
        BevyIosIapRequestBuilder::new(self.commands.spawn((
            RequestPurchase,
            RequestId(id),
            RequestEntity,
        )))
    }

    pub fn finish_transaction(
        &mut self,
        transaction_id: u64,
    ) -> BevyIosIapRequestBuilder<'_, FinishTransaction> {
        let id = self.res.request_id;
        self.res.request_id += 1;
        crate::methods::finish_transaction(id, transaction_id);
        BevyIosIapRequestBuilder::new(self.commands.spawn((
            RequestFinishTransaction,
            RequestId(id),
            RequestEntity,
        )))
    }

    pub fn all_transactions(&mut self) -> BevyIosIapRequestBuilder<'_, AllTransactions> {
        let id = self.res.request_id;
        self.res.request_id += 1;
        crate::methods::all_transactions(id);
        BevyIosIapRequestBuilder::new(self.commands.spawn((
            RequestAllTransactions,
            RequestId(id),
            RequestEntity,
        )))
    }
}

pub struct BevyIosIapRequestBuilder<'a, T>(EntityCommands<'a>, PhantomData<T>);

impl<'a, T> BevyIosIapRequestBuilder<'a, T>
where
    T: 'static + Event,
{
    fn new(ec: EntityCommands<'a>) -> Self {
        Self(ec, PhantomData)
    }

    pub fn on_response<RB: Bundle, RM, OR: IntoObserverSystem<T, RB, RM>>(
        &mut self,
        on_response: OR,
    ) -> &mut Self {
        self.0.observe(on_response);
        self
    }
}

#[derive(Debug, Hash, PartialEq, Eq, Clone, SystemSet)]
pub struct BevyIosIapSet;

pub fn plugin(app: &mut App) {
    app.init_resource::<BevyIosIapSate>();
    app.add_systems(
        PreUpdate,
        (
            cleanup_finished_requests,
            process_events.run_if(on_event::<IosIapResponse>),
        )
            .chain()
            .in_set(BevyIosIapSet),
    );
}

fn cleanup_finished_requests(
    mut commands: Commands,
    query: Query<Entity, (With<RequestEntity>, Without<RequestId>)>,
) {
    for e in query.iter() {
        if let Ok(mut ec) = commands.get_entity(e) {
            ec.despawn();
        }
    }
}

#[allow(unused_variables, unused_mut)]
fn process_events(
    mut events: EventReader<IosIapResponse>,
    mut commands: Commands,
    query_current_entitlements: Query<(Entity, &RequestId), With<RequestCurrentEntitlements>>,
    query_products: Query<(Entity, &RequestId), With<RequestProducts>>,
    query_purchases: Query<(Entity, &RequestId), With<RequestPurchase>>,
) {
    for e in events.read() {
        match e {
            IosIapResponse::CurrentEntitlements((r, response)) => {
                for (e, id) in &query_current_entitlements {
                    if id.0 == *r {
                        commands.trigger_targets(CurrentEntitlements(response.clone()), e);
                        if let Ok(mut ec) = commands.get_entity(e) {
                            ec.remove::<RequestId>();
                        }
                        break;
                    }
                }
            }
            IosIapResponse::Products((r, response)) => {
                for (e, id) in &query_products {
                    if id.0 == *r {
                        commands.trigger_targets(Products(response.clone()), e);
                        if let Ok(mut ec) = commands.get_entity(e) {
                            ec.remove::<RequestId>();
                        }
                        break;
                    }
                }
            }
            IosIapResponse::Purchase((r, response)) => {
                for (e, id) in &query_purchases {
                    if id.0 == *r {
                        commands.trigger_targets(Purchase(response.clone()), e);
                        if let Ok(mut ec) = commands.get_entity(e) {
                            ec.remove::<RequestId>();
                        }
                        break;
                    }
                }
            }
            IosIapResponse::TransactionFinished((r, response)) => {
                for (e, id) in &query_purchases {
                    if id.0 == *r {
                        commands.trigger_targets(FinishTransaction(response.clone()), e);
                        if let Ok(mut ec) = commands.get_entity(e) {
                            ec.remove::<RequestId>();
                        }
                        break;
                    }
                }
            }
            IosIapResponse::AllTransactions((r, response)) => {
                for (e, id) in &query_purchases {
                    if id.0 == *r {
                        commands.trigger_targets(AllTransactions(response.clone()), e);
                        if let Ok(mut ec) = commands.get_entity(e) {
                            ec.remove::<RequestId>();
                        }
                        break;
                    }
                }
            }
        }
    }
}

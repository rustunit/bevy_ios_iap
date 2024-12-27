use bevy::prelude::*;
use bevy_egui::{egui, EguiContexts, EguiPlugin};
use bevy_ios_iap::{
    IosIapEvents, IosIapProduct, IosIapProductsResponse, IosIapResponse, IosIapTransaction,
    IosIapTransactionResponse,
};
use egui_extras::{Column, TableBuilder};

#[derive(Event)]
pub enum IosIapEguiOpen {
    Toggle,
    Open,
    Close,
}

#[derive(Resource, Default)]
struct DebugUiResource {
    open: bool,
}

#[derive(Resource, Default)]
struct DebugIosIap {
    products_ids: Vec<String>,
    iap_events: Vec<String>,
    iap_products: Vec<IosIapProduct>,
    iap_transactions: Vec<IosIapTransaction>,
}

pub struct IosIapEguiPlugin {
    pub products_ids: Vec<String>,
}

impl Plugin for IosIapEguiPlugin {
    fn build(&self, app: &mut App) {
        if !app.is_plugin_added::<EguiPlugin>() {
            app.add_plugins(EguiPlugin);
        }

        app.init_resource::<DebugUiResource>();
        app.init_resource::<DebugIosIap>();

        app.insert_resource(DebugIosIap {
            products_ids: self.products_ids.clone(),
            ..default()
        });

        app.add_systems(Update, update);
        app.add_systems(
            Update,
            process_iap_responses.run_if(on_event::<IosIapResponse>),
        );
        app.add_systems(Update, process_iap_events.run_if(on_event::<IosIapEvents>));

        app.add_observer(on_toggle);
    }
}

fn on_toggle(trigger: Trigger<IosIapEguiOpen>, mut res: ResMut<DebugUiResource>) {
    match trigger.event() {
        IosIapEguiOpen::Toggle => res.open = !res.open,
        IosIapEguiOpen::Open => res.open = true,
        IosIapEguiOpen::Close => res.open = false,
    }
}

fn process_iap_responses(mut events: EventReader<IosIapResponse>, mut res: ResMut<DebugIosIap>) {
    for e in events.read() {
        match e {
            IosIapResponse::Products((_r, IosIapProductsResponse::Done(products))) => {
                res.iap_events.push(format!("Products: {}", products.len()));
                res.iap_products.clone_from(products);
            }
            IosIapResponse::AllTransactions((_r, IosIapTransactionResponse::Done(t))) => {
                res.iap_events
                    .push(format!("All Transactions: {}", t.len()));
                res.iap_transactions.clone_from(t);
            }
            IosIapResponse::CurrentEntitlements((r, IosIapTransactionResponse::Done(t))) => {
                res.iap_events
                    .push(format!("Current Entitlements: {} [{r}]", t.len()));
                res.iap_transactions.clone_from(t);
            }
            IosIapResponse::TransactionFinished((_r, t)) => match t {
                bevy_ios_iap::IosIapTransactionFinishResponse::Finished(t) => {
                    res.iap_events.push(format!(
                        "TransactionFinished: {} '{:?}'",
                        t.id, t.product_id
                    ));
                }
                _ => {
                    res.iap_events.push(format!("TransactionFinished: {:?}", t));
                }
            },
            IosIapResponse::Purchase((_r, t)) => match t {
                bevy_ios_iap::IosIapPurchaseResponse::Success(t) => {
                    res.iap_events
                        .push(format!("Purchase({},'{:?}')", t.id, t.product_id));
                }
                _ => {
                    res.iap_events.push(format!("{:?}", t));
                }
            },
            _ => res.iap_events.push(format!("{:?}", e)),
        }
    }
}

fn process_iap_events(mut events: EventReader<IosIapEvents>, mut res: ResMut<DebugIosIap>) {
    for e in events.read() {
        match e {
            IosIapEvents::TransactionUpdate(t) => {
                res.iap_events
                    .push(format!("Transaction: [{}] {}", t.id, t.product_id));
            }
            _ => res.iap_events.push(format!("{:?}", e)),
        }
    }
}

fn update(
    mut contexts: EguiContexts,
    mut res: ResMut<DebugUiResource>,
    mut res_iap: ResMut<DebugIosIap>,
) {
    let mut open_state = res.open;
    let Some(ctx) = contexts.try_ctx_mut() else {
        return;
    };

    egui::Window::new("bevy_ios_iap")
        .open(&mut open_state)
        .show(ctx, |ui| {
            ios_iap_ui(ui, &mut res_iap);
        });

    res.open = open_state;
}

fn ios_iap_ui(ui: &mut egui::Ui, res: &mut ResMut<DebugIosIap>) {
    ui.collapsing("products", |ui| {
        ui.label(format!("count: {}", res.iap_products.len()));

        if ui.button("get products").clicked() {
            bevy_ios_iap::get_products(-1, res.products_ids.clone());
        }

        if ui.button("buy invalid product id").clicked() {
            bevy_ios_iap::purchase(-1, "invalid.id".into());
        }

        TableBuilder::new(ui)
            .column(Column::auto())
            .column(Column::initial(200.).resizable(true))
            .column(Column::remainder())
            .header(20.0, |mut header| {
                header.col(|ui| {
                    ui.heading("buy");
                });
                header.col(|ui| {
                    ui.heading("id");
                });
                header.col(|ui| {
                    ui.heading("$");
                });
            })
            .body(|mut body| {
                for p in &res.iap_products {
                    body.row(30.0, |mut row| {
                        row.col(|ui| {
                            if ui.button("buy").clicked() {
                                bevy_ios_iap::purchase(-1, p.id.clone());
                            }
                        });
                        row.col(|ui| {
                            ui.label(p.id.clone());
                        });
                        row.col(|ui| {
                            ui.label(p.display_price.clone());
                        });
                    });
                }
            });
    });

    ui.collapsing("transactions", |ui| {
        ui.label(format!("count: {}", res.iap_transactions.len()));

        if ui.button("fetch all").clicked() {
            bevy_ios_iap::all_transactions(-1);
        }

        if ui.button("fetch current").clicked() {
            bevy_ios_iap::current_entitlements(-1);
        }

        TableBuilder::new(ui)
            .column(Column::initial(15.))
            .column(Column::auto())
            .column(Column::initial(200.).resizable(true))
            .column(Column::remainder())
            .header(20.0, |mut header| {
                header.col(|ui| {
                    ui.heading("id");
                });
                header.col(|ui| {
                    ui.heading("reason");
                });
                header.col(|ui| {
                    ui.heading("product");
                });
                header.col(|ui| {
                    ui.heading("date");
                });
            })
            .body(|mut body| {
                for p in &res.iap_transactions {
                    body.row(30.0, |mut row| {
                        row.col(|ui| {
                            ui.label(p.id.to_string());
                        });
                        row.col(|ui| {
                            ui.label(format!("{:?}", p.reason));
                        });
                        row.col(|ui| {
                            ui.label(p.product_id.clone());
                        });
                        row.col(|ui| {
                            ui.label(p.purchase_date.to_string());
                        });
                    });
                }
            });
    });

    ui.collapsing("events", |ui| {
        ui.label(format!("received: {}", res.iap_events.len()));

        let mut string = res.iap_events.join("\n");
        ui.text_edit_multiline(&mut string);

        if ui.button("clear").clicked() {
            res.iap_events.clear();
        }
    });
}

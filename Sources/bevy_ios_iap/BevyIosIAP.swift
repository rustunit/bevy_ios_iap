//
//  File.swift
//  
//
//  Created by Stephan on 26.04.24.
//

import StoreKit
import RustXcframework


public func bevy_ios_iap_swift_init(foo: RustString, products:RustVec<RustString>)
{
    print("bevy_ios_iap_swift_init: \(foo.toString())")
    
    Task {
        let productIds = ["com.rustunit.zoolitaire.levelunlock"]
        let products = try await Product.products(for: productIds)
        print("products:\n \(products)")
        
        let rust_products = RustVec<IosIapProduct>()
        
        for product in products {
            let type = if product.type == Product.ProductType.consumable {
                 IosIapProductType.new_consumable(false)
            } else if product.type == Product.ProductType.nonConsumable {
                 IosIapProductType.new_consumable(true)
            } else if product.type == Product.ProductType.nonRenewable {
                IosIapProductType.new_non_renewable()
            } else {
                 IosIapProductType.new_auto_renewable()
            }
            
            rust_products.push(value: IosIapProduct.new(product.id, product.displayPrice, product.displayName, product.description, Double(truncating: product.price as NSNumber), type))
        }
        
        products_received(rust_products)
   }
}

public func ios_iap_purchase(id: RustString)
{
    Task {
        let productIds = [id.toString()]
        let products = try await Product.products(for: productIds)
        let purchase  = try! await products[0].purchase()
        print("purchase:\n \(purchase)")
   }
}

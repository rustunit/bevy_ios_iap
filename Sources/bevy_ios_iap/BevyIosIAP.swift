//
//  File.swift
//  
//
//  Created by Stephan on 26.04.24.
//

import StoreKit

public func bevy_ios_iap_swift_init(foo: RustString, products:RustVec<RustString>)
{
    print("bevy_ios_iap_swift_init: \(foo.toString())")
    
    Task {
        let productIds = ["com.rustunit.zoolitaire.levelunlock"]
        let products = try await Product.products(for: productIds)

        print("products:")
        print(products)

        let purchase  = try! await products[0].purchase()
        print("purchase:")
        print(purchase)
   }
}

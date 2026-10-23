//
//  ProductDetail.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import StoreKit
import SwiftUI

struct ProductDetail: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading) {
            // Subscriptions are told apart by name; a tip's description says it all.
            if product.type == .autoRenewable {
                Text(product.displayName)
                    .bold()
            }

            Text(product.description)
        }
        .accessibilityElement(children: .combine)
    }
}

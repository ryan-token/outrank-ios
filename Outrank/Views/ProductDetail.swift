//
//  ProductDetail.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import SwiftUI
import StoreKit

struct ProductDetail: View {
    let product: Product

    var body: some View {
        if product.type == .autoRenewable {
            VStack(alignment: .leading) {
                Text(product.displayName).bold()
                Text(product.description)
            }
            .accessibilityLabel(product.description)
        } else {
            Text(product.description)
                .frame(alignment: .leading)
        }
    }
}

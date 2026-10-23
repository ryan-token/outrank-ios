//
//  SubscribeButtonLabel.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import StoreKit
import SwiftUI

/// What the subscribe button shows: a checkmark once purchased, otherwise the price.
struct SubscribeButtonLabel: View {
    let product: Product
    let isPurchased: Bool

    var body: some View {
        if isPurchased {
            Image(systemName: "checkmark")
                .bold()
                .foregroundStyle(.white)
                .accessibilityLabel("Subscribed")
        } else if let subscription = product.subscription {
            SubscribePrice(product: product, period: subscription.subscriptionPeriod)
        } else {
            Text(product.displayPrice)
                .foregroundStyle(.white)
                .bold()
        }
    }
}

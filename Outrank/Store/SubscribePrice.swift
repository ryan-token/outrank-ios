//
//  SubscribePrice.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import StoreKit
import SwiftUI

/// A whole-currency price over its billing period, such as "$5" above "year".
struct SubscribePrice: View {
    let product: Product
    let period: Product.SubscriptionPeriod

    private var unitLabel: String {
        let value = period.value
        let plural = value > 1

        return switch period.unit {
        case .day: plural ? "\(value) days" : "day"
        case .week: plural ? "\(value) weeks" : "week"
        case .month: plural ? "\(value) months" : "month"
        case .year: plural ? "\(value) years" : "year"
        @unknown default: "period"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(product.wholeCurrencyPrice)
                .bold()

            Divider()
                .overlay(.white)

            Text(unitLabel)
                .font(.caption)
        }
        .foregroundStyle(.white)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(product.displayPrice) per \(unitLabel)")
    }
}

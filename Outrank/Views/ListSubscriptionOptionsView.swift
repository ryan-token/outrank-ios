//
//  ListSubscriptionOptionsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import OSLog
import StoreKit
import SwiftUI

struct ListSubscriptionOptionsView: View {
    @Environment(Store.self) private var store

    @State private var errorTitle = ""
    @State private var isShowingError = false
    @State private var tapTrigger = 0
    @State private var errorTrigger = 0

    let product: Product
    var purchasingEnabled: Bool = true

    private let logger = Logger(subsystem: "com.ryantoken.Outrank", category: "ListSubscriptionOptionsView")

    private var isPurchased: Bool {
        store.purchasedIdentifiers.contains(product.id)
    }

    var body: some View {
        HStack {
            ProductDetail(product: product)

            if purchasingEnabled {
                Spacer()
                buyButton
                    .buttonStyle(SubscribeButtonStyle(isPurchased: isPurchased))
                    .disabled(isPurchased)
            }
        }
        .alert(errorTitle, isPresented: $isShowingError) { }
        .sensoryFeedback(.success, trigger: tapTrigger)
        .sensoryFeedback(.error, trigger: errorTrigger)
    }

    private var buyButton: some View {
        Button {
            Task { await buy() }
        } label: {
            if isPurchased {
                Image(systemName: "checkmark")
                    .bold()
                    .foregroundStyle(.white)
            } else if let subscription = product.subscription {
                SubscribePrice(product: product, subscription: subscription)
            } else {
                Text(product.displayPrice)
                    .foregroundStyle(.white)
                    .bold()
            }
        }
    }

    private func buy() async {
        tapTrigger += 1
        do {
            _ = try await store.purchase(product)
        } catch {
            errorTrigger += 1
            errorTitle = "Your purchase could not be completed. Please try again."
            isShowingError = true
            logger.error("Failed purchase for \(product.id, privacy: .public): \(error.localizedDescription)")
        }
    }
}

private struct SubscribePrice: View {
    let product: Product
    let subscription: Product.SubscriptionInfo

    private var unitLabel: String {
        let value = subscription.subscriptionPeriod.value
        let plural = value > 1

        switch subscription.subscriptionPeriod.unit {
        case .day: return plural ? "\(value) days" : "day"
        case .week: return plural ? "\(value) weeks" : "week"
        case .month: return plural ? "\(value) months" : "month"
        case .year: return plural ? "\(value) years" : "year"
        @unknown default: return "period"
        }
    }

    var body: some View {
        VStack {
            Text(product.wholeCurrencyPrice)
                .foregroundStyle(.white)
                .bold()
                .padding(EdgeInsets(top: -4, leading: 0, bottom: -8, trailing: 0))

            Divider().background(Color.white)

            Text(unitLabel)
                .foregroundStyle(.white)
                .font(.system(size: 12))
                .padding(EdgeInsets(top: -8, leading: 0, bottom: -4, trailing: 0))
        }
        .accessibilityLabel("\(product.displayPrice) per year")
    }
}

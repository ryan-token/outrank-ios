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

    @State private var isPurchased = false
    @State private var errorTitle = ""
    @State private var isShowingError = false

    let product: Product
    var purchasingEnabled: Bool = true

    private let logger = Logger(subsystem: "com.ryantoken.Outrank", category: "ListSubscriptionOptionsView")

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
        .task {
            isPurchased = (try? await store.isPurchased(product.id)) ?? false
        }
        .onChange(of: store.purchasedIdentifiers) {
            isPurchased = store.purchasedIdentifiers.contains(product.id)
        }
    }

    private func buy() async {
        do {
            if try await store.purchase(product) != nil {
                withAnimation {
                    isPurchased = true
                }
            } else {
                HapticGenerator.playErrorHaptic()
            }
        } catch {
            HapticGenerator.playErrorHaptic()
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

    private var wholeNumberPrice: String {
        switch product.displayPrice {
        case "$0.99": "$1"
        case "$2.99": "$3"
        case "$4.99": "$5"
        case "$9.99": "$10"
        default: "Unknown"
        }
    }

    var body: some View {
        VStack {
            Text(wholeNumberPrice)
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

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

    @State private var isShowingError = false
    @State private var purchaseTrigger = 0
    @State private var errorTrigger = 0

    let product: Product
    var purchasingEnabled = true

    private static let logger = Logger(category: "ListSubscriptionOptionsView")

    private var isPurchased: Bool {
        store.purchasedIdentifiers.contains(product.id)
    }

    var body: some View {
        HStack {
            ProductDetail(product: product)

            if purchasingEnabled {
                Spacer()

                Button(action: purchase) {
                    SubscribeButtonLabel(product: product, isPurchased: isPurchased)
                }
                .buttonStyle(.subscribe(isPurchased: isPurchased))
                .disabled(isPurchased)
            }
        }
        .alert("Your purchase could not be completed. Please try again.", isPresented: $isShowingError) { }
        .sensoryFeedback(.success, trigger: purchaseTrigger)
        .sensoryFeedback(.error, trigger: errorTrigger)
    }

    private func purchase() {
        Task { await buy() }
    }

    private func buy() async {
        do {
            // Nil when the user cancels or the purchase is pending approval.
            if try await store.purchase(product) != nil {
                purchaseTrigger += 1
            }
        } catch {
            errorTrigger += 1
            isShowingError = true
            Self.logger.error("Failed purchase for \(product.id, privacy: .public): \(String(describing: error))")
        }
    }
}

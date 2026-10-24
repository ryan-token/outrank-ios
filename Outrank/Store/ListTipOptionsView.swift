//
//  ListTipOptionsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import OSLog
import StoreKit
import SwiftUI

struct ListTipOptionsView: View {
    @Environment(Store.self) private var store

    @State private var isShowingError = false
    @State private var purchaseTrigger = 0
    @State private var errorTrigger = 0

    let product: Product
    var purchasingEnabled = true

    private static let logger = Logger(category: "ListTipOptionsView")

    var body: some View {
        HStack {
            Text(store.emoji(for: product.id))
                .font(.largeTitle)
                .accessibilityHidden(true)

            ProductDetail(product: product)

            if purchasingEnabled {
                Spacer()

                Button(action: purchase) {
                    Text(product.wholeCurrencyPrice)
                        .foregroundStyle(.white)
                        .bold()
                }
                .buttonStyle(.buy)
                .accessibilityLabel("Tip \(product.displayPrice)")
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

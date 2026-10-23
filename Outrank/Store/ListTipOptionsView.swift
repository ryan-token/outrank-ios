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
    @State private var tapTrigger = 0
    @State private var errorTrigger = 0

    let product: Product
    var purchasingEnabled = true

    private static let logger = Logger(subsystem: "com.ryantoken.Outrank", category: "ListTipOptionsView")

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
        .sensoryFeedback(.success, trigger: tapTrigger)
        .sensoryFeedback(.error, trigger: errorTrigger)
    }

    private func purchase() {
        Task { await buy() }
    }

    private func buy() async {
        tapTrigger += 1
        do {
            _ = try await store.purchase(product)
        } catch {
            errorTrigger += 1
            isShowingError = true
            Self.logger.error("Failed purchase for \(product.id, privacy: .public): \(error.localizedDescription)")
        }
    }
}

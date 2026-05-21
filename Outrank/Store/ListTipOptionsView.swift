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

    @State private var errorTitle = ""
    @State private var isShowingError = false
    @State private var tapTrigger = 0
    @State private var errorTrigger = 0

    let product: Product
    var purchasingEnabled: Bool = true

    private let logger = Logger(subsystem: "com.ryantoken.Outrank", category: "ListTipOptionsView")

    private var emoji: String {
        store.emoji(for: product.id)
    }

    var body: some View {
        HStack {
            Text(emoji)
                .font(.system(size: 40))
                .frame(width: 50, height: 50)
                .clipShape(.rect(cornerRadius: 15, style: .continuous))
                .padding(.trailing, 20)
                .accessibilityHidden(true)

            ProductDetail(product: product)

            if purchasingEnabled {
                Spacer()
                Button {
                    Task { await buy() }
                } label: {
                    Text(product.wholeCurrencyPrice)
                        .foregroundStyle(.white)
                        .bold()
                }
                .buttonStyle(BuyButtonStyle())
                .accessibilityLabel("Tip \(product.displayPrice)")
            }
        }
        .alert(errorTitle, isPresented: $isShowingError) { }
        .sensoryFeedback(.success, trigger: tapTrigger)
        .sensoryFeedback(.error, trigger: errorTrigger)
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

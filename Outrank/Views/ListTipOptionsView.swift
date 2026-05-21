//
//  ListTipOptionsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import SwiftUI
import StoreKit

struct ListTipOptionsView: View {
    @Environment(Store.self) private var store

    @State private var errorTitle = ""
    @State private var isShowingError = false

    let product: Product
    var purchasingEnabled: Bool = true

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
                    Text(convertToWholeNumber(product.displayPrice))
                        .foregroundStyle(.white)
                        .bold()
                }
                .buttonStyle(BuyButtonStyle())
                .accessibilityLabel("Tip \(product.displayPrice)")
            }
        }
        .alert(errorTitle, isPresented: $isShowingError) { }
    }

    private func buy() async {
        HapticGenerator.playSuccessHaptic()
        do {
            _ = try await store.purchase(product)
        } catch StoreError.failedVerification {
            HapticGenerator.playErrorHaptic()
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch {
            HapticGenerator.playErrorHaptic()
            print("Failed purchase for \(product.id): \(error)")
        }
    }

    private func convertToWholeNumber(_ price: String) -> String {
        switch price {
        case "$0.99": "$1"
        case "$2.99": "$3"
        case "$4.99": "$5"
        case "$9.99": "$10"
        default: "Unknown"
        }
    }
}

//
//  SubscriptionsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import SwiftUI
import StoreKit

struct SubscriptionsView: View {
    @Environment(Store.self) private var store

    @State private var currentSubscription: Product?
    @State private var status: Product.SubscriptionInfo.Status?

    var body: some View {
        List {
            Group {
                if let currentSubscription {
                    Section("My Subscription") {
                        ListSubscriptionOptionsView(product: currentSubscription, purchasingEnabled: false)

                        if let status {
                            StatusInfoView(product: currentSubscription, status: status)
                        }
                    }
                }

                Section("Subscription Options") {
                    ForEach(store.subscriptions) { subscription in
                        ListSubscriptionOptionsView(product: subscription)
                    }
                }

                Section {
                    Text("Outrank is free with no ads. If you find it useful, please consider supporting development by tipping annually.")
                        .foregroundStyle(.secondary)
                }
            }
            .task(id: store.purchasedIdentifiers) {
                await updateSubscriptionStatus()
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Subscriptions")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Restore Purchases", action: restorePurchases)
            }
        }
    }

    private func updateSubscriptionStatus() async {
        do {
            guard let product = store.subscriptions.first,
                  let statuses = try await product.subscription?.status else {
                return
            }

            var highestStatus: Product.SubscriptionInfo.Status?
            var highestProduct: Product?

            for status in statuses {
                switch status.state {
                case .expired, .revoked:
                    continue
                default:
                    let renewalInfo = try store.checkVerified(status.renewalInfo)

                    guard let newSubscription = store.subscriptions.first(where: { $0.id == renewalInfo.currentProductID }) else {
                        continue
                    }

                    guard let currentProduct = highestProduct else {
                        highestStatus = status
                        highestProduct = newSubscription
                        continue
                    }

                    let highestTier = store.tier(for: currentProduct.id)
                    let newTier = store.tier(for: renewalInfo.currentProductID)

                    if newTier > highestTier {
                        highestStatus = status
                        highestProduct = newSubscription
                    }
                }
            }

            status = highestStatus
            currentSubscription = highestProduct
        } catch {
            print("Could not update subscription status \(error)")
        }
    }

    private func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

#Preview {
    NavigationStack {
        SubscriptionsView()
            .environment(Store())
    }
}

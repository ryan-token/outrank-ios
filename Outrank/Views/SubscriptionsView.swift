//
//  SubscriptionsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import OSLog
import StoreKit
import SwiftUI

struct SubscriptionsView: View {
    @Environment(Store.self) private var store

    @State private var currentSubscription: Product?
    @State private var status: Product.SubscriptionInfo.Status?
    @State private var isShowingManageSubscriptions = false

    private let logger = Logger(subsystem: "com.ryantoken.Outrank", category: "SubscriptionsView")

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
        .manageSubscriptionsSheet(isPresented: $isShowingManageSubscriptions)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu("More", systemImage: "ellipsis.circle") {
                    Button("Manage Subscription", systemImage: "creditcard") {
                        isShowingManageSubscriptions = true
                    }
                    .disabled(currentSubscription == nil)

                    Button("Restore Purchases", systemImage: "arrow.clockwise") {
                        Task { await restorePurchases() }
                    }
                }
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
                    let renewalInfo = try status.renewalInfo.payloadValue

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
            logger.error("Could not update subscription status: \(error.localizedDescription)")
        }
    }

    private func restorePurchases() async {
        do {
            try await store.restorePurchases()
        } catch {
            HapticGenerator.playErrorHaptic()
            logger.error("Restore purchases failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NavigationStack {
        SubscriptionsView()
            .environment(Store())
    }
}

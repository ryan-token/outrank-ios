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
    @State private var isShowingRestoreError = false
    @State private var restoreErrorTrigger = 0

    private static let logger = Logger(category: "SubscriptionsView")

    var body: some View {
        List {
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
                Text("""
                    Outrank is free with no ads. If you find it useful, please consider supporting \
                    development by tipping annually.
                    """)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Subscriptions")
        .task(id: store.purchasedIdentifiers) {
            await updateSubscriptionStatus()
        }
        .manageSubscriptionsSheet(isPresented: $isShowingManageSubscriptions)
        .sensoryFeedback(.error, trigger: restoreErrorTrigger)
        .alert("Couldn't Restore Purchases", isPresented: $isShowingRestoreError) {
        } message: {
            Text("Please check your connection and try again.")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // A descriptive symbol rather than an ellipsis, which the system reserves
                // for its own toolbar overflow menu.
                Menu("Account", systemImage: "person.crop.circle") {
                    Button("Manage Subscription", systemImage: "creditcard", action: showManageSubscriptions)
                        .disabled(currentSubscription == nil)

                    Button("Restore Purchases", systemImage: "arrow.clockwise", action: restore)
                }
            }
        }
    }

    private func showManageSubscriptions() {
        isShowingManageSubscriptions = true
    }

    private func restore() {
        Task { await restorePurchases() }
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

                    guard let newSubscription = store.subscriptions.first(where: {
                        $0.id == renewalInfo.currentProductID
                    }) else {
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
            Self.logger.error("Could not update subscription status: \(String(describing: error))")
        }
    }

    private func restorePurchases() async {
        do {
            try await store.restorePurchases()
        } catch StoreKitError.userCancelled {
            // Dismissing the Apple Account sign-in isn't a failure worth an alert.
        } catch {
            restoreErrorTrigger += 1
            isShowingRestoreError = true
            Self.logger.error("Restore purchases failed: \(String(describing: error))")
        }
    }
}

#Preview {
    NavigationStack {
        SubscriptionsView()
            .environment(Store())
    }
}

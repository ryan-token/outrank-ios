//
//  Store.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import Foundation
import OSLog
import StoreKit

typealias Transaction = StoreKit.Transaction
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo

nonisolated enum StoreError: Error {
    case failedVerification
}

nonisolated enum SubscriptionTier: Int, Comparable {
    case none = 0
    case small = 1
    case medium = 2
    case large = 3
    case giant = 4

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

@Observable
final class Store {
    private(set) var tips: [Product] = []
    private(set) var subscriptions: [Product] = []
    private(set) var purchasedIdentifiers: Set<String> = []

    private var updateListenerTask: Task<Void, Never>?

    private let productIdToEmoji: [String: String]
    private let logger = Logger(subsystem: "com.ryantoken.Outrank", category: "Store")

    init() {
        if let url = Bundle.main.url(forResource: "Products", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: String] {
            productIdToEmoji = plist
        } else {
            productIdToEmoji = [:]
        }

        // Start a transaction listener as close to app launch as possible so we don't miss any transactions.
        updateListenerTask = listenForTransactions()

        Task {
            await requestProducts()
            await refreshPurchasedIdentifiers()
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                do {
                    let transaction = try result.payloadValue
                    updatePurchasedIdentifiers(transaction)
                    await transaction.finish()
                } catch {
                    logger.error("Transaction failed verification: \(error.localizedDescription)")
                }
            }
        }
    }

    func requestProducts() async {
        do {
            let storeProducts = try await Product.products(for: productIdToEmoji.keys)

            var newTips: [Product] = []
            var newSubscriptions: [Product] = []

            for product in storeProducts {
                switch product.type {
                case .consumable:
                    newTips.append(product)
                case .autoRenewable:
                    newSubscriptions.append(product)
                default:
                    logger.notice("Ignoring product \(product.id, privacy: .public) of type \(String(describing: product.type), privacy: .public)")
                }
            }

            tips = sortByPrice(newTips)
            subscriptions = sortByPrice(newSubscriptions)
        } catch {
            logger.error("Failed product request: \(error.localizedDescription)")
        }
    }

    /// Reads `Transaction.currentEntitlements` and rebuilds the set of purchased identifiers.
    /// Useful at launch and after `AppStore.sync()` to reflect any restored purchases.
    func refreshPurchasedIdentifiers() async {
        var ids: Set<String> = []
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result,
                  transaction.revocationDate == nil,
                  !transaction.isUpgraded
            else { continue }
            ids.insert(transaction.productID)
        }
        purchasedIdentifiers = ids
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        HapticGenerator.playSuccessHaptic()

        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try verification.payloadValue
            updatePurchasedIdentifiers(transaction)
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        @unknown default:
            return nil
        }
    }

    /// Restores the user's purchases by syncing with the App Store, then refreshes entitlements.
    func restorePurchases() async throws {
        try await AppStore.sync()
        await refreshPurchasedIdentifiers()
    }

    func isPurchased(_ productIdentifier: String) async throws -> Bool {
        // For subscriptions, a user can upgrade in the middle of their subscription period. The lower service
        // tier will then have the `isUpgraded` flag set and there will be a new transaction for the higher service
        // tier. Ignore the lower service tier transactions which have been upgraded.
        guard let result = await Transaction.latest(for: productIdentifier) else {
            return false
        }

        let transaction = try result.payloadValue
        return transaction.revocationDate == nil && !transaction.isUpgraded
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        try result.payloadValue
    }

    func updatePurchasedIdentifiers(_ transaction: Transaction) {
        if transaction.revocationDate == nil {
            purchasedIdentifiers.insert(transaction.productID)
        } else {
            purchasedIdentifiers.remove(transaction.productID)
        }
    }

    func emoji(for productId: String) -> String {
        productIdToEmoji[productId] ?? ""
    }

    func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted { $0.price < $1.price }
    }

    func tier(for productId: String) -> SubscriptionTier {
        switch productId {
        case "subscription.small": .small
        case "subscription.medium": .medium
        case "subscription.large": .large
        case "subscription.giant": .giant
        default: .none
        }
    }
}

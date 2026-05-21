//
//  Store.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import Foundation
import StoreKit

typealias Transaction = StoreKit.Transaction
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

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

    init() {
        if let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
           let plist = FileManager.default.contents(atPath: path) {
            productIdToEmoji = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String]) ?? [:]
        } else {
            productIdToEmoji = [:]
        }

        // Start a transaction listener as close to app launch as possible so you don't miss any transactions.
        updateListenerTask = listenForTransactions()

        Task {
            // Initialize the store by starting a product request.
            await requestProducts()
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task {
            for await result in Transaction.updates {
                do {
                    let transaction = try checkVerified(result)

                    // Deliver content to the user.
                    updatePurchasedIdentifiers(transaction)

                    // Always finish a transaction.
                    await transaction.finish()
                } catch {
                    // StoreKit has a receipt it can read but it failed verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }

    func requestProducts() async {
        do {
            // Request products from the App Store using the identifiers defined in the Products.plist file.
            let storeProducts = try await Product.products(for: productIdToEmoji.keys)

            var newTips: [Product] = []
            var newSubscriptions: [Product] = []

            // Filter the products into different categories based on their type.
            for product in storeProducts {
                switch product.type {
                case .consumable:
                    newTips.append(product)
                case .nonConsumable:
                    return
                case .autoRenewable:
                    newSubscriptions.append(product)
                default:
                    // Ignore this product.
                    print("Unknown product")
                }
            }

            // Sort each product category by price, lowest to highest, to update the store.
            tips = sortByPrice(newTips)
            subscriptions = sortByPrice(newSubscriptions)
        } catch {
            print("Failed product request: \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        HapticGenerator.playSuccessHaptic()

        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            updatePurchasedIdentifiers(transaction)
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }

    func isPurchased(_ productIdentifier: String) async throws -> Bool {
        // Get the most recent transaction receipt for this `productIdentifier`.
        guard let result = await Transaction.latest(for: productIdentifier) else {
            // If there is no latest transaction, the product has not been purchased.
            return false
        }

        let transaction = try checkVerified(result)

        // For subscriptions, a user can upgrade in the middle of their subscription period. The lower service
        // tier will then have the `isUpgraded` flag set and there will be a new transaction for the higher service
        // tier. Ignore the lower service tier transactions which have been upgraded.
        return transaction.revocationDate == nil && !transaction.isUpgraded
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    func updatePurchasedIdentifiers(_ transaction: Transaction) {
        if transaction.revocationDate == nil {
            // If the App Store has not revoked the transaction, add it to the list of `purchasedIdentifiers`.
            purchasedIdentifiers.insert(transaction.productID)
        } else {
            // If the App Store has revoked this transaction, remove it from the list of `purchasedIdentifiers`.
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

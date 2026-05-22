//
//  StatusInfoView.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import SwiftUI
import StoreKit

struct StatusInfoView: View {
    @Environment(Store.self) private var store

    let product: Product
    let status: Product.SubscriptionInfo.Status

    var body: some View {
        Text(statusDescription)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var statusDescription: String {
        guard case .verified(let renewalInfo) = status.renewalInfo,
              case .verified(let transaction) = status.transaction else {
            return "The App Store could not verify your subscription status."
        }

        var description = ""

        switch status.state {
        case .subscribed:
            description = "You are currently subscribed to \(product.displayName)."
        case .expired:
            if let expirationDate = transaction.expirationDate,
               let expirationReason = renewalInfo.expirationReason {
                description = expirationDescription(expirationReason, expirationDate: expirationDate)
            }
        case .revoked:
            if let revokedDate = transaction.revocationDate {
                description = "The App Store refunded your subscription to \(product.displayName) on \(revokedDate.formatted(date: .abbreviated, time: .omitted))."
            }
        case .inGracePeriod:
            description = gracePeriodDescription(renewalInfo)
        case .inBillingRetryPeriod:
            description = "The App Store could not confirm your billing information for \(product.displayName). Please verify your billing information to resume service."
        default:
            break
        }

        if let expirationDate = transaction.expirationDate {
            description += renewalDescription(renewalInfo, expirationDate: expirationDate)
        }
        return description
    }

    private func gracePeriodDescription(_ renewalInfo: RenewalInfo) -> String {
        var description = "The App Store could not confirm your billing information for \(product.displayName)."
        if let untilDate = renewalInfo.gracePeriodExpirationDate {
            description += " Please verify your billing information to continue service after \(untilDate.formatted(date: .abbreviated, time: .omitted))"
        }
        return description
    }

    private func renewalDescription(_ renewalInfo: RenewalInfo, expirationDate: Date) -> String {
        if let newProductID = renewalInfo.autoRenewPreference,
           let newProduct = store.subscriptions.first(where: { $0.id == newProductID }) {
            return "\nYour subscription to \(newProduct.displayName) will begin when your current subscription expires on \(expirationDate.formatted(date: .abbreviated, time: .omitted))."
        } else if renewalInfo.willAutoRenew {
            return "\nNext billing date: \(expirationDate.formatted(date: .abbreviated, time: .omitted))."
        }
        return ""
    }

    private func expirationDescription(_ reason: RenewalInfo.ExpirationReason, expirationDate: Date) -> String {
        let formattedDate = expirationDate.formatted(date: .abbreviated, time: .omitted)

        switch reason {
        case .autoRenewDisabled:
            return expirationDate > .now
                ? "Your subscription to \(product.displayName) will expire on \(formattedDate)."
                : "Your subscription to \(product.displayName) expired on \(formattedDate)."
        case .billingError:
            return "Your subscription to \(product.displayName) was not renewed due to a billing error."
        case .didNotConsentToPriceIncrease:
            return "Your subscription to \(product.displayName) was not renewed due to a price increase that you disapproved."
        case .productUnavailable:
            return "Your subscription to \(product.displayName) was not renewed because the product is no longer available."
        default:
            return "Your subscription to \(product.displayName) was not renewed."
        }
    }
}

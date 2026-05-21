//
//  Product+WholeCurrencyPrice.swift
//  Outrank
//

import Foundation
import StoreKit

extension Product {
    /// Localized price rounded up to a whole currency unit (e.g. `$0.99` → `$1`).
    var wholeCurrencyPrice: String {
        var rounded = Decimal()
        var raw = price
        NSDecimalRound(&rounded, &raw, 0, .up)
        return rounded.formatted(priceFormatStyle.precision(.fractionLength(0)))
    }
}

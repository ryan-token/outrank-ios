//
//  WidgetRankingRow.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 10/9/21.
//

import SwiftUI

struct WidgetRankingRow: View {
    let stat: String
    let ranking: Int
    let rankingColor: Color

    var body: some View {
        HStack {
            Text("\(Conversions.humanReadableStat(for: stat)):")
            Spacer()
            Text(Conversions.humanReadableRanking(for: ranking))
                .foregroundStyle(rankingColor)
        }
    }
}

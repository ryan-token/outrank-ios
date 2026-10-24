//
//  WidgetRankingRow.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 10/9/21.
//

import SwiftUI

struct WidgetRankingRow: View {
    let title: String
    let ranking: Int
    let rankingColor: Color

    var body: some View {
        HStack {
            Text("\(title):")
            Spacer()
            Text(Conversions.humanReadableRanking(for: ranking))
                .foregroundStyle(rankingColor)
        }
    }
}

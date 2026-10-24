//
//  RankingRow.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

/// A name with a ranking on the trailing edge: a stat with the selected team's ranking,
/// or a team with its ranking in one stat.
struct RankingRow: View {
    let title: String
    let ranking: Int
    var titleFont: Font = .body
    var rankingFont: Font = .body

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.backgroundProminence) private var backgroundProminence

    var body: some View {
        // A long name wraps beside the ranking, keeping every ranking on the trailing
        // edge so they line up down the list. At accessibility text sizes there isn't
        // room for both, so the ranking moves under the name.
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading))
            : AnyLayout(HStackLayout())

        layout {
            Text(title)
                .font(titleFont)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(Conversions.humanReadableRanking(for: ranking))
                .font(rankingFont)
                // On a selected row's filled background the ranking color would blend
                // in, so it matches the row's white text instead.
                .foregroundStyle(backgroundProminence == .increased ? .white : RankingStyle.color(for: ranking))
                // Takes its full width first, so the name is what wraps.
                .layoutPriority(1)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        List {
            NavigationLink(value: "Long") {
                RankingRow(title: "Third Down Conversion Pct Defense", ranking: 98, titleFont: .headline)
            }

            NavigationLink(value: "Short") {
                RankingRow(title: "Passing Offense", ranking: 97, titleFont: .headline)
            }

            NavigationLink(value: "Unranked") {
                RankingRow(title: "Blocked Kicks", ranking: RankingsResponse.unranked, titleFont: .headline)
            }
        }
    }
}

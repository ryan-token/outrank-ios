//
//  MultiPicker.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import CoreData
import SwiftUI

/// The Settings row that opens the favorite-teams editor, summarizing the current picks.
struct MultiPicker: View {
    @FetchRequest(fetchRequest: Favorite.allFavoritesFetchRequest, animation: .default)
    private var favorites: FetchedResults<Favorite>

    /// The single favorite's name, or how many favorites there are.
    private var summary: LocalizedStringResource {
        let uniqueFavorites = favorites.uniquedByTeam()
        if uniqueFavorites.count == 1, let favorite = uniqueFavorites.first {
            return "\(favorite.team)"
        }
        return "^[\(uniqueFavorites.count) Team](inflect: true)"
    }

    var body: some View {
        NavigationLink(value: SettingsDetail.favorites) {
            LabeledContent {
                Text(summary)
            } label: {
                SettingsLabel(title: "Favorites", icon: "star.square.fill", iconColor: .yellow)
            }
        }
    }
}

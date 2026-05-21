//
//  Favorite+Dedup.swift
//  Outrank
//
//  Created by Ryan Token on 10/24/21.
//

import CoreData

extension Favorite {
    /// Removes duplicate `Favorite` rows that share the same team name.
    ///
    /// CloudKit forbids `@Attribute(.unique)`, so duplicates can appear when the
    /// same team is favorited on multiple devices (or from rapid taps before the
    /// previous save merges in). This keeps a single row per team.
    static func removeDuplicates(in context: NSManagedObjectContext) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Favorite.team, ascending: true)]

        guard let favorites = try? context.fetch(request) else { return }

        var seenTeams = Set<String>()
        var didRemoveAny = false

        for favorite in favorites {
            let team = favorite.wrappedTeam
            if seenTeams.contains(team) {
                context.delete(favorite)
                didRemoveAny = true
            } else {
                seenTeams.insert(team)
            }
        }

        if didRemoveAny {
            try? context.save()
        }
    }
}

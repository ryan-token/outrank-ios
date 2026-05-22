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
    ///
    /// Runs on a background context so the UI stays responsive; the view context
    /// picks up the changes automatically via `automaticallyMergesChangesFromParent`.
    static func removeDuplicates(in container: NSPersistentCloudKitContainer) async {
        let context = container.newBackgroundContext()
        await context.perform {
            let request = Favorite.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \Favorite.team, ascending: true),
                NSSortDescriptor(keyPath: \Favorite.createdAt, ascending: true)
            ]

            do {
                let favorites = try context.fetch(request)
                var seenTeams = Set<String>()

                for favorite in favorites {
                    if seenTeams.contains(favorite.team) {
                        context.delete(favorite)
                    } else {
                        seenTeams.insert(favorite.team)
                    }
                }

                try context.saveIfNeeded()
            } catch {
                print("[FavoriteDedup] Dedup failed: \(error)")
            }
        }
    }
}

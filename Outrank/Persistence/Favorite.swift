//
//  Favorite.swift
//  Outrank
//
//  Created by Ryan Token on 10/24/21.
//

import CoreData

@objc(Favorite)
public final class Favorite: NSManagedObject, Identifiable {
    @NSManaged public var team: String
    @NSManaged public var createdAt: Date?
}

extension Favorite {
    nonisolated static func fetchRequest() -> NSFetchRequest<Favorite> {
        NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    /// Sorted alphabetically by team name.
    nonisolated static var allFavoritesFetchRequest: NSFetchRequest<Favorite> {
        let request = fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Favorite.team, ascending: true)]
        return request
    }
}

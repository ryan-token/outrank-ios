//
//  Persistence.swift
//  Outrank
//
//  Created by Ryan Token on 10/24/21.
//

import CoreData

nonisolated final class PersistentContainer: NSPersistentCloudKitContainer, @unchecked Sendable {
    static let shared: PersistentContainer = .make(inMemory: false)

    @MainActor static let preview: PersistentContainer = {
        let container = PersistentContainer.make(inMemory: true)
        let viewContext = container.viewContext
        for team in ["Alabama", "Georgia", "Michigan", "Oklahoma"] {
            let favorite = Favorite(context: viewContext)
            favorite.team = team
            favorite.createdAt = .now
        }
        try? viewContext.saveIfNeeded()
        return container
    }()

    private static func make(inMemory: Bool) -> PersistentContainer {
        let container = PersistentContainer(name: "TeamRankings")
        container.configureStoreDescription(inMemory: inMemory)
        // Register before loading so we catch CloudKit `.setup` events.
        container.observeCloudKitEvents()
        container.loadStores()
        container.configureViewContext()
        return container
    }

    override func newBackgroundContext() -> NSManagedObjectContext {
        let context = super.newBackgroundContext()
        context.name = "BackgroundContext"
        context.transactionAuthor = "BackgroundAuthor"
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    private func configureStoreDescription(inMemory: Bool) {
        guard let description = persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }

        if inMemory {
            description.url = URL(filePath: "/dev/null")
            description.cloudKitContainerOptions = nil
        }

        // Persistent history tracking is required for CloudKit sync and lets
        // us merge changes from background contexts and remote pushes.
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
    }

    private func loadStores() {
        loadPersistentStores { _, error in
            if let error {
                print("[CoreData] Failed to load persistent store: \(error)")
                fatalError("Unresolved Core Data error: \(error)")
            }
        }
    }

    private func configureViewContext() {
        // NSMergeByPropertyStoreTrumpMergePolicy is required so CloudKit-imported
        // values win over stale in-memory values, and so duplicates merge cleanly
        // when constraints can't be used (CloudKit forbids @Attribute(.unique)).
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.name = "ViewContext"
        viewContext.transactionAuthor = "MainApp"
    }

    private func observeCloudKitEvents() {
        let notifications = NotificationCenter.default.notifications(
            named: NSPersistentCloudKitContainer.eventChangedNotification,
            object: self
        )
        Task { [weak self] in
            guard self != nil else { return }
            for await notification in notifications {
                guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
                    as? NSPersistentCloudKitContainer.Event else { continue }
                if let error = event.error {
                    print("[CoreData] CloudKit \(event.type) failed: \(error)")
                }
            }
        }
    }
}

extension NSManagedObjectContext {
    /// Saves only when there are real persistent changes; ignores transient-only edits.
    nonisolated func saveIfNeeded() throws {
        guard hasPersistentChanges else { return }
        try save()
    }

    nonisolated var hasPersistentChanges: Bool {
        !insertedObjects.isEmpty
            || !deletedObjects.isEmpty
            || updatedObjects.contains { !$0.changedValues().isEmpty }
    }
}

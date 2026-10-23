//
//  OutrankApp.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

@main
struct OutrankApp: App {
    @State private var store = Store()
    #if DEBUG
    // Screenshots use sample favorites in memory, never the user's CloudKit store.
    private let persistentContainer = ScreenshotMode.isEnabled ? PersistentContainer.preview : .shared
    #else
    private let persistentContainer = PersistentContainer.shared
    #endif

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
                .environment(store)
                .task {
                    await Favorite.removeDuplicates(in: persistentContainer)
                }
        }
    }
}

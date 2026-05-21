//
//  OutrankApp.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

@main
struct OutrankApp: App {
    @State private var tabController = TabController()
    @State private var store = Store()
    private let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(tabController)
                .environment(store)
                .task {
                    Favorite.removeDuplicates(in: persistenceController.container.viewContext)
                }
        }
    }
}

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
    private let persistentContainer = PersistentContainer.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
                .environment(tabController)
                .environment(store)
                .task {
                    await Favorite.removeDuplicates(in: persistentContainer)
                }
        }
    }
}

//
//  maimatchApp.swift
//  maimatch
//
//  Created by carlson chuang on 10/5/2025.
//

import SwiftUI

@main
struct maimatchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

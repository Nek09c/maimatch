//
//  maimatchApp.swift
//  maimatch
//
//  Created by carlson chuang on 10/5/2025.
//

import SwiftUI
import FirebaseCore

@main
struct maimatchApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LocationSelectionView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

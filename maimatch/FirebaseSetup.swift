import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("DEBUG: Configuring Firebase...")
        FirebaseApp.configure()
        print("DEBUG: Firebase configured successfully!")
        return true
    }
} 
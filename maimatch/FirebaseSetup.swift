import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("DEBUG: Configuring Firebase...")
        
        do {
            // Check if GoogleService-Info.plist exists in the main bundle
            guard Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else {
                print("ERROR: GoogleService-Info.plist not found in bundle")
                return false
            }
            
            FirebaseApp.configure()
            print("DEBUG: Firebase configured successfully!")
            
            // Initialize Firestore and check if it's working
            let db = Firestore.firestore()
            let settings = db.settings
            settings.isPersistenceEnabled = true
            db.settings = settings
            
            print("DEBUG: Firestore initialized with settings: persistence=\(settings.isPersistenceEnabled)")
            
            // Test Firestore access
            testFirestoreAccess()
            
            return true
        } catch {
            print("ERROR: Failed to configure Firebase: \(error)")
            return false
        }
    }
    
    private func testFirestoreAccess() {
        let db = Firestore.firestore()
        
        // Write a test document
        db.collection("_test").document("test_connection").setData([
            "timestamp": Date().timeIntervalSince1970,
            "test": "Firebase connection test"
        ]) { error in
            if let error = error {
                print("ERROR: Failed to write test document to Firestore: \(error)")
            } else {
                print("DEBUG: Successfully wrote test document to Firestore")
                
                // Try to read the test document
                db.collection("_test").document("test_connection").getDocument { (document, error) in
                    if let error = error {
                        print("ERROR: Failed to read test document from Firestore: \(error)")
                    } else if let document = document, document.exists {
                        print("DEBUG: Successfully read test document from Firestore: \(document.data() ?? [:])")
                    } else {
                        print("ERROR: Test document not found in Firestore after writing")
                    }
                }
            }
        }
    }
} 
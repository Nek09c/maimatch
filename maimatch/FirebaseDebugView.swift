import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct FirebaseDebugView: View {
    @State private var testResult: String = "Ready to test"
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Firebase Debug Tools")
                    .font(.largeTitle)
                    .padding(.top)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        Text(testResult)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray5))
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack(spacing: 15) {
                    Button("Test Firebase Configuration") {
                        testFirebaseConfig()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Test Firestore Write") {
                        testFirestoreWrite()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Test Firestore Read") {
                        testFirestoreRead()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Test Database Rules") {
                        testDatabaseRules()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Firebase Debug")
        }
    }
    
    // Test Firebase configuration
    private func testFirebaseConfig() {
        isLoading = true
        testResult = "Testing Firebase configuration...\n"
        
        // Check if Firebase is already configured
        if FirebaseApp.app() != nil {
            testResult += "✅ Firebase is configured\n"
        } else {
            testResult += "❌ Firebase is NOT configured\n"
            
            // Try to configure Firebase
            do {
                FirebaseApp.configure()
                testResult += "✅ Firebase configured successfully\n"
            } catch {
                testResult += "❌ Firebase configuration failed: \(error)\n"
            }
        }
        
        // Check the GoogleService-Info.plist file
        checkGoogleServiceInfoPlist()
        
        // Check Firestore
        let db = Firestore.firestore()
        testResult += "✅ Got Firestore instance\n"
        
        // Check Auth
        if let user = Auth.auth().currentUser {
            testResult += "✅ User is authenticated: \(user.uid)\n"
        } else {
            testResult += "ℹ️ No authenticated user\n"
        }
        
        isLoading = false
    }
    
    // Check GoogleService-Info.plist information
    private func checkGoogleServiceInfoPlist() {
        guard let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let info = NSDictionary(contentsOfFile: filePath) else {
            testResult += "❌ GoogleService-Info.plist not found in bundle\n"
            return
        }
        
        testResult += "✅ GoogleService-Info.plist found\n"
        
        if let projectID = info["PROJECT_ID"] as? String {
            testResult += "📋 Project ID: \(projectID)\n"
            
            // Verify if this is the expected project ID
            if projectID == "maimatch-69083" {
                testResult += "✅ Project ID matches expected value\n"
            } else {
                testResult += "⚠️ Project ID does not match expected value (maimatch-69083)\n"
            }
        } else {
            testResult += "❌ PROJECT_ID not found in plist file\n"
        }
        
        if let bundleID = info["BUNDLE_ID"] as? String {
            testResult += "📋 Bundle ID: \(bundleID)\n"
            
            // Verify if this matches the app's bundle ID
            let appBundleID = Bundle.main.bundleIdentifier ?? "unknown"
            if bundleID == appBundleID {
                testResult += "✅ Bundle ID matches app bundle ID\n"
            } else {
                testResult += "⚠️ Bundle ID (\(bundleID)) does not match app bundle ID (\(appBundleID))\n"
            }
        }
        
        if let gcmSenderID = info["GCM_SENDER_ID"] as? String {
            testResult += "📋 GCM Sender ID: \(gcmSenderID)\n"
        }
        
        if let storageBucket = info["STORAGE_BUCKET"] as? String {
            testResult += "📋 Storage Bucket: \(storageBucket)\n"
        }
    }
    
    // Test Firestore write
    private func testFirestoreWrite() {
        isLoading = true
        testResult = "Testing Firestore write...\n"
        
        let db = Firestore.firestore()
        let testDocRef = db.collection("debug_tests").document("test_\(UUID().uuidString)")
        
        let testData: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "test_value": "Test from debug view",
            "device_info": UIDevice.current.systemName + " " + UIDevice.current.systemVersion
        ]
        
        testResult += "Writing test document to path: \(testDocRef.path)\n"
        
        testDocRef.setData(testData) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.testResult += "❌ Write failed: \(error.localizedDescription)\n"
                    
                    // Detailed error info
                    if let nsError = error as NSError? {
                        self.testResult += "Error domain: \(nsError.domain), code: \(nsError.code)\n"
                        self.testResult += "Error user info: \(nsError.userInfo)\n"
                    }
                } else {
                    self.testResult += "✅ Write successful!\n"
                    self.testResult += "Test document ID: \(testDocRef.documentID)\n"
                }
                self.isLoading = false
            }
        }
    }
    
    // Test Firestore read
    private func testFirestoreRead() {
        isLoading = true
        testResult = "Testing Firestore read...\n"
        
        let db = Firestore.firestore()
        
        // Query the latest test document
        db.collection("debug_tests")
            .order(by: "timestamp", descending: true)
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        self.testResult += "❌ Read failed: \(error.localizedDescription)\n"
                        
                        // Detailed error info
                        if let nsError = error as NSError? {
                            self.testResult += "Error domain: \(nsError.domain), code: \(nsError.code)\n"
                            self.testResult += "Error user info: \(nsError.userInfo)\n"
                        }
                    } else if let snapshot = snapshot, !snapshot.documents.isEmpty {
                        let document = snapshot.documents[0]
                        self.testResult += "✅ Read successful!\n"
                        self.testResult += "Document ID: \(document.documentID)\n"
                        self.testResult += "Document data: \(document.data())\n"
                    } else {
                        self.testResult += "❌ No test documents found\n"
                    }
                    self.isLoading = false
                }
            }
    }
    
    // Test database rules
    private func testDatabaseRules() {
        isLoading = true
        testResult = "Testing database security rules...\n"
        
        let db = Firestore.firestore()
        
        // Test write to posts collection (this tests if security rules allow writing)
        let testPost: [String: Any] = [
            "id": UUID().uuidString,
            "title": "Test post from debug view",
            "content": "This is a test post to verify security rules",
            "authorName": "Debug test",
            "location": "debug_location",
            "createdAt": Date(),
            "isMatched": false,
            "creator": [
                "deviceId": UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString,
                "displayName": "Debug test"
            ]
        ]
        
        db.collection("posts").document(UUID().uuidString).setData(testPost) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.testResult += "❌ Post write failed: \(error.localizedDescription)\n"
                    
                    // Detailed error info
                    if let nsError = error as NSError? {
                        self.testResult += "Error domain: \(nsError.domain), code: \(nsError.code)\n"
                        self.testResult += "Error user info: \(nsError.userInfo)\n"
                        
                        // Check for permission denied errors
                        if nsError.domain == FirestoreErrorDomain && nsError.code == 7 {
                            self.testResult += "🔒 PERMISSION DENIED: Your security rules are preventing writes to posts.\n"
                            self.testResult += "This may be intentional or may need to be fixed in your Firebase console.\n"
                        }
                    }
                } else {
                    self.testResult += "✅ Post write successful! Security rules allow writing to posts collection.\n"
                }
                self.isLoading = false
            }
        }
    }
}

// A primary button style for the debug view
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
    }
}

// Preview
struct FirebaseDebugView_Previews: PreviewProvider {
    static var previews: some View {
        FirebaseDebugView()
    }
} 
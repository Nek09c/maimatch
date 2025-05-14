import Foundation
import SwiftUI
import FirebaseAuth

// Define the AuthService protocol with all the methods needed
protocol AuthService: ObservableObject {
    var currentUser: String? { get }
    var isAuthenticated: Bool { get }
    var errorMessage: String? { get }
    var isLoading: Bool { get }
    
    func checkAuthState()
    func signInAnonymously(completion: @escaping (Bool) -> Void)
    func getOrCreateDisplayName() -> String
    func getUserAuthID() -> String?
    func markPostAsCreatedByCurrentUser(postID: UUID)
    func isCurrentUserCreatorOfPost(postID: UUID) -> Bool
    
    // New methods for post creator management
    func getPostCreator() -> PostCreator
    func updateDisplayName(newName: String)
}

// Helper function to create the appropriate auth service
func createAuthService() -> LocalAuthService {
    do {
        let service = LocalAuthService()
        print("DEBUG: Created LocalAuthService")
        return service
    } catch {
        print("ERROR: Failed to create auth service: \(error)")
        // Return a basic implementation as fallback
        return LocalAuthService()
    }
}

// Local-only implementation of AuthService that doesn't use Firebase Auth
class LocalAuthService: AuthService {
    @Published var currentUser: String?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    // User default keys
    private let userIdKey = "local_user_id"
    private let displayNameKey = "username"
    private let createdPostsKey = "createdPosts"
    
    init() {
        print("DEBUG: LocalAuthService initializing...")
        checkAuthState()
    }
    
    func checkAuthState() {
        isLoading = true
        
        do {
            // Check if we have a local user ID already
            if let userId = UserDefaults.standard.string(forKey: userIdKey) {
                self.currentUser = userId
                self.isAuthenticated = true
                print("DEBUG: Found local user ID: \(userId)")
            } else {
                // No local user yet, we'll create one when signInAnonymously is called
                print("DEBUG: No local user ID found")
            }
        } catch {
            print("ERROR: Failed to check auth state: \(error)")
            errorMessage = "Failed to check authentication state"
        }
        
        isLoading = false
    }
    
    func signInAnonymously(completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        do {
            // Check if we already have a local user ID
            if let existingUserId = UserDefaults.standard.string(forKey: userIdKey) {
                self.currentUser = existingUserId
                self.isAuthenticated = true
                isLoading = false
                print("DEBUG: Using existing local user ID: \(existingUserId)")
                completion(true)
                return
            }
            
            // Generate a new random UUID for the user
            let newUserId = UUID().uuidString
            UserDefaults.standard.set(newUserId, forKey: userIdKey)
            
            // Set up empty created posts dictionary
            UserDefaults.standard.set([String: String](), forKey: createdPostsKey)
            
            self.currentUser = newUserId
            self.isAuthenticated = true
            
            print("DEBUG: Created new local user ID: \(newUserId)")
            completion(true)
        } catch {
            print("ERROR: Failed to sign in anonymously: \(error)")
            errorMessage = "Authentication failed: \(error.localizedDescription)"
            completion(false)
        }
        
        isLoading = false
    }
    
    func getOrCreateDisplayName() -> String {
        do {
            // Check if we have a display name saved
            if let displayName = UserDefaults.standard.string(forKey: displayNameKey), !displayName.isEmpty {
                return displayName
            }
            
            // Generate a random display name
            let randomName = "User-\(Int.random(in: 1000...9999))"
            UserDefaults.standard.set(randomName, forKey: displayNameKey)
            return randomName
        } catch {
            print("ERROR: Failed to get/create display name: \(error)")
            return "Anonymous"
        }
    }
    
    func getUserAuthID() -> String? {
        return UserDefaults.standard.string(forKey: userIdKey)
    }
    
    func markPostAsCreatedByCurrentUser(postID: UUID) {
        guard let userId = getUserAuthID() else { 
            print("ERROR: Cannot mark post as created - no user ID")
            return 
        }
        
        do {
            // Store the post creator ID in UserDefaults
            var createdPosts = UserDefaults.standard.dictionary(forKey: createdPostsKey) as? [String: String] ?? [:]
            createdPosts[postID.uuidString] = userId
            UserDefaults.standard.set(createdPosts, forKey: createdPostsKey)
            
            print("DEBUG: Marked post \(postID) as created by user \(userId)")
        } catch {
            print("ERROR: Failed to mark post as created: \(error)")
        }
    }
    
    func isCurrentUserCreatorOfPost(postID: UUID) -> Bool {
        do {
            guard let userId = getUserAuthID(),
                  let createdPosts = UserDefaults.standard.dictionary(forKey: createdPostsKey) as? [String: String],
                  let creatorId = createdPosts[postID.uuidString] else {
                return false
            }
            
            let isCreator = creatorId == userId
            return isCreator
        } catch {
            print("ERROR: Failed to check if user is creator: \(error)")
            return false
        }
    }
    
    // New methods for post creator management
    func getPostCreator() -> PostCreator {
        let deviceId = getUserAuthID() ?? UUID().uuidString
        if getUserAuthID() == nil {
            // Save the new ID if we had to create one
            UserDefaults.standard.set(deviceId, forKey: userIdKey)
        }
        
        let displayName = getOrCreateDisplayName()
        return PostCreator(deviceId: deviceId, displayName: displayName)
    }
    
    func updateDisplayName(newName: String) {
        guard !newName.isEmpty else { return }
        UserDefaults.standard.set(newName, forKey: displayNameKey)
    }
}

// Firebase implementation of AuthService with better error handling
class FirebaseAuthService: AuthService {
    @Published var currentUser: String?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    // User default keys for fallback storage
    private let userIdKey = "firebase_user_id"
    private let displayNameKey = "username"
    private let createdPostsKey = "firebase_createdPosts"
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthStateListener()
        checkAuthState()
    }
    
    deinit {
        // Remove the auth state listener when this object is deallocated
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    private func setupAuthStateListener() {
        // Listen for auth state changes
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else { return }
            
            if let user = user {
                self.currentUser = user.uid
                self.isAuthenticated = true
                print("DEBUG: Firebase user signed in: \(user.uid)")
                
                // Cache the user ID in case Firebase becomes unavailable
                UserDefaults.standard.set(user.uid, forKey: self.userIdKey)
            } else {
                self.currentUser = nil
                self.isAuthenticated = false
                print("DEBUG: Firebase user signed out")
            }
        }
    }
    
    func checkAuthState() {
        isLoading = true
        
        // Check if we're signed in with Firebase
        if let user = Auth.auth().currentUser {
            self.currentUser = user.uid
            self.isAuthenticated = true
            print("DEBUG: Firebase user already signed in: \(user.uid)")
        } else {
            // Check if we have a cached user ID
            if let cachedUserId = UserDefaults.standard.string(forKey: userIdKey) {
                print("DEBUG: Using cached Firebase user ID: \(cachedUserId)")
                self.currentUser = cachedUserId
                self.isAuthenticated = true
            } else {
                print("DEBUG: No cached Firebase user ID found")
            }
        }
        
        isLoading = false
    }
    
    func signInAnonymously(completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        // First check if we already have a user
        if let user = Auth.auth().currentUser {
            print("DEBUG: Already signed in with Firebase: \(user.uid)")
            isLoading = false
            completion(true)
            return
        }
        
        Auth.auth().signInAnonymously { [weak self] (result, error) in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let error = error {
                let errorMessage = self.handleAuthError(error)
                print("DEBUG: Firebase Auth error: \(errorMessage)")
                self.errorMessage = errorMessage
                
                // Fall back to local authentication
                self.fallbackToLocalAuth(completion: completion)
                return
            }
            
            if let user = result?.user {
                print("DEBUG: Successfully signed in anonymously: \(user.uid)")
                self.currentUser = user.uid
                self.isAuthenticated = true
                
                // Cache the user ID for fallback
                UserDefaults.standard.set(user.uid, forKey: self.userIdKey)
                
                completion(true)
            } else {
                print("DEBUG: No auth result returned")
                self.errorMessage = "Authentication failed with no error"
                
                // Fall back to local authentication
                self.fallbackToLocalAuth(completion: completion)
            }
        }
    }
    
    private func fallbackToLocalAuth(completion: @escaping (Bool) -> Void) {
        print("DEBUG: Falling back to local authentication")
        
        // Check if we have a cached user ID
        if let cachedUserId = UserDefaults.standard.string(forKey: userIdKey) {
            print("DEBUG: Using cached Firebase user ID for fallback: \(cachedUserId)")
            self.currentUser = cachedUserId
            self.isAuthenticated = true
            completion(true)
        } else {
            // Generate a new random UUID for the user as a last resort
            let newUserId = UUID().uuidString
            print("DEBUG: Generated new user ID for fallback: \(newUserId)")
            UserDefaults.standard.set(newUserId, forKey: userIdKey)
            
            // Set up empty created posts dictionary
            UserDefaults.standard.set([String: String](), forKey: createdPostsKey)
            
            self.currentUser = newUserId
            self.isAuthenticated = true
            completion(true)
        }
    }
    
    func getOrCreateDisplayName() -> String {
        // Check if we have a display name saved
        if let displayName = UserDefaults.standard.string(forKey: displayNameKey), !displayName.isEmpty {
            return displayName
        }
        
        // Generate a random display name
        let randomName = "User-\(Int.random(in: 1000...9999))"
        UserDefaults.standard.set(randomName, forKey: displayNameKey)
        return randomName
    }
    
    func getUserAuthID() -> String? {
        // Try Firebase first
        if let user = Auth.auth().currentUser {
            return user.uid
        }
        
        // Fall back to cached value
        return UserDefaults.standard.string(forKey: userIdKey)
    }
    
    func markPostAsCreatedByCurrentUser(postID: UUID) {
        guard let userId = getUserAuthID() else { return }
        
        // Store the post creator ID in UserDefaults as fallback
        var createdPosts = UserDefaults.standard.dictionary(forKey: createdPostsKey) as? [String: String] ?? [:]
        createdPosts[postID.uuidString] = userId
        UserDefaults.standard.set(createdPosts, forKey: createdPostsKey)
        
        print("DEBUG: Marked post \(postID) as created by user \(userId)")
    }
    
    func isCurrentUserCreatorOfPost(postID: UUID) -> Bool {
        guard let userId = getUserAuthID(),
              let createdPosts = UserDefaults.standard.dictionary(forKey: createdPostsKey) as? [String: String],
              let creatorId = createdPosts[postID.uuidString] else {
            return false
        }
        
        let isCreator = creatorId == userId
        print("DEBUG: Post \(postID) created by \(creatorId), current user \(userId), isCreator: \(isCreator)")
        return isCreator
    }
    
    // New methods for post creator management
    func getPostCreator() -> PostCreator {
        let deviceId = getUserAuthID() ?? UUID().uuidString
        if getUserAuthID() == nil {
            // Save the new ID if we had to create one
            UserDefaults.standard.set(deviceId, forKey: userIdKey)
        }
        
        let displayName = getOrCreateDisplayName()
        return PostCreator(deviceId: deviceId, displayName: displayName)
    }
    
    func updateDisplayName(newName: String) {
        guard !newName.isEmpty else { return }
        UserDefaults.standard.set(newName, forKey: displayNameKey)
    }
    
    // Implement our own auth error handler to avoid dependency on FirebaseSetup
    func handleAuthError(_ error: Error) -> String {
        // Extract the underlying error if available
        let nsError = error as NSError
        let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError
        
        print("DEBUG: Auth error details - Domain: \(nsError.domain), Code: \(nsError.code)")
        print("DEBUG: Auth error userInfo: \(nsError.userInfo)")
        
        if let underlyingError = underlyingError {
            print("DEBUG: Auth underlying error - Domain: \(underlyingError.domain), Code: \(underlyingError.code)")
            print("DEBUG: Auth underlying userInfo: \(underlyingError.userInfo)")
        }
        
        // Fix the AuthErrorCode issue - use proper error code handling
        if nsError.domain == AuthErrorDomain {
            switch nsError.code {
            case 17023: // invalidAPIKey
                return "Firebase API key is invalid. Check GoogleService-Info.plist"
            case 17026: // appNotAuthorized
                return "App is not authorized to use Firebase Auth"
            case 17995: // keychainError
                return "Keychain error - try resetting the simulator or device"
            case 17999: // internalError
                return "Firebase Auth internal error: \(underlyingError?.localizedDescription ?? "Unknown internal error")"
            case 17020: // networkError
                return "Network error - check your internet connection"
            default:
                return "Firebase Auth error [code \(nsError.code)]: \(error.localizedDescription)"
            }
        }
        
        // Default error message
        return "Auth error: \(nsError.domain) code \(nsError.code): \(error.localizedDescription)"
    }
}

// Extension to make AuthService objects available from SwiftUI
extension AuthService {
    static func defaultImplementation() -> LocalAuthService {
        return LocalAuthService()
    }
} 
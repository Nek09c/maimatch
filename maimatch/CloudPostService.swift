import Foundation
import CoreData
import FirebaseFirestore

class CloudPostService: ObservableObject {
    private let db = Firestore.firestore()
    private let postsCollection = "posts"
    
    // Local CoreData context
    private let viewContext: NSManagedObjectContext
    
    // Auth service for user identification
    private let authService: LocalAuthService
    
    // State to track uploads and downloads
    @Published var isUploading = false
    @Published var isDownloading = false
    @Published var lastError: String?
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.authService = LocalAuthService()
        
        // Check Firestore connection
        checkFirestoreConnection()
    }
    
    // Check if Firestore is properly connected
    private func checkFirestoreConnection() {
        print("DEBUG: Testing Firestore connection...")
        
        // Try to get a single document to test connection
        db.collection("test").document("test").getDocument { (document, error) in
            if let error = error {
                print("DEBUG: Firestore connection test failed: \(error.localizedDescription)")
                if let nsError = error as NSError? {
                    print("DEBUG: Error domain: \(nsError.domain), code: \(nsError.code)")
                }
            } else {
                print("DEBUG: Firestore connection test successful")
            }
        }
    }
    
    // MARK: - Upload post to cloud
    func uploadPost(_ post: ForumPost) {
        guard let id = post.id else { 
            print("DEBUG: Cannot upload post - missing ID")
            return 
        }
        
        isUploading = true
        lastError = nil
        
        // Get the current user's creator info
        let creator = authService.getPostCreator()
        print("DEBUG: Post creator: \(creator.deviceId), name: \(creator.displayName)")
        
        // Convert ForumPost to dictionary
        var postData: [String: Any] = [
            "id": id.uuidString,
            "title": post.title ?? "",
            "content": post.content ?? "",
            "authorName": post.authorName ?? "",
            "location": post.location ?? "",
            "createdAt": post.createdAt ?? Date(),
            "isMatched": post.isMatched,
            "creator": creator.toDictionary()  // Add creator information
        ]
        
        // Add optional fields if they exist
        if let genreString = post.value(forKey: "genreString") as? String {
            postData["genreString"] = genreString
            print("DEBUG: Adding genreString: \(genreString)")
        }
        
        if let songIdsString = post.value(forKey: "songIdsString") as? String {
            postData["songIdsString"] = songIdsString
            print("DEBUG: Adding songIdsString: \(songIdsString)")
        }
        
        if let levelString = post.value(forKey: "levelString") as? String {
            postData["levelString"] = levelString
            print("DEBUG: Adding levelString: \(levelString)")
        }
        
        print("DEBUG: Attempting to upload post to Firestore with ID: \(id.uuidString)")
        print("DEBUG: Post data: \(postData)")
        
        // Store the post's creator locally
        authService.markPostAsCreatedByCurrentUser(postID: id)
        
        // Upload to Firestore with retry
        uploadToFirestore(postId: id.uuidString, data: postData, attempt: 1)
    }
    
    // Upload to Firestore with retry logic
    private func uploadToFirestore(postId: String, data: [String: Any], attempt: Int, maxAttempts: Int = 3) {
        print("DEBUG: Upload attempt \(attempt) for post \(postId)")
        
        // Upload to Firestore
        db.collection(postsCollection).document(postId).setData(data) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("DEBUG: Error uploading post (attempt \(attempt)): \(error)")
                    print("DEBUG: Error description: \(error.localizedDescription)")
                    
                    if let nsError = error as NSError? {
                        print("DEBUG: Error domain: \(nsError.domain)")
                        print("DEBUG: Error code: \(nsError.code)")
                        print("DEBUG: Error user info: \(nsError.userInfo)")
                    }
                    
                    // Retry if under max attempts
                    if attempt < maxAttempts {
                        print("DEBUG: Retrying upload in 1 second...")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.uploadToFirestore(postId: postId, data: data, attempt: attempt + 1)
                        }
                    } else {
                        self.isUploading = false
                        self.lastError = "上傳失敗: \(error.localizedDescription)"
                        print("DEBUG: Max upload attempts reached. Giving up.")
                    }
                } else {
                    self.isUploading = false
                    print("DEBUG: Post successfully uploaded!")
                    
                    // Verify upload with a read operation
                    self.verifyUpload(postId: postId)
                }
            }
        }
    }
    
    // Verify that the upload was successful
    private func verifyUpload(postId: String) {
        print("DEBUG: Verifying upload for post \(postId)")
        
        db.collection(postsCollection).document(postId).getDocument { (document, error) in
            if let error = error {
                print("DEBUG: Error verifying post upload: \(error)")
            } else if let document = document, document.exists {
                print("DEBUG: Post verified in Firestore: \(document.data() ?? [:])")
            } else {
                print("DEBUG: Post not found in Firestore after upload")
            }
        }
    }
    
    // MARK: - Download posts from cloud
    func downloadPosts(for location: ArcadeLocation, completion: @escaping (Result<[ForumPost], Error>) -> Void) {
        isDownloading = true
        lastError = nil
        
        print("DEBUG: Attempting to download posts for location: \(location.rawValue)")
        
        db.collection(postsCollection)
            .whereField("location", isEqualTo: location.rawValue)
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isDownloading = false
                    
                    if let error = error {
                        self.lastError = "下載失敗: \(error.localizedDescription)"
                        print("DEBUG: Error downloading posts: \(error)")
                        print("DEBUG: Error description: \(error.localizedDescription)")
                        
                        if let nsError = error as NSError? {
                            print("DEBUG: Error domain: \(nsError.domain)")
                            print("DEBUG: Error code: \(nsError.code)")
                            print("DEBUG: Error user info: \(nsError.userInfo)")
                        }
                        
                        completion(.failure(error))
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        print("DEBUG: No documents found for location: \(location.rawValue)")
                        completion(.success([]))
                        return
                    }
                    
                    print("DEBUG: Downloaded \(documents.count) posts for location: \(location.rawValue)")
                    
                    // Create or update local CoreData entities
                    var updatedPosts: [ForumPost] = []
                    
                    for document in documents {
                        let data = document.data()
                        
                        // Check if post already exists locally
                        let fetchRequest: NSFetchRequest<ForumPost> = ForumPost.fetchRequest()
                        fetchRequest.predicate = NSPredicate(format: "id == %@", document.documentID)
                        
                        do {
                            let existingPosts = try self.viewContext.fetch(fetchRequest)
                            let post: ForumPost
                            
                            if let existingPost = existingPosts.first {
                                // Update existing post
                                post = existingPost
                            } else {
                                // Create new post
                                post = ForumPost(context: self.viewContext)
                                if let idString = data["id"] as? String, let id = UUID(uuidString: idString) {
                                    post.id = id
                                }
                            }
                            
                            // Update post attributes
                            post.title = data["title"] as? String
                            post.content = data["content"] as? String
                            post.authorName = data["authorName"] as? String
                            post.location = data["location"] as? String
                            post.createdAt = (data["createdAt"] as? Timestamp)?.dateValue()
                            post.isMatched = (data["isMatched"] as? Bool) ?? false
                            
                            // Handle optional fields
                            if let genreString = data["genreString"] as? String {
                                post.setValue(genreString, forKey: "genreString")
                            }
                            
                            if let songIdsString = data["songIdsString"] as? String {
                                post.setValue(songIdsString, forKey: "songIdsString")
                            }
                            
                            if let levelString = data["levelString"] as? String {
                                post.setValue(levelString, forKey: "levelString")
                            }
                            
                            // Store creator data locally for permission management
                            if let creatorData = data["creator"] as? [String: Any],
                               let creator = PostCreator.fromDictionary(creatorData),
                               let postId = post.id {
                                
                                // Save the creator's deviceId for this post
                                var createdPosts = UserDefaults.standard.dictionary(forKey: "createdPosts") as? [String: String] ?? [:]
                                createdPosts[postId.uuidString] = creator.deviceId
                                UserDefaults.standard.set(createdPosts, forKey: "createdPosts")
                            }
                            
                            updatedPosts.append(post)
                        } catch {
                            self.lastError = "處理數據失敗: \(error.localizedDescription)"
                            print("DEBUG: Error processing document: \(error)")
                        }
                    }
                    
                    // Save changes to CoreData
                    do {
                        try self.viewContext.save()
                        print("DEBUG: Successfully saved \(updatedPosts.count) posts to CoreData")
                        completion(.success(updatedPosts))
                    } catch {
                        self.lastError = "保存失敗: \(error.localizedDescription)"
                        print("DEBUG: Error saving to CoreData: \(error)")
                        completion(.failure(error))
                    }
                }
            }
    }
    
    // MARK: - Update post status
    func updatePostStatus(postId: UUID, isMatched: Bool, completion: @escaping (Bool) -> Void) {
        guard let idString = postId.uuidString as String? else {
            completion(false)
            return
        }
        
        // Check if the current user is the creator of this post
        if !authService.isCurrentUserCreatorOfPost(postID: postId) {
            print("DEBUG: Update rejected - user is not the post creator")
            completion(false)
            return
        }
        
        db.collection(postsCollection).document(idString).updateData([
            "isMatched": isMatched
        ]) { error in
            if let error = error {
                print("Error updating post status: \(error)")
                completion(false)
            } else {
                print("Post status successfully updated!")
                completion(true)
            }
        }
    }
    
    // MARK: - Delete post
    func deletePost(postId: UUID, completion: @escaping (Bool) -> Void) {
        guard let idString = postId.uuidString as String? else {
            completion(false)
            return
        }
        
        // Check if the current user is the creator of this post
        if !authService.isCurrentUserCreatorOfPost(postID: postId) {
            print("DEBUG: Delete rejected - user is not the post creator")
            completion(false)
            return
        }
        
        db.collection(postsCollection).document(idString).delete { error in
            if let error = error {
                print("DEBUG: Error deleting post: \(error)")
                completion(false)
            } else {
                print("DEBUG: Post successfully deleted!")
                completion(true)
            }
        }
    }
    
    // MARK: - Setup listener for real-time updates
    func listenForLocationUpdates(location: ArcadeLocation) -> FirebaseFirestore.ListenerRegistration {
        return db.collection(postsCollection)
            .whereField("location", isEqualTo: location.rawValue)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    self.lastError = "監聽失敗: \(error.localizedDescription)"
                    print("DEBUG: Error listening for updates: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("DEBUG: No documents found in update")
                    return
                }
                
                print("DEBUG: Received update with \(documents.count) documents")
                
                // Process updates
                self.downloadPosts(for: location) { _ in 
                    // Updates handled by the download function
                }
            }
    }
} 
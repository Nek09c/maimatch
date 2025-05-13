import Foundation
import CoreData
import FirebaseFirestore

class CloudPostService: ObservableObject {
    private let db = Firestore.firestore()
    private let postsCollection = "posts"
    
    // Local CoreData context
    private let viewContext: NSManagedObjectContext
    
    // State to track uploads and downloads
    @Published var isUploading = false
    @Published var isDownloading = false
    @Published var lastError: String?
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    // MARK: - Upload post to cloud
    func uploadPost(_ post: ForumPost) {
        guard let id = post.id else { return }
        
        isUploading = true
        lastError = nil
        
        // Convert ForumPost to dictionary
        var postData: [String: Any] = [
            "id": id.uuidString,
            "title": post.title ?? "",
            "content": post.content ?? "",
            "authorName": post.authorName ?? "",
            "location": post.location ?? "",
            "createdAt": post.createdAt ?? Date(),
            "isMatched": post.isMatched
        ]
        
        // Add optional fields if they exist
        if let genreString = post.value(forKey: "genreString") as? String {
            postData["genreString"] = genreString
        }
        
        if let songIdsString = post.value(forKey: "songIdsString") as? String {
            postData["songIdsString"] = songIdsString
        }
        
        if let levelString = post.value(forKey: "levelString") as? String {
            postData["levelString"] = levelString
        }
        
        print("DEBUG: Attempting to upload post to Firestore with ID: \(id.uuidString)")
        print("DEBUG: Post data: \(postData)")
        
        // Upload to Firestore
        db.collection(postsCollection).document(id.uuidString).setData(postData) { [weak self] error in
            DispatchQueue.main.async {
                self?.isUploading = false
                
                if let error = error {
                    self?.lastError = "上傳失敗: \(error.localizedDescription)"
                    print("DEBUG: Error uploading post: \(error)")
                    print("DEBUG: Error description: \(error.localizedDescription)")
                    
                    if let nsError = error as NSError? {
                        print("DEBUG: Error domain: \(nsError.domain)")
                        print("DEBUG: Error code: \(nsError.code)")
                        print("DEBUG: Error user info: \(nsError.userInfo)")
                    }
                } else {
                    print("DEBUG: Post successfully uploaded!")
                }
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
        
        db.collection(postsCollection).document(idString).delete() { error in
            if let error = error {
                print("Error removing post: \(error)")
                completion(false)
            } else {
                print("Post successfully deleted!")
                completion(true)
            }
        }
    }
    
    // MARK: - Listen for updates to a specific location's posts
    func listenForLocationUpdates(location: ArcadeLocation) -> ListenerRegistration {
        return db.collection(postsCollection)
            .whereField("location", isEqualTo: location.rawValue)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error listening for updates: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // Process added/modified documents
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added || diff.type == .modified {
                        // Trigger a download to update local cache
                        self?.downloadPosts(for: location) { _ in }
                    }
                }
            }
    }
} 
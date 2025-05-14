import Foundation
import CoreData
import SwiftUI
import Combine
import FirebaseFirestore

class ForumViewModel: ObservableObject {
    let viewContext: NSManagedObjectContext
    private let cloudService: CloudPostService
    private let authService: LocalAuthService
    private var cancellables = Set<AnyCancellable>()
    
    // State tracking
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.cloudService = CloudPostService(viewContext: viewContext)
        self.authService = LocalAuthService()
        
        print("DEBUG: ForumViewModel initialized")
        
        // Subscribe to cloud service state updates
        cloudService.$isUploading
            .receive(on: RunLoop.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        cloudService.$lastError
            .receive(on: RunLoop.main)
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }
    
    func createPost(title: String, content: String, authorName: String, location: ArcadeLocation, genres: [Genre], songs: [SongModel], levels: [Level]) {
        print("DEBUG: Creating post for location: \(location.rawValue)")
        print("DEBUG: Post details - Title: \(title), Author: \(authorName)")
        print("DEBUG: Selected genres: \(genres.map { $0.displayName }.joined(separator: ", "))")
        print("DEBUG: Selected songs: \(songs.map { $0.title }.joined(separator: ", "))")
        print("DEBUG: Selected levels: \(levels.map { $0.displayName }.joined(separator: ", "))")
        
        // Create the post locally in CoreData first
        let newPost = ForumPost(context: viewContext)
        newPost.id = UUID()
        newPost.title = title
        newPost.content = content
        newPost.authorName = authorName
        newPost.location = location.rawValue
        newPost.createdAt = Date()
        
        print("DEBUG: Setting genres, songs, and levels...")
        
        // Set genres - Check for errors
        do {
            newPost.genresList = genres
        } catch {
            print("ERROR: Failed to set genres: \(error)")
        }
        
        // Set songs - Check for errors
        do {
            newPost.selectedSongs = songs
        } catch {
            print("ERROR: Failed to set songs: \(error)")
        }
        
        // Set levels - Check for errors
        do {
            newPost.selectedLevels = levels
        } catch {
            print("ERROR: Failed to set levels: \(error)")
        }
        
        newPost.isMatched = false
        
        do {
            // Verify post data before saving
            print("DEBUG: Post data before saving:")
            print("DEBUG: ID: \(newPost.id?.uuidString ?? "nil")")
            print("DEBUG: Title: \(newPost.title ?? "nil")")
            print("DEBUG: Content: \(newPost.content ?? "nil")")
            print("DEBUG: Author: \(newPost.authorName ?? "nil")")
            print("DEBUG: Location: \(newPost.location ?? "nil")")
            
            // Save to CoreData
            try viewContext.save()
            print("DEBUG: Successfully saved post locally with ID: \(newPost.id?.uuidString ?? "unknown")")
            
            // Verify genres, songs, and levels after saving
            print("DEBUG: Saved post genres: \(newPost.genresList.map { $0.displayName }.joined(separator: ", "))")
            print("DEBUG: Saved post songs: \(newPost.selectedSongs.map { $0.title }.joined(separator: ", "))")
            print("DEBUG: Saved post levels: \(newPost.selectedLevels.map { $0.displayName }.joined(separator: ", "))")
            
            // Mark post as created by current user for local ownership tracking
            if let postId = newPost.id {
                authService.markPostAsCreatedByCurrentUser(postID: postId)
                
                // Now upload to cloud
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.cloudService.uploadPost(newPost)
                }
            } else {
                print("ERROR: Cannot upload post - missing ID after save")
                errorMessage = "無法上傳: 缺少ID"
            }
            
        } catch {
            print("DEBUG: Error saving post locally: \(error)")
            errorMessage = "無法保存帖子: \(error.localizedDescription)"
        }
    }
    
    func loadPosts(for location: ArcadeLocation) {
        isLoading = true
        
        cloudService.downloadPosts(for: location) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let posts):
                    print("DEBUG: Successfully loaded \(posts.count) posts for location \(location.rawValue)")
                case .failure(let error):
                    print("DEBUG: Error loading posts: \(error)")
                    self?.errorMessage = "無法加載帖子: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func deletePost(_ post: ForumPost) {
        guard let id = post.id else { return }
        print("DEBUG: Attempting to delete post with ID: \(id)")
        
        // Check if current user is the post creator
        if !authService.isCurrentUserCreatorOfPost(postID: id) {
            print("DEBUG: Cannot delete post - user is not the post creator")
            self.errorMessage = "只有帖子創建者才能刪除帖子"
            return
        }
        
        // Delete locally first
        viewContext.delete(post)
        
        do {
            try viewContext.save()
            print("DEBUG: Successfully deleted post locally")
            
            // Now delete from cloud
            cloudService.deletePost(postId: id) { success in
                if !success {
                    print("DEBUG: Failed to delete post from cloud")
                    self.errorMessage = "無法從雲端刪除帖子"
                }
            }
        } catch {
            print("DEBUG: Error deleting post locally: \(error)")
            self.errorMessage = "無法刪除帖子: \(error.localizedDescription)"
        }
    }
    
    func toggleMatchStatus(post: ForumPost) {
        guard let id = post.id else { return }
        
        // Check if current user is the post creator
        if !authService.isCurrentUserCreatorOfPost(postID: id) {
            print("DEBUG: Cannot toggle match status - user is not the post creator")
            self.errorMessage = "只有帖子創建者才能更改帖子狀態"
            return
        }
        
        post.isMatched.toggle()
        
        do {
            try viewContext.save()
            print("DEBUG: Successfully updated match status locally to \(post.isMatched)")
            
            // Now update in cloud
            cloudService.updatePostStatus(postId: id, isMatched: post.isMatched) { success in
                if !success {
                    print("DEBUG: Failed to update match status in cloud")
                    self.errorMessage = "無法在雲端更新狀態"
                }
            }
        } catch {
            print("DEBUG: Error updating match status: \(error)")
            self.errorMessage = "無法更新狀態: \(error.localizedDescription)"
        }
    }
    
    // Setup listener for real-time updates to a location
    func setupRealtimeUpdates(for location: ArcadeLocation) -> FirebaseFirestore.ListenerRegistration {
        return cloudService.listenForLocationUpdates(location: location)
    }
} 
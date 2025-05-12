import Foundation
import CoreData
import SwiftUI
import Combine
import FirebaseFirestore

class ForumViewModel: ObservableObject {
    let viewContext: NSManagedObjectContext
    private let cloudService: CloudPostService
    private var cancellables = Set<AnyCancellable>()
    
    // State tracking
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.cloudService = CloudPostService(viewContext: viewContext)
        
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
        
        // Create the post locally in CoreData first
        let newPost = ForumPost(context: viewContext)
        newPost.id = UUID()
        newPost.title = title
        newPost.content = content
        newPost.authorName = authorName
        newPost.location = location.rawValue
        newPost.createdAt = Date()
        newPost.genresList = genres
        newPost.selectedSongs = songs
        newPost.selectedLevels = levels
        newPost.isMatched = false
        
        do {
            try viewContext.save()
            print("DEBUG: Successfully saved post locally with location: \(location.rawValue)")
            
            // Now upload to cloud
            cloudService.uploadPost(newPost)
            
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
        print("DEBUG: Deleting post with location: \(post.location ?? "unknown")")
        
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
    
    func toggleMatchStatus(post: ForumPost, currentUsername: String) {
        // Only allow the post creator to toggle match status
        guard post.authorName == currentUsername, let id = post.id else {
            print("DEBUG: Cannot toggle match status - user is not the post creator")
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
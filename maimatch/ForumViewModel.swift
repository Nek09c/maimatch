import Foundation
import CoreData
import SwiftUI

class ForumViewModel: ObservableObject {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func createPost(title: String, content: String, authorName: String, location: ArcadeLocation, genres: [Genre], songs: [SongModel], levels: [Level]) {
        print("DEBUG: Creating post for location: \(location.rawValue)")
        
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
            print("DEBUG: Successfully saved post with location: \(location.rawValue)")
            
            // Verify the save
            let fetchRequest: NSFetchRequest<ForumPost> = ForumPost.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "location == %@", location.rawValue)
            let matchingPosts = try viewContext.fetch(fetchRequest)
            print("DEBUG: Found \(matchingPosts.count) posts for location \(location.rawValue) after save")
        } catch {
            print("DEBUG: Error saving post: \(error)")
        }
    }
    
    func deletePost(_ post: ForumPost) {
        print("DEBUG: Deleting post with location: \(post.location ?? "unknown")")
        viewContext.delete(post)
        
        do {
            try viewContext.save()
            print("DEBUG: Successfully deleted post")
        } catch {
            print("DEBUG: Error deleting post: \(error)")
        }
    }
    
    func toggleMatchStatus(post: ForumPost, currentUsername: String) {
        // Only allow the post creator to toggle match status
        guard post.authorName == currentUsername else {
            print("DEBUG: Cannot toggle match status - user is not the post creator")
            return
        }
        
        post.isMatched.toggle()
        
        do {
            try viewContext.save()
            print("DEBUG: Successfully updated match status to \(post.isMatched)")
        } catch {
            print("DEBUG: Error updating match status: \(error)")
        }
    }
} 
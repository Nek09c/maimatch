//
//  Persistence.swift
//  maimatch
//
//  Created by carlson chuang on 10/5/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample forum posts for preview
        let locations = ArcadeLocation.allCases
        let genres = Genre.allCases
        
        for i in 0..<8 {
            let newPost = ForumPost(context: viewContext)
            let location = locations[i % locations.count]
            // Select 1-3 random genres for each post
            let randomGenreCount = Int.random(in: 1...3)
            let selectedGenres = Array(genres.shuffled().prefix(randomGenreCount))
            
            newPost.id = UUID()
            newPost.title = "Sample Post \(i + 1)"
            newPost.content = "This is a sample post content for post number \(i + 1)."
            newPost.authorName = "Test User \(i + 1)"
            newPost.location = location.rawValue
            newPost.createdAt = Date().addingTimeInterval(Double(-i * 86400))
            newPost.genresList = selectedGenres
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
    
    private static func loadStore(for container: NSPersistentContainer, completion: @escaping (Error?) -> Void) {
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("DEBUG: Failed to load store with error: \(error), \(error.userInfo)")
                
                // If loading fails, try to destroy and recreate
                if let url = description.url {
                    print("DEBUG: Attempting to destroy and recreate store at: \(url.path)")
                    do {
                        try container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: description.type, options: nil)
                        try container.persistentStoreCoordinator.addPersistentStore(ofType: description.type, configurationName: nil, at: url, options: nil)
                        print("DEBUG: Successfully recreated store")
                        completion(nil)
                    } catch {
                        print("DEBUG: Failed to recover from store error: \(error)")
                        completion(error)
                    }
                } else {
                    completion(error)
                }
            } else {
                completion(nil)
            }
        }
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "maimatch")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            // Create a unique store URL for this launch
            let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
                .appendingPathComponent("MaiMatch_\(UUID().uuidString).sqlite")
            
            let description = NSPersistentStoreDescription(url: storeURL)
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
            
            container.persistentStoreDescriptions = [description]
            
            print("DEBUG: Using store URL: \(storeURL.path)")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

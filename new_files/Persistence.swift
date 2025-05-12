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
        let songs = SongDatabaseService.shared.allSongs
        
        for i in 0..<8 {
            let newPost = ForumPost(context: viewContext)
            let location = locations[i % locations.count]
            // Select 1-3 random genres for each post
            let randomGenreCount = Int.random(in: 1...3)
            let selectedGenres = Array(genres.shuffled().prefix(randomGenreCount))
            
            // Select 0-4 random songs
            let randomSongCount = Int.random(in: 0...4)
            let selectedSongs = Array(songs.shuffled().prefix(randomSongCount))
            
            newPost.id = UUID()
            newPost.title = "Sample Post \(i + 1)"
            newPost.content = "This is a sample post content for post number \(i + 1)."
            newPost.authorName = "Test User \(i + 1)"
            newPost.location = location.rawValue
            newPost.createdAt = Date().addingTimeInterval(Double(-i * 86400))
            newPost.genresList = selectedGenres
            newPost.selectedSongs = selectedSongs
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
import Foundation

public class SongDatabaseService {
    public static let shared = SongDatabaseService()
    
    public let allSongs: [SongModel]
    
    private init() {
        // Initialize allSongs with the maimai songs data
        var songs: [SongModel] = []
        
        // Include the generated songs from the script
        #include "generated_songs.swift"
        
        self.allSongs = songs
    }
    
    // Get songs by category
    public func songs(forCategory category: SongCategory) -> [SongModel] {
        return allSongs.filter { $0.category == category }
    }
    
    // Search songs by title
    public func searchSongs(query: String) -> [SongModel] {
        guard !query.isEmpty else { return [] }
        return allSongs.filter { $0.title.lowercased().contains(query.lowercased()) }
    }
}
#!/usr/bin/env swift

import Foundation

// Read the template file
let templateContent = """
import Foundation

public class SongDatabaseService {
    public static let shared = SongDatabaseService()
    
    public let allSongs: [SongModel]
    
    private init() {
        // Initialize allSongs with the maimai songs data
        var songs: [SongModel] = []
        
        // SONGS_PLACEHOLDER
        
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
"""

// Read the generated songs file
guard let generatedSongs = try? String(contentsOf: URL(fileURLWithPath: "generated_songs.swift")) else {
    print("Error: Could not read generated_songs.swift")
    exit(1)
}

// Replace the placeholder with the actual songs
let newContent = templateContent.replacingOccurrences(of: "// SONGS_PLACEHOLDER", with: generatedSongs)

// Write the new content to a file
do {
    try newContent.write(to: URL(fileURLWithPath: "maimatch/NewSongDatabaseService.swift"), atomically: true, encoding: .utf8)
    print("Successfully wrote new database service to NewSongDatabaseService.swift")
} catch {
    print("Error writing file: \(error)")
    exit(1)
}

// Create a backup of the current SongDatabaseService.swift file
do {
    let currentContent = try String(contentsOf: URL(fileURLWithPath: "maimatch/SongDatabaseService.swift"))
    try currentContent.write(to: URL(fileURLWithPath: "maimatch/SongDatabaseService.swift.bak"), atomically: true, encoding: .utf8)
    print("Created backup of current SongDatabaseService.swift")
} catch {
    print("Error creating backup: \(error)")
    exit(1)
}

print("Done! You can now replace SongDatabaseService.swift with NewSongDatabaseService.swift after reviewing it.")
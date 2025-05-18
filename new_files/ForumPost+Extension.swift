import Foundation
import CoreData

extension ForumPost {
    private static let genreSeparator = "|"
    private static let songSeparator = ","
    
    var genresList: [Genre] {
        get {
            guard let genreString = self.value(forKey: "genreString") as? String else { return [] }
            return genreString
                .split(separator: Self.genreSeparator)
                .compactMap { rawValue in
                    Genre.allCases.first { $0.rawValue == String(rawValue) }
                }
        }
        set {
            let newString = newValue.isEmpty ? nil : newValue.map { $0.rawValue }.joined(separator: Self.genreSeparator)
            self.setValue(newString, forKey: "genreString")
        }
    }
    
    var selectedSongs: [SongModel] {
        get {
            guard let songIdsString = self.value(forKey: "songIdsString") as? String else { return [] }
            let songIds = songIdsString.split(separator: Self.songSeparator).map { String($0) }
            return songIds.compactMap { songId in
                SongDatabaseService.shared.allSongs.first { $0.id == songId }
            }
        }
        set {
            if newValue.count > 4 {
                fatalError("Cannot select more than 4 songs")
            }
            let newString = newValue.isEmpty ? nil : newValue.map { $0.id }.joined(separator: Self.songSeparator)
            self.setValue(newString, forKey: "songIdsString")
        }
    }
} 
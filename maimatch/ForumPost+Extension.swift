import Foundation
import CoreData

extension ForumPost {
    private static let genreSeparator = "|"
    
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
} 
import Foundation

public struct SongModel: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let category: SongCategory
    
    public init(id: String, title: String, category: SongCategory) {
        self.id = id
        self.title = title
        self.category = category
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: SongModel, rhs: SongModel) -> Bool {
        lhs.id == rhs.id
    }
}

public enum SongCategory: String, CaseIterable {
    case popAndAnime = "Pop & Anime"
    case niconicoAndVocaloid = "Niconico & Vocaloid"
    case touhou = "東方project"
    case gameAndVariety = "Game & Variety"
    case maimai = "Maimai"
    case ongekiAndChunithm = "Ongeki & Chunithm"
    case partyRoom = "宴会場"
    
    public var displayName: String {
        return rawValue
    }
} 
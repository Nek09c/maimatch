import Foundation

enum Genre: String, CaseIterable, Identifiable {
    case popAnime = "Pop & Anime"
    case niconicoVocaloid = "Niconico & Vocaloid"
    case touhou = "東方project"
    case gameVariety = "Game & Variety"
    case maimai = "Maimai"
    case ongekiChunithm = "Ongeki & Chunithm"
    case partyRoom = "宴会場"
    
    var id: String { rawValue }
    
    var displayName: String {
        return rawValue
    }
} 
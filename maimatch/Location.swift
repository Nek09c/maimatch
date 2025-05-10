import Foundation

enum ArcadeLocation: String, CaseIterable {
    case diamondHill = "鑽石山"
    case mongkokNewCentury = "旺角新之城"
    case mongkokSmartGames = "旺角Smart Games"
    case tsuenWanGold = "荃金"
    
    var displayName: String {
        return self.rawValue
    }
} 
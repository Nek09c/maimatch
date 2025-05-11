import Foundation

enum ArcadeLocation: String, CaseIterable {
    case diamondHill = "鑽石山"
    case mongkokNewCentury = "旺角新之城"
    case mongkokSmartGames = "旺角Smart Games"
    case tsuenWanGold = "荃金"
    case taiPoLeeFukLam = "大埔李福林"
    case yauMaTeiGoldenStar = "油麻地金星"
    case mongkokGoldenChicken = "旺角金雞"
    case wanChaiGoldenStar = "灣仔金星"
    
    var displayName: String {
        return self.rawValue
    }
} 
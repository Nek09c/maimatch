import Foundation

public enum Level: String, CaseIterable, Identifiable {
    case basic = "1-6"
    case intermediate = "7-9+"
    case advanced = "10-12+"
    case expert = "13+"
    case master = "14+"
    case remaster = "15"
    
    public var id: String {
        return self.rawValue
    }
    
    public var displayName: String {
        return self.rawValue
    }
    
    // Color corresponding to maimai difficulty levels
    public var color: String {
        switch self {
        case .basic:
            return "green"
        case .intermediate:
            return "yellow"
        case .advanced:
            return "red"
        case .expert:
            return "purple"
        case .master:
            return "pink"
        case .remaster:
            return "white"
        }
    }
} 
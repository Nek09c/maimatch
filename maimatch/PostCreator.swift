import Foundation

/// Model representing a post creator with unique device ID
struct PostCreator: Codable, Equatable {
    let deviceId: String
    let displayName: String
    
    init(deviceId: String, displayName: String) {
        self.deviceId = deviceId
        self.displayName = displayName
    }
    
    /// Convert to a dictionary for Firestore storage
    func toDictionary() -> [String: Any] {
        return [
            "deviceId": deviceId,
            "displayName": displayName
        ]
    }
    
    /// Create from a dictionary (from Firestore)
    static func fromDictionary(_ dict: [String: Any]) -> PostCreator? {
        guard let deviceId = dict["deviceId"] as? String,
              let displayName = dict["displayName"] as? String else {
            return nil
        }
        
        return PostCreator(deviceId: deviceId, displayName: displayName)
    }
} 
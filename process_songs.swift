#!/usr/bin/env swift

import Foundation

// Define the song structure from the JSON file
struct MaiSong: Codable {
    let title: String
    let artist: String
    let category: String
    let image_file: String
    let version: String
    // The level fields are optional because some songs have dx_lev_ prefix and some have lev_ prefix
    let lev_bas: String?
    let lev_adv: String?
    let lev_exp: String?
    let lev_mas: String?
    let dx_lev_bas: String?
    let dx_lev_adv: String?
    let dx_lev_exp: String?
    let dx_lev_mas: String?
}

// Map category names to our app's categories
func mapCategory(_ category: String) -> String {
    switch category {
    case "流行&动漫": return ".popAndAnime"
    case "niconico＆VOCALOID™": return ".niconicoAndVocaloid"
    case "东方Project": return ".touhou"
    case "其他游戏": return ".gameAndVariety"
    case "舞萌": return ".maimai"
    case "音击/中二节奏": return ".ongekiAndChunithm"
    case "宴会場": return ".partyRoom"
    default: return ".maimai" // Default to maimai for unknown categories
    }
}

// Generate a unique ID for the song based on its category and index
func generateID(category: String, index: Int) -> String {
    let prefix: String
    switch category {
    case ".popAndAnime": prefix = "a"
    case ".niconicoAndVocaloid": prefix = "n"
    case ".touhou": prefix = "t"
    case ".gameAndVariety": prefix = "g"
    case ".maimai": prefix = "m"
    case ".ongekiAndChunithm": prefix = "o"
    case ".partyRoom": prefix = "p"
    default: prefix = "x"
    }
    
    return "\(prefix)_\(index + 1)"
}

// Load the JSON data
guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: "arcade-data/maidata.json")) else {
    print("Failed to load JSON data")
    exit(1)
}

// Parse the JSON data
guard let songs = try? JSONDecoder().decode([MaiSong].self, from: jsonData) else {
    print("Failed to parse JSON data")
    exit(1)
}

// Group songs by category
var songsByCategory: [String: [MaiSong]] = [:]
for song in songs {
    let category = mapCategory(song.category)
    if songsByCategory[category] == nil {
        songsByCategory[category] = []
    }
    songsByCategory[category]?.append(song)
}

// Generate Swift code for songs by category
var generatedCode = ""
for (category, songs) in songsByCategory {
    generatedCode += "// \(category.replacingOccurrences(of: ".", with: "")) songs\n"
    generatedCode += "songs.append(contentsOf: [\n"
    
    for (index, song) in songs.enumerated() {
        let id = generateID(category: category, index: index)
        generatedCode += "    SongModel(id: \"\(id)\", title: \"\(song.title.replacingOccurrences(of: "\"", with: "\\\""))\", category: \(category)),\n"
    }
    
    generatedCode += "])\n\n"
}

// Print the generated code
print(generatedCode)

// Write the generated code to a file
let outputFilePath = "generated_songs.swift"
do {
    try generatedCode.write(to: URL(fileURLWithPath: outputFilePath), atomically: true, encoding: .utf8)
    print("Generated code written to \(outputFilePath)")
} catch {
    print("Failed to write generated code to file: \(error)")
} 
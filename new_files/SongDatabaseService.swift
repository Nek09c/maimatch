import Foundation

class SongDatabaseService {
    static let shared = SongDatabaseService()
    
    let allSongs: [SongModel] = [
        // Pop & Anime
        SongModel(id: "a_1", title: "新宝島", category: .popAndAnime),
        SongModel(id: "a_2", title: "ようこそジャパリパークへ", category: .popAndAnime),
        SongModel(id: "a_3", title: "POP STAR", category: .popAndAnime),
        SongModel(id: "a_4", title: "気まぐれロマンティック", category: .popAndAnime),
        SongModel(id: "a_5", title: "前前前世", category: .popAndAnime),
        
        // Niconico & Vocaloid
        SongModel(id: "n_1", title: "千本桜", category: .niconicoAndVocaloid),
        SongModel(id: "n_2", title: "脳漿炸裂ガール", category: .niconicoAndVocaloid),
        SongModel(id: "n_3", title: "初音ミクの消失", category: .niconicoAndVocaloid),
        SongModel(id: "n_4", title: "ワールズエンド・ダンスホール", category: .niconicoAndVocaloid),
        SongModel(id: "n_5", title: "ロキ", category: .niconicoAndVocaloid),
        
        // 東方project
        SongModel(id: "t_1", title: "信仰は儚き人間の為に", category: .touhou),
        SongModel(id: "t_2", title: "幽雅に咲かせ、墨染の桜", category: .touhou),
        SongModel(id: "t_3", title: "緋色のDance", category: .touhou),
        SongModel(id: "t_4", title: "感情の摩天楼", category: .touhou),
        SongModel(id: "t_5", title: "ナイト・オブ・ナイツ", category: .touhou),
        
        // Game & Variety
        SongModel(id: "g_1", title: "FREEDOM DiVE↓", category: .gameAndVariety),
        SongModel(id: "g_2", title: "DRAGONLADY", category: .gameAndVariety),
        SongModel(id: "g_3", title: "夜明けまであと3秒", category: .gameAndVariety),
        SongModel(id: "g_4", title: "ゲームオーバー", category: .gameAndVariety),
        SongModel(id: "g_5", title: "Halcyon", category: .gameAndVariety),
        
        // Maimai
        SongModel(id: "m_1", title: "Nitrous Fury", category: .maimai),
        SongModel(id: "m_2", title: "REVIVER オルタンシア・サーガ", category: .maimai),
        SongModel(id: "m_3", title: "Glorious Crown", category: .maimai),
        SongModel(id: "m_4", title: "Garakuta Doll Play", category: .maimai),
        SongModel(id: "m_5", title: "Credits", category: .maimai),
        
        // Ongeki & Chunithm
        SongModel(id: "o_1", title: "GENOCIDER", category: .ongekiAndChunithm),
        SongModel(id: "o_2", title: "Singularity", category: .ongekiAndChunithm),
        SongModel(id: "o_3", title: "Garakuta Doll Play", category: .ongekiAndChunithm),
        SongModel(id: "o_4", title: "AMAZING MIGHTYYYY!!!!", category: .ongekiAndChunithm),
        SongModel(id: "o_5", title: "Grievous Lady", category: .ongekiAndChunithm),
        
        // 宴会場
        SongModel(id: "p_1", title: "KING", category: .partyRoom),
        SongModel(id: "p_2", title: "アスノヨゾラ哨戒班", category: .partyRoom),
        SongModel(id: "p_3", title: "宿命", category: .partyRoom),
        SongModel(id: "p_4", title: "紅蓮華", category: .partyRoom),
        SongModel(id: "p_5", title: "群青", category: .partyRoom)
    ]
    
    // Get songs by category
    func songs(forCategory category: SongCategory) -> [SongModel] {
        return allSongs.filter { $0.category == category }
    }
    
    // Search songs by title
    func searchSongs(query: String) -> [SongModel] {
        guard !query.isEmpty else { return [] }
        return allSongs.filter { $0.title.lowercased().contains(query.lowercased()) }
    }
} 
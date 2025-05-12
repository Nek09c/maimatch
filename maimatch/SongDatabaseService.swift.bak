import Foundation

public class SongDatabaseService {
    public static let shared = SongDatabaseService()
    
    public let allSongs: [SongModel]
    
    private init() {
        // Initialize allSongs with the maimai songs data
        var songs: [SongModel] = []
        
        // Pop & Anime (流行&动漫)
        songs.append(contentsOf: [
            // Original songs
            SongModel(id: "a_1", title: "新宝島", category: .popAndAnime),
            SongModel(id: "a_2", title: "ようこそジャパリパークへ", category: .popAndAnime),
            SongModel(id: "a_3", title: "POP STAR", category: .popAndAnime),
            SongModel(id: "a_4", title: "気まぐれロマンティック", category: .popAndAnime),
            SongModel(id: "a_5", title: "前前前世", category: .popAndAnime),
            
            // Added songs from database
            SongModel(id: "a_6", title: "HOT LIMIT", category: .popAndAnime),
            SongModel(id: "a_7", title: "ネ！コ！", category: .popAndAnime),
            SongModel(id: "a_8", title: "真・ハンサム体操でズンドコホイ", category: .popAndAnime),
            SongModel(id: "a_9", title: "GET!! 夢&DREAM", category: .popAndAnime),
            SongModel(id: "a_10", title: "バラライカ", category: .popAndAnime),
            SongModel(id: "a_11", title: "若い力 -SEGA HARD GIRLS MIX-", category: .popAndAnime),
            SongModel(id: "a_12", title: "セハガガガンバッちゃう！！", category: .popAndAnime),
            SongModel(id: "a_13", title: "ラブリー☆えんじぇる!!", category: .popAndAnime),
            SongModel(id: "a_14", title: "ラブって♡ジュエリー♪えんじぇる☆ブレイク！！", category: .popAndAnime),
            SongModel(id: "a_15", title: "デビル☆アイドル", category: .popAndAnime),
            SongModel(id: "a_16", title: "きらっせ☆ウッド村ファーム", category: .popAndAnime),
            SongModel(id: "a_17", title: "にじよめちゃん体操第一億", category: .popAndAnime),
            SongModel(id: "a_18", title: "Rodeo Machine", category: .popAndAnime),
            SongModel(id: "a_19", title: "true my heart -Lovable mix-", category: .popAndAnime),
            SongModel(id: "a_20", title: "Love or Lies", category: .popAndAnime),
            SongModel(id: "a_21", title: "jelly", category: .popAndAnime),
            SongModel(id: "a_22", title: "美しく燃える森", category: .popAndAnime),
            SongModel(id: "a_23", title: "Love You", category: .popAndAnime),
            SongModel(id: "a_24", title: "come again", category: .popAndAnime),
            SongModel(id: "a_25", title: "ロキ", category: .popAndAnime),
            SongModel(id: "a_26", title: "愛言葉Ⅲ", category: .popAndAnime),
            SongModel(id: "a_27", title: "インフェルノ", category: .popAndAnime),
            SongModel(id: "a_28", title: "紅蓮華", category: .popAndAnime),
            SongModel(id: "a_29", title: "炉心融解", category: .popAndAnime),
            SongModel(id: "a_30", title: "KING", category: .popAndAnime),
            SongModel(id: "a_31", title: "君の知らない物語", category: .popAndAnime),
            SongModel(id: "a_32", title: "only my railgun", category: .popAndAnime),
            SongModel(id: "a_33", title: "secret base ～君がくれたもの～", category: .popAndAnime),
            SongModel(id: "a_34", title: "白金ディスコ", category: .popAndAnime),
            SongModel(id: "a_35", title: "恋愛裁判", category: .popAndAnime),
            SongModel(id: "a_36", title: "カラフル", category: .popAndAnime),
            SongModel(id: "a_37", title: "チルノのパーフェクトさんすう教室", category: .popAndAnime),
            SongModel(id: "a_38", title: "REVIVER", category: .popAndAnime),
            SongModel(id: "a_39", title: "コネクト", category: .popAndAnime),
            SongModel(id: "a_40", title: "Rising Hope", category: .popAndAnime),
        ])
        
        // Niconico & Vocaloid (niconico＆VOCALOID™)
        songs.append(contentsOf: [
            // Original songs
            SongModel(id: "n_1", title: "千本桜", category: .niconicoAndVocaloid),
            SongModel(id: "n_2", title: "脳漿炸裂ガール", category: .niconicoAndVocaloid),
            SongModel(id: "n_3", title: "初音ミクの消失", category: .niconicoAndVocaloid),
            SongModel(id: "n_4", title: "ワールズエンド・ダンスホール", category: .niconicoAndVocaloid),
            SongModel(id: "n_5", title: "ロキ", category: .niconicoAndVocaloid),

            // Added songs from database
            SongModel(id: "n_6", title: "アンドロイドガール", category: .niconicoAndVocaloid),
            SongModel(id: "n_7", title: "スロウダウナー", category: .niconicoAndVocaloid),
            SongModel(id: "n_8", title: "ビターチョコデコレーション", category: .niconicoAndVocaloid),
            SongModel(id: "n_9", title: "スターリースカイ☆パレード", category: .niconicoAndVocaloid),
            SongModel(id: "n_10", title: "だれかの心臓になれたなら", category: .niconicoAndVocaloid),
            SongModel(id: "n_11", title: "グリーンライツ・セレナーデ", category: .niconicoAndVocaloid),
            SongModel(id: "n_12", title: "METEOR", category: .niconicoAndVocaloid),
            SongModel(id: "n_13", title: "だからパンを焼いたんだ", category: .niconicoAndVocaloid),
            SongModel(id: "n_14", title: "太陽系デスコ", category: .niconicoAndVocaloid),
            SongModel(id: "n_15", title: "彗星ハネムーン", category: .niconicoAndVocaloid),
            SongModel(id: "n_16", title: "エイリアンエイリアン", category: .niconicoAndVocaloid),
            SongModel(id: "n_17", title: "ブリキノダンス", category: .niconicoAndVocaloid),
            SongModel(id: "n_18", title: "アンノウン・マザーグース", category: .niconicoAndVocaloid),
            SongModel(id: "n_19", title: "39みゅーじっく！", category: .niconicoAndVocaloid),
            SongModel(id: "n_20", title: "天ノ弱", category: .niconicoAndVocaloid),
            SongModel(id: "n_21", title: "ヒビカセ", category: .niconicoAndVocaloid),
            SongModel(id: "n_22", title: "ゴーストルール", category: .niconicoAndVocaloid),
            SongModel(id: "n_23", title: "深海少女", category: .niconicoAndVocaloid),
            SongModel(id: "n_24", title: "砂の惑星 feat. 初音ミク", category: .niconicoAndVocaloid),
            SongModel(id: "n_25", title: "おねがいダーリン", category: .niconicoAndVocaloid),
            SongModel(id: "n_26", title: "六兆年と一夜物語", category: .niconicoAndVocaloid),
            SongModel(id: "n_27", title: "ウミユリ海底譚", category: .niconicoAndVocaloid),
            SongModel(id: "n_28", title: "カゲロウデイズ", category: .niconicoAndVocaloid),
            SongModel(id: "n_29", title: "シャルル", category: .niconicoAndVocaloid),
            SongModel(id: "n_30", title: "命に嫌われている", category: .niconicoAndVocaloid),
            SongModel(id: "n_31", title: "マトリョシカ", category: .niconicoAndVocaloid),
            SongModel(id: "n_32", title: "からくりピエロ", category: .niconicoAndVocaloid),
            SongModel(id: "n_33", title: "ローリンガール", category: .niconicoAndVocaloid),
            SongModel(id: "n_34", title: "アスノヨゾラ哨戒班", category: .niconicoAndVocaloid),
            SongModel(id: "n_35", title: "メルト", category: .niconicoAndVocaloid),
            SongModel(id: "n_36", title: "ラブカ？", category: .niconicoAndVocaloid),
            SongModel(id: "n_37", title: "ヴァンパイア", category: .niconicoAndVocaloid),
            SongModel(id: "n_38", title: "劣等上等", category: .niconicoAndVocaloid),
            SongModel(id: "n_39", title: "ジャンキーナイトタウンオーケストラ", category: .niconicoAndVocaloid),
            SongModel(id: "n_40", title: "チュルリラ・チュルリラ・ダッダッダ！", category: .niconicoAndVocaloid),
        ])
        
        // 東方project (东方Project)
        songs.append(contentsOf: [
            // Original songs
            SongModel(id: "t_1", title: "信仰は儚き人間の為に", category: .touhou),
            SongModel(id: "t_2", title: "幽雅に咲かせ、墨染の桜", category: .touhou),
            SongModel(id: "t_3", title: "緋色のDance", category: .touhou),
            SongModel(id: "t_4", title: "感情の摩天楼", category: .touhou),
            SongModel(id: "t_5", title: "ナイト・オブ・ナイツ", category: .touhou),
            
            // Added songs from database
            SongModel(id: "t_6", title: "ソリッド", category: .touhou),
            SongModel(id: "t_7", title: "Bad Apple!! feat.nomico (REDALiCE Remix)", category: .touhou),
            SongModel(id: "t_8", title: "Bad Apple!! feat nomico", category: .touhou),
            SongModel(id: "t_9", title: "CYBER Sparks", category: .touhou),
            SongModel(id: "t_10", title: "Money Money", category: .touhou),
            SongModel(id: "t_11", title: "LOVE EAST", category: .touhou),
            SongModel(id: "t_12", title: "WARNING×WARNING×WARNING", category: .touhou),
            SongModel(id: "t_13", title: "泡沫、哀のまほろば", category: .touhou),
            SongModel(id: "t_14", title: "華鳥風月", category: .touhou),
            SongModel(id: "t_15", title: "色は匂へど散りぬるを", category: .touhou),
            SongModel(id: "t_16", title: "月に叢雲華に風", category: .touhou),
            SongModel(id: "t_17", title: "物凄い勢いでけーねが物凄いうた", category: .touhou),
            SongModel(id: "t_18", title: "甲論乙駁", category: .touhou),
            SongModel(id: "t_19", title: "最終鬼畜妹フランドール・S", category: .touhou),
            SongModel(id: "t_20", title: "魔理沙は大変なものを盗んでいきました", category: .touhou),
            SongModel(id: "t_21", title: "Energy Twisters", category: .touhou),
            SongModel(id: "t_22", title: "Reach for the Moon", category: .touhou),
            SongModel(id: "t_23", title: "神々の祈り", category: .touhou),
            SongModel(id: "t_24", title: "Starlight Dance Floor", category: .touhou),
            SongModel(id: "t_25", title: "明星ロケット", category: .touhou),
            SongModel(id: "t_26", title: "疾走あんさんぶる", category: .touhou),
            SongModel(id: "t_27", title: "暁Records", category: .touhou),
            SongModel(id: "t_28", title: "少女綺想曲 Dream Battle", category: .touhou),
            SongModel(id: "t_29", title: "レトロスペクティブ京都", category: .touhou),
            SongModel(id: "t_30", title: "亡き王女の為のセプテット", category: .touhou),
            SongModel(id: "t_31", title: "輝く針の小人族 ~ Little Princess", category: .touhou),
            SongModel(id: "t_32", title: "妖精圏 〜 Fairy ring", category: .touhou),
            SongModel(id: "t_33", title: "竹取飛翔 〜 Lunatic Princess", category: .touhou),
            SongModel(id: "t_34", title: "U.N.オーエンは彼女なのか？", category: .touhou),
            SongModel(id: "t_35", title: "チルノのパーフェクトさんすう教室", category: .touhou),
            SongModel(id: "t_36", title: "紅茶冷えてしまいました", category: .touhou),
            SongModel(id: "t_37", title: "神妙", category: .touhou),
            SongModel(id: "t_38", title: "ってゐ！ ～えいえんてゐver～", category: .touhou),
            SongModel(id: "t_39", title: "お嫁にしなさいっ！", category: .touhou),
            SongModel(id: "t_40", title: "キャプテン・ムラサのケツアンカー", category: .touhou),
        ])
        
        // Game & Variety (其他游戏)
        songs.append(contentsOf: [
            // Original songs
            SongModel(id: "g_1", title: "FREEDOM DiVE↓", category: .gameAndVariety),
            SongModel(id: "g_2", title: "DRAGONLADY", category: .gameAndVariety),
            SongModel(id: "g_3", title: "夜明けまであと3秒", category: .gameAndVariety),
            SongModel(id: "g_4", title: "ゲームオーバー", category: .gameAndVariety),
            SongModel(id: "g_5", title: "Halcyon", category: .gameAndVariety),
            
            // Added songs from database
            SongModel(id: "g_6", title: "BATTLE NO.1", category: .gameAndVariety),
            SongModel(id: "g_7", title: "Black Lair", category: .gameAndVariety),
            SongModel(id: "g_8", title: "FLOWER", category: .gameAndVariety),
            SongModel(id: "g_9", title: "Scars of FAUNA", category: .gameAndVariety),
            SongModel(id: "g_10", title: "極圏", category: .gameAndVariety),
            SongModel(id: "g_11", title: "きたさいたま2000", category: .gameAndVariety),
            SongModel(id: "g_12", title: "Ignis Danse", category: .gameAndVariety),
            SongModel(id: "g_13", title: "セイクリッド　ルイン", category: .gameAndVariety),
            SongModel(id: "g_14", title: "Got more raves？", category: .gameAndVariety),
            SongModel(id: "g_15", title: "Reach for the Stars", category: .gameAndVariety),
            SongModel(id: "g_16", title: "Live & Learn", category: .gameAndVariety),
            SongModel(id: "g_17", title: "Fist Bump", category: .gameAndVariety),
            SongModel(id: "g_18", title: "We Can Win", category: .gameAndVariety),
            SongModel(id: "g_19", title: "Los! Los! Los!", category: .gameAndVariety),
            SongModel(id: "g_20", title: "Beat Of Mind", category: .gameAndVariety),
            SongModel(id: "g_21", title: "Help me, ERINNNNNN!!", category: .gameAndVariety),
            SongModel(id: "g_22", title: "MEGALOVANIA", category: .gameAndVariety),
            SongModel(id: "g_23", title: "Venomous", category: .gameAndVariety),
            SongModel(id: "g_24", title: "GEMINI -M-", category: .gameAndVariety),
            SongModel(id: "g_25", title: "最終鬼畜妹フランドール・S", category: .gameAndVariety),
            SongModel(id: "g_26", title: "Calamity Fortune", category: .gameAndVariety),
            SongModel(id: "g_27", title: "Scarlet Lance", category: .gameAndVariety),
            SongModel(id: "g_28", title: "Brain Power", category: .gameAndVariety),
            SongModel(id: "g_29", title: "Kattobi KEIKYU Rider", category: .gameAndVariety),
            SongModel(id: "g_30", title: "Gate of Doom", category: .gameAndVariety),
            SongModel(id: "g_31", title: "Symmetric Generation", category: .gameAndVariety),
            SongModel(id: "g_32", title: "Link", category: .gameAndVariety),
            SongModel(id: "g_33", title: "AMAZING MIGHTYYYY!!!!", category: .gameAndVariety),
            SongModel(id: "g_34", title: "ENERGY SYNERGY MATRIX", category: .gameAndVariety),
            SongModel(id: "g_35", title: "Glorious Crown", category: .gameAndVariety),
            SongModel(id: "g_36", title: "Ultranova", category: .gameAndVariety),
            SongModel(id: "g_37", title: "SILENT BLUE", category: .gameAndVariety),
            SongModel(id: "g_38", title: "The wheel to the right", category: .gameAndVariety),
            SongModel(id: "g_39", title: "Grievous Lady", category: .gameAndVariety),
            SongModel(id: "g_40", title: "Garakuta Doll Play", category: .gameAndVariety),
        ])
        
        // Maimai (舞萌)
        songs.append(contentsOf: [
            // Original songs
            SongModel(id: "m_1", title: "Nitrous Fury", category: .maimai),
            SongModel(id: "m_2", title: "REVIVER オルタンシア・サーガ", category: .maimai),
            SongModel(id: "m_3", title: "Glorious Crown", category: .maimai),
            SongModel(id: "m_4", title: "Garakuta Doll Play", category: .maimai),
            SongModel(id: "m_5", title: "Credits", category: .maimai),
            
            // Added songs from database
            SongModel(id: "m_6", title: "Link", category: .maimai),
            SongModel(id: "m_7", title: "ヤミツキ", category: .maimai),
            SongModel(id: "m_8", title: "Secret Sleuth", category: .maimai),
            SongModel(id: "m_9", title: "BLACK ROSE", category: .maimai),
            SongModel(id: "m_10", title: "言ノ葉カルマ", category: .maimai),
            SongModel(id: "m_11", title: "悪戯", category: .maimai),
            SongModel(id: "m_12", title: "言ノ葉遊戯", category: .maimai),
            SongModel(id: "m_13", title: "りばーぶ", category: .maimai),
            SongModel(id: "m_14", title: "洗脳", category: .maimai),
            SongModel(id: "m_15", title: "Barbed Eye", category: .maimai),
            SongModel(id: "m_16", title: "麗しき鉄血の紅", category: .maimai),
            SongModel(id: "m_17", title: "METEOR", category: .maimai),
            SongModel(id: "m_18", title: "My First Phone", category: .maimai),
            SongModel(id: "m_19", title: "CYCLES", category: .maimai),
            SongModel(id: "m_20", title: "Maxi", category: .maimai),
            SongModel(id: "m_21", title: "Axeria", category: .maimai),
            SongModel(id: "m_22", title: "larva", category: .maimai),
            SongModel(id: "m_23", title: "Xevel", category: .maimai),
            SongModel(id: "m_24", title: "Mjölnir", category: .maimai),
            SongModel(id: "m_25", title: "Caliburne ～Story of the Legendary sword～", category: .maimai),
            SongModel(id: "m_26", title: "カミサマネジマキ", category: .maimai),
            SongModel(id: "m_27", title: "MAXRAGE", category: .maimai),
            SongModel(id: "m_28", title: "Contrapasso -paradiso-", category: .maimai),
            SongModel(id: "m_29", title: "PANDORA PARADOXXX", category: .maimai),
            SongModel(id: "m_30", title: "KING is BACK!!", category: .maimai),
            SongModel(id: "m_31", title: "Fragrance", category: .maimai),
            SongModel(id: "m_32", title: "Credits", category: .maimai),
            SongModel(id: "m_33", title: "Excalibur ～Revived resolution～", category: .maimai),
            SongModel(id: "m_34", title: "Panopticon", category: .maimai),
            SongModel(id: "m_35", title: "QZKago Requiem", category: .maimai),
            SongModel(id: "m_36", title: "ジングルベル", category: .maimai),
            SongModel(id: "m_37", title: "Technicians High", category: .maimai),
            SongModel(id: "m_38", title: "デッドレッドガールズ", category: .maimai),
            SongModel(id: "m_39", title: "Energy Synergy Matrix", category: .maimai),
            SongModel(id: "m_40", title: "Schwarzschild", category: .maimai),
        ])
        
        // Ongeki & Chunithm (音击/中二节奏)
        songs.append(contentsOf: [
            // Original songs
            SongModel(id: "o_1", title: "GENOCIDER", category: .ongekiAndChunithm),
            SongModel(id: "o_2", title: "Singularity", category: .ongekiAndChunithm),
            SongModel(id: "o_3", title: "Garakuta Doll Play", category: .ongekiAndChunithm),
            SongModel(id: "o_4", title: "AMAZING MIGHTYYYY!!!!", category: .ongekiAndChunithm),
            SongModel(id: "o_5", title: "Grievous Lady", category: .ongekiAndChunithm),
            
            // Added songs from database
            SongModel(id: "o_6", title: "STARTLINER", category: .ongekiAndChunithm),
            SongModel(id: "o_7", title: "Jump!! Jump!! Jump!!", category: .ongekiAndChunithm),
            SongModel(id: "o_8", title: "Titania", category: .ongekiAndChunithm),
            SongModel(id: "o_9", title: "Change Our MIRAI！", category: .ongekiAndChunithm),
            SongModel(id: "o_10", title: "無敵We are one!!", category: .ongekiAndChunithm),
            SongModel(id: "o_11", title: "ドキドキDREAM!!!", category: .ongekiAndChunithm),
            SongModel(id: "o_12", title: "Still", category: .ongekiAndChunithm),
            SongModel(id: "o_13", title: "Session High⤴", category: .ongekiAndChunithm),
            SongModel(id: "o_14", title: "Agitation！", category: .ongekiAndChunithm),
            SongModel(id: "o_15", title: "管弦楽組曲 第3番 ニ長調「第2曲（G線上のアリア）」BWV.1068-2", category: .ongekiAndChunithm),
            SongModel(id: "o_16", title: "Random", category: .ongekiAndChunithm),
            SongModel(id: "o_17", title: "Last Brave", category: .ongekiAndChunithm),
            SongModel(id: "o_18", title: "World Vanquisher", category: .ongekiAndChunithm),
            SongModel(id: "o_19", title: "FREEDOM DiVE", category: .ongekiAndChunithm),
            SongModel(id: "o_20", title: "LANCE", category: .ongekiAndChunithm),
            SongModel(id: "o_21", title: "FLUFFY FLASH", category: .ongekiAndChunithm),
            SongModel(id: "o_22", title: "L9", category: .ongekiAndChunithm),
            SongModel(id: "o_23", title: "Opfer", category: .ongekiAndChunithm),
            SongModel(id: "o_24", title: "混沌を越えし閃光", category: .ongekiAndChunithm),
            SongModel(id: "o_25", title: "Vibes 2k20", category: .ongekiAndChunithm),
            SongModel(id: "o_26", title: "Dazzle hop", category: .ongekiAndChunithm),
            SongModel(id: "o_27", title: "BlythE", category: .ongekiAndChunithm),
            SongModel(id: "o_28", title: "We Gonna Journey", category: .ongekiAndChunithm),
            SongModel(id: "o_29", title: "Lionheart", category: .ongekiAndChunithm),
            SongModel(id: "o_30", title: "四月の雨", category: .ongekiAndChunithm),
            SongModel(id: "o_31", title: "初音ミクの消失", category: .ongekiAndChunithm),
            SongModel(id: "o_32", title: "MEGALOVANIA", category: .ongekiAndChunithm),
            SongModel(id: "o_33", title: "HONEY-Q", category: .ongekiAndChunithm),
            SongModel(id: "o_34", title: "Falsum Atlantis.", category: .ongekiAndChunithm),
            SongModel(id: "o_35", title: "Blaster Heaven", category: .ongekiAndChunithm),
            SongModel(id: "o_36", title: "Viyella's Tears", category: .ongekiAndChunithm),
            SongModel(id: "o_37", title: "Singularity", category: .ongekiAndChunithm),
            SongModel(id: "o_38", title: "Death Threats", category: .ongekiAndChunithm),
            SongModel(id: "o_39", title: "Aiolos", category: .ongekiAndChunithm),
            SongModel(id: "o_40", title: "Valsqotch", category: .ongekiAndChunithm),
        ])
        
        // 宴会場 (Party Room)
        songs.append(contentsOf: [
            // Original songs
            SongModel(id: "p_1", title: "KING", category: .partyRoom),
            SongModel(id: "p_2", title: "アスノヨゾラ哨戒班", category: .partyRoom),
            SongModel(id: "p_3", title: "宿命", category: .partyRoom),
            SongModel(id: "p_4", title: "紅蓮華", category: .partyRoom),
            SongModel(id: "p_5", title: "群青", category: .partyRoom),
            
            // Added songs from database
            SongModel(id: "p_6", title: "シャルル", category: .partyRoom),
            SongModel(id: "p_7", title: "劣等上等", category: .partyRoom),
            SongModel(id: "p_8", title: "命に嫌われている", category: .partyRoom),
            SongModel(id: "p_9", title: "廻廻奇譚", category: .partyRoom),
            SongModel(id: "p_10", title: "夜に駆ける", category: .partyRoom),
            SongModel(id: "p_11", title: "ハルジオン", category: .partyRoom),
            SongModel(id: "p_12", title: "阿吽のビーツ", category: .partyRoom),
            SongModel(id: "p_13", title: "聖者の息吹", category: .partyRoom),
            SongModel(id: "p_14", title: "Lost in Paradise", category: .partyRoom),
            SongModel(id: "p_15", title: "踊", category: .partyRoom),
            SongModel(id: "p_16", title: "再会", category: .partyRoom),
            SongModel(id: "p_17", title: "ダーリンダンス", category: .partyRoom),
            SongModel(id: "p_18", title: "乙女解剖", category: .partyRoom),
            SongModel(id: "p_19", title: "愛言葉Ⅲ", category: .partyRoom),
            SongModel(id: "p_20", title: "Calc.", category: .partyRoom),
            SongModel(id: "p_21", title: "インフェルノ", category: .partyRoom),
            SongModel(id: "p_22", title: "炎", category: .partyRoom),
            SongModel(id: "p_23", title: "怪物", category: .partyRoom),
            SongModel(id: "p_24", title: "君の知らない物語", category: .partyRoom),
            SongModel(id: "p_25", title: "前前前世", category: .partyRoom),
            SongModel(id: "p_26", title: "only my railgun", category: .partyRoom),
            SongModel(id: "p_27", title: "お勉強しといてよ", category: .partyRoom),
            SongModel(id: "p_28", title: "KING", category: .partyRoom),
            SongModel(id: "p_29", title: "ヴァンパイア", category: .partyRoom),
            SongModel(id: "p_30", title: "カナデレル", category: .partyRoom),
        ])
        
        self.allSongs = songs
    }
    
    // Get songs by category
    public func songs(forCategory category: SongCategory) -> [SongModel] {
        return allSongs.filter { $0.category == category }
    }
    
    // Search songs by title
    public func searchSongs(query: String) -> [SongModel] {
        guard !query.isEmpty else { return [] }
        return allSongs.filter { $0.title.lowercased().contains(query.lowercased()) }
    }
}
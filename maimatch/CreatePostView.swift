import SwiftUI

struct CreatePostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ForumViewModel
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var authorName: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var selectedLocation: ArcadeLocation
    @State private var selectedGenres: [Genre] = []
    @State private var selectedSongs: [SongModel] = []
    @State private var selectedLevels: [Level] = []
    @State private var showGenreSelector = false
    @State private var showLevelSelector = false
    
    @State private var isValid: Bool = false
    
    // Auth service for device ID-based creator identification
    private let authService = LocalAuthService()
    
    // Create a formatter for placeholders
    private let placeholderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    init(viewModel: ForumViewModel, preselectedLocation: ArcadeLocation? = nil) {
        self.viewModel = viewModel
        self._selectedLocation = State(initialValue: preselectedLocation ?? .diamondHill)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Post內容")) {
                    TextField("標題(想R機? 想被R機?)", text: $title)
                        .autocorrectionDisabled()
                    
                    ZStack(alignment: .topLeading) {
                        if content.isEmpty {
                            Text("個人資訊(要點樣搵你, 你著咩衫, 有咩特徵...)")
                                .foregroundColor(Color(.placeholderText))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        
                        TextEditor(text: $content)
                            .frame(minHeight: 100)
                            .autocorrectionDisabled()
                    }
                    
                    TextField("你嘅名(maimai名/稱呼)", text: $authorName)
                        .autocorrectionDisabled()
                        .onChange(of: authorName) { newValue in
                            if !newValue.isEmpty {
                                UserDefaults.standard.set(newValue, forKey: "username")
                            }
                        }
                    
                    HStack {
                        Text("Maimai地點:")
                        Spacer()
                        Picker("", selection: $selectedLocation) {
                            ForEach(ArcadeLocation.allCases, id: \.self) { location in
                                Text(location.displayName).tag(location)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                Section(header: Text("技術水平(可唔揀)")) {
                    HStack {
                        if selectedLevels.isEmpty {
                            Text("未揀")
                                .foregroundColor(.secondary)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(selectedLevels) { level in
                                        LevelChip(level: level) {
                                            selectedLevels.removeAll(where: { $0 == level })
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showLevelSelector = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .sheet(isPresented: $showLevelSelector) {
                            LevelSelectorView(selectedLevels: $selectedLevels)
                        }
                    }
                }
                
                Section(header: Text("歌曲分類(可唔揀)")) {
                    HStack {
                        if selectedGenres.isEmpty {
                            Text("未揀")
                                .foregroundColor(.secondary)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(selectedGenres, id: \.self) { genre in
                                        GenreChip(genre: genre, isSelected: true) {
                                            selectedGenres.removeAll(where: { $0 == genre })
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showGenreSelector = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .sheet(isPresented: $showGenreSelector) {
                            GenreSelectorView(selectedGenres: $selectedGenres)
                        }
                    }
                }
                
                Section(header: Text("歌曲(可唔揀)")) {
                    SongSelectionUI(selectedSongs: $selectedSongs)
                }
            }
            .navigationTitle("開Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        createPost()
                    }
                    .disabled(!isValid)
                    .foregroundColor(isValid ? .blue : .secondary)
                }
            }
            .onChange(of: title) { _ in validateForm() }
            .onChange(of: content) { _ in validateForm() }
            .onChange(of: authorName) { _ in validateForm() }
            .onAppear {
                // Load saved username
                authorName = authService.getOrCreateDisplayName()
                validateForm()
            }
        }
        .withDefaultBackground()
    }
    
    private func validateForm() {
        isValid = !title.isEmpty && !content.isEmpty && !authorName.isEmpty
    }
    
    private func createPost() {
        // Ensure display name is saved
        if !authorName.isEmpty {
            authService.updateDisplayName(newName: authorName)
        }
        
        viewModel.createPost(
            title: title,
            content: content,
            authorName: authorName,
            location: selectedLocation,
            genres: selectedGenres,
            songs: selectedSongs,
            levels: selectedLevels
        )
        
        presentationMode.wrappedValue.dismiss()
    }
}

// LevelChip view to display selected levels
struct LevelChip: View {
    let level: Level
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(level.displayName)
                .font(.system(size: 14))
                .foregroundColor(.white)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color(level.color))
        .cornerRadius(14)
    }
}

// LevelSelectorView to select difficulty levels
struct LevelSelectorView: View {
    @Binding var selectedLevels: [Level]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Level.allCases) { level in
                    Button(action: {
                        toggleLevel(level)
                    }) {
                        HStack {
                            Text(level.displayName)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(level.color))
                                .cornerRadius(8)
                            
                            Spacer()
                            
                            if selectedLevels.contains(level) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("選擇難度")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func toggleLevel(_ level: Level) {
        if selectedLevels.contains(level) {
            selectedLevels.removeAll(where: { $0 == level })
        } else {
            selectedLevels.append(level)
        }
    }
}

struct GenreChip: View {
    let genre: Genre
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(genre.displayName)
                .font(.system(size: 14))
                .foregroundColor(isSelected ? .white : .primary)
            
            if isSelected {
                Button(action: onTap) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(isSelected ? Color.purple : Color(.systemGray5))
        .cornerRadius(14)
    }
}

struct GenreSelectorView: View {
    @Binding var selectedGenres: [Genre]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Genre.allCases, id: \.self) { genre in
                    Button(action: {
                        toggleGenre(genre)
                    }) {
                        HStack {
                            Text(genre.displayName)
                            Spacer()
                            if selectedGenres.contains(genre) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("選擇分類")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func toggleGenre(_ genre: Genre) {
        if selectedGenres.contains(genre) {
            selectedGenres.removeAll(where: { $0 == genre })
        } else {
            selectedGenres.append(genre)
        }
    }
} 

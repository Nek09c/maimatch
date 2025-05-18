import SwiftUI

internal struct SongSelectionUI: View {
    @Binding var selectedSongs: [SongModel]
    @State private var selectedCategory: SongCategory?
    @State private var searchText: String = ""
    @State private var showingCategorySheet = false
    
    private var songDatabase = SongDatabaseService.shared
    
    public init(selectedSongs: Binding<[SongModel]>) {
        self._selectedSongs = selectedSongs
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Selected songs section
            if !selectedSongs.isEmpty {
                Text("Selected Songs (\(selectedSongs.count)/4)")
                    .font(.headline)
                    .padding(.bottom, 4)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(selectedSongs) { song in
                            SelectedSongCell(song: song) {
                                selectedSongs.removeAll(where: { $0.id == song.id })
                            }
                        }
                    }
                }
                .padding(.bottom, 8)
            }
            
            // Add song button
            if selectedSongs.count < 4 {
                Button(action: {
                    showingCategorySheet = true
                }) {
                    Label("Add Song", systemImage: "plus.circle")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showingCategorySheet) {
                    NavigationView {
                        SongCategorySelectionView(selectedSongs: $selectedSongs, dismiss: { showingCategorySheet = false })
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

internal struct SongCategorySelectionView: View {
    @Binding var selectedSongs: [SongModel]
    var dismiss: () -> Void
    @State private var searchText: String = ""
    
    let categories = SongCategory.allCases
    
    public init(selectedSongs: Binding<[SongModel]>, dismiss: @escaping () -> Void) {
        self._selectedSongs = selectedSongs
        self.dismiss = dismiss
    }
    
    var body: some View {
        List {
            Section(header: Text("Search")) {
                TextField("Search songs", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !searchText.isEmpty {
                    let searchResults = SongDatabaseService.shared.searchSongs(query: searchText)
                    ForEach(searchResults) { song in
                        SongRow(song: song, isSelected: selectedSongs.contains(where: { $0.id == song.id })) {
                            toggleSongSelection(song)
                        }
                    }
                }
            }
            
            Section(header: Text("Categories")) {
                ForEach(categories, id: \.self) { category in
                    NavigationLink(destination: SongListView(category: category, selectedSongs: $selectedSongs)) {
                        Text(category.displayName)
                    }
                }
            }
        }
        .navigationTitle("Select Songs")
        .navigationBarItems(trailing: Button("Done") { dismiss() })
    }
    
    private func toggleSongSelection(_ song: SongModel) {
        if selectedSongs.contains(where: { $0.id == song.id }) {
            selectedSongs.removeAll(where: { $0.id == song.id })
        } else if selectedSongs.count < 4 {
            selectedSongs.append(song)
        }
    }
}

internal struct SongListView: View {
    let category: SongCategory
    @Binding var selectedSongs: [SongModel]
    @State private var searchText: String = ""
    
    public init(category: SongCategory, selectedSongs: Binding<[SongModel]>) {
        self.category = category
        self._selectedSongs = selectedSongs
    }
    
    var body: some View {
        VStack {
            TextField("Search in \(category.displayName)", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            List {
                let songs = SongDatabaseService.shared.songs(forCategory: category)
                let filteredSongs = searchText.isEmpty 
                    ? songs 
                    : songs.filter { $0.title.lowercased().contains(searchText.lowercased()) }
                
                ForEach(filteredSongs) { song in
                    SongRow(song: song, isSelected: selectedSongs.contains(where: { $0.id == song.id })) {
                        toggleSongSelection(song)
                    }
                }
            }
        }
        .navigationTitle(category.displayName)
    }
    
    private func toggleSongSelection(_ song: SongModel) {
        if selectedSongs.contains(where: { $0.id == song.id }) {
            selectedSongs.removeAll(where: { $0.id == song.id })
        } else if selectedSongs.count < 4 {
            selectedSongs.append(song)
        }
    }
}

internal struct SongRow: View {
    let song: SongModel
    let isSelected: Bool
    let onTap: () -> Void
    
    public init(song: SongModel, isSelected: Bool, onTap: @escaping () -> Void) {
        self.song = song
        self.isSelected = isSelected
        self.onTap = onTap
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.system(size: 16, weight: .medium))
                Text(song.category.displayName)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            } else if !isSelected {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

internal struct SelectedSongCell: View {
    let song: SongModel
    let onRemove: () -> Void
    
    public init(song: SongModel, onRemove: @escaping () -> Void) {
        self.song = song
        self.onRemove = onRemove
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text(song.title)
                .font(.system(size: 14, weight: .medium))
                .lineLimit(1)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.1))
        )
    }
} 
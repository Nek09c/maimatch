import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ForumViewModel
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var authorName: String = ""
    @State private var selectedGenres: Set<Genre> = []
    @State private var selectedSongs: [SongModel] = []
    let preselectedLocation: ArcadeLocation
    
    private var isFormValid: Bool {
        !title.isEmpty && !content.isEmpty && !authorName.isEmpty && !selectedGenres.isEmpty && selectedGenres.count <= 3
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                        .font(.headline)
                    
                    TextField("Your Name", text: $authorName)
                        .font(.subheadline)
                        
                    HStack {
                        Text("Location")
                        Spacer()
                        Text(preselectedLocation.displayName)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Post Details")
                }
                
                Section {
                    ForEach(Genre.allCases) { genre in
                        HStack {
                            Text(genre.displayName)
                            Spacer()
                            if selectedGenres.contains(genre) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedGenres.contains(genre) {
                                selectedGenres.remove(genre)
                            } else if selectedGenres.count < 3 {
                                selectedGenres.insert(genre)
                            }
                        }
                    }
                } header: {
                    Text("Favorite Genres (Max 3)")
                } footer: {
                    Text("Select up to three favorite genres")
                }
                
                Section {
                    SongSelectionUI(selectedSongs: $selectedSongs)
                } header: {
                    Text("Selected Songs (Max 4)")
                } footer: {
                    Text("Select up to four songs")
                }
                
                Section {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                        .font(.body)
                } header: {
                    Text("Content")
                } footer: {
                    Text("Share your thoughts with the community")
                        .foregroundColor(.secondary)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Create Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.createPost(
                            title: title,
                            content: content,
                            authorName: authorName,
                            location: preselectedLocation,
                            genres: Array(selectedGenres),
                            songs: selectedSongs
                        )
                        dismiss()
                    } label: {
                        Text("Post")
                            .bold()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
        .withDefaultBackground()
    }
} 
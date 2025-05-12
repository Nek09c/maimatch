import SwiftUI

struct ForumPostView: View {
    let post: ForumPost
    var viewModel: ForumViewModel
    @State private var currentUsername: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var showingUsernamePrompt = false
    @Environment(\.presentationMode) var presentationMode
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var postGenres: [String] {
        post.genresList.map { $0.displayName }
    }
    
    private var postSongs: [SongModel] {
        post.selectedSongs
    }
    
    private var isCreator: Bool {
        return post.authorName == currentUsername
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(post.title ?? "")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        Spacer()
                        Text(post.location ?? "")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                    HStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(post.authorName ?? "Unknown")
                                .font(.headline)
                                .foregroundColor(.primary)
                            if let date = post.createdAt {
                                Text(date, formatter: dateFormatter)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Match status indicator
                    HStack {
                        Text("Status:")
                            .font(.headline)
                        
                        Text(post.isMatched ? "Matched" : "Still looking")
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(post.isMatched ? Color.green : Color.orange)
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        if isCreator {
                            Button(action: {
                                viewModel.toggleMatchStatus(post: post, currentUsername: currentUsername)
                                // Force view to refresh by simulating a navigation action
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                            }) {
                                Text(post.isMatched ? "Reopen Post" : "Mark as Matched")
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    
                    if !postGenres.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(postGenres, id: \.self) { genre in
                                    Text(genre)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.purple)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
                    
                    if !postSongs.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Selected Songs")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            ForEach(postSongs) { song in
                                HStack {
                                    Text(song.title)
                                        .font(.subheadline)
                                    
                                    Spacer()
                                    
                                    Text(song.category.displayName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
                .padding(.bottom, 8)
                
                Divider()
                    .background(Color.secondary.opacity(0.3))
                
                // Content
                Text(post.content ?? "")
                    .font(.body)
                    .lineSpacing(8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 8)
            )
            .padding()
        }
        .withDefaultBackground()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingUsernamePrompt = true
                }) {
                    Image(systemName: "person.crop.circle")
                }
            }
        }
        .alert("Set Your Username", isPresented: $showingUsernamePrompt) {
            TextField("Username", text: $currentUsername)
            
            Button("Cancel", role: .cancel) { }
            
            Button("Save") {
                if !currentUsername.isEmpty {
                    UserDefaults.standard.set(currentUsername, forKey: "username")
                }
            }
        } message: {
            Text("Enter your username to identify yourself as the post creator.")
        }
        .onAppear {
            // Load username from UserDefaults
            currentUsername = UserDefaults.standard.string(forKey: "username") ?? ""
        }
    }
} 
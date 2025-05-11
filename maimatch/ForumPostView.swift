import SwiftUI

struct ForumPostView: View {
    let post: ForumPost
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var postGenres: [String] {
        post.genresList.map { $0.displayName }
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
    }
} 

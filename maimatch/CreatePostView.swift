import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ForumViewModel
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var authorName: String = ""
    let preselectedLocation: ArcadeLocation
    
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
                            location: preselectedLocation
                        )
                        dismiss()
                    } label: {
                        Text("Post")
                            .bold()
                    }
                    .disabled(title.isEmpty || content.isEmpty || authorName.isEmpty)
                }
            }
        }
        .withDefaultBackground()
    }
} 
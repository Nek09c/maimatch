//
//  ContentView.swift
//  maimatch
//
//  Created by carlson chuang on 10/5/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ForumViewModel
    @State private var showingCreatePost = false
    let selectedLocation: ArcadeLocation
    
    @FetchRequest var posts: FetchedResults<ForumPost>
    
    init(viewContext: NSManagedObjectContext, selectedLocation: ArcadeLocation) {
        self.selectedLocation = selectedLocation
        _viewModel = StateObject(wrappedValue: ForumViewModel(viewContext: viewContext))
        
        // Initialize the FetchRequest with the location predicate
        _posts = FetchRequest(
            entity: ForumPost.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \ForumPost.createdAt, ascending: false)],
            predicate: NSPredicate(format: "location == %@", selectedLocation.rawValue)
        )
    }
    
    var body: some View {
        ZStack {
            List {
                if posts.isEmpty {
                    Text("\(selectedLocation.displayName) 未有Post")
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                ForEach(posts) { post in
                    NavigationLink {
                        ForumPostView(post: post, viewModel: viewModel)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(post.title ?? "")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                // Match status indicator
                                Text(post.isMatched ? "Matched" : "Still looking")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(post.isMatched ? Color.green : Color.orange)
                                    .cornerRadius(8)
                            }
                            
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.blue)
                                Text(post.authorName ?? "Unknown")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                if let date = post.createdAt {
                                    Text(date, style: .relative)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        viewModel.deletePost(posts[index])
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(selectedLocation.displayName)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreatePost = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView(viewModel: viewModel, preselectedLocation: selectedLocation)
            }
        }
        .withDefaultBackground()
    }
}

#Preview {
    NavigationView {
        LocationSelectionView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

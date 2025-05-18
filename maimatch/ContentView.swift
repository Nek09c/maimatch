//
//  ContentView.swift
//  maimatch
//
//  Created by carlson chuang on 10/5/2025.
//

import SwiftUI
import CoreData
import FirebaseFirestore

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ForumViewModel
    @State private var showingCreatePost = false
    @State private var statusFilter: StatusFilter = .all
    @State private var difficultyFilter: Level? = nil
    @State private var showingDifficultyPicker = false
    @State private var refreshing = false
    let selectedLocation: ArcadeLocation
    
    // Store cloud listener
    @State private var cloudListener: FirebaseFirestore.ListenerRegistration?
    
    @FetchRequest var posts: FetchedResults<ForumPost>
    
    enum StatusFilter: String, CaseIterable, Identifiable {
        case all = "全部"
        case matched = "已配對"
        case looking = "尋找中"
        
        var id: String { self.rawValue }
        
        var predicate: NSPredicate? {
            switch self {
            case .all:
                return nil
            case .matched:
                return NSPredicate(format: "isMatched == %@", NSNumber(value: true))
            case .looking:
                return NSPredicate(format: "isMatched == %@", NSNumber(value: false))
            }
        }
    }
    
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
    
    var filteredPosts: [ForumPost] {
        var filteredResults = Array(posts)
        
        // Apply status filter if not 'all'
        if let statusPredicate = statusFilter.predicate {
            filteredResults = filteredResults.filter { post in
                statusPredicate.evaluate(with: post)
            }
        }
        
        // Apply difficulty filter if selected
        if let difficulty = difficultyFilter {
            filteredResults = filteredResults.filter { post in
                post.selectedLevels.contains(difficulty)
            }
        }
        
        return filteredResults
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Status filter selector
                Picker("狀態篩選", selection: $statusFilter) {
                    ForEach(StatusFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)
                
                // Difficulty filter
                HStack {
                    Text("難度篩選:")
                        .font(.subheadline)
                    
                    if let selectedDifficulty = difficultyFilter {
                        HStack {
                            Text(selectedDifficulty.displayName)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(selectedDifficulty.color))
                                .cornerRadius(8)
                            
                            Button(action: {
                                difficultyFilter = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        Text("全部")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingDifficultyPicker = true
                    }) {
                        Text("選擇")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                List {
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                    } else if filteredPosts.isEmpty {
                        Text("\(selectedLocation.displayName) \(statusFilter == .all ? "未有Post" : "未有\(statusFilter.rawValue)的Post")")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                    
                    ForEach(filteredPosts) { post in
                        NavigationLink {
                            ForumPostView(post: post, viewModel: viewModel)
                        } label: {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(post.title ?? "")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    // Match status indicator
                                    Text(post.isMatched ? "已配對" : "尋找中")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(post.isMatched ? Color.green : Color.orange)
                                        .cornerRadius(8)
                                }
                                
                                // Display difficulty levels
                                if !post.selectedLevels.isEmpty {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 6) {
                                            Text("難度:")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            
                                            ForEach(post.selectedLevels) { level in
                                                Text(level.displayName)
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(Color(level.color))
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }
                                }
                                
                                // Display genres if available
                                if !post.genresList.isEmpty {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 6) {
                                            Text("分類:")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            
                                            ForEach(post.genresList, id: \.self) { genre in
                                                Text(genre.displayName)
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(Color.purple)
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }
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
                        // Map filtered indices to actual posts indices
                        let postsToDelete = indexSet.map { filteredPosts[$0] }
                        postsToDelete.forEach { post in
                            viewModel.deletePost(post)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .refreshable {
                    refreshing = true
                    viewModel.loadPosts(for: selectedLocation)
                    refreshing = false
                }
                
                // Error message display
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
            }
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
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        refreshing = true
                        viewModel.loadPosts(for: selectedLocation)
                        refreshing = false
                    } label: {
                        if refreshing || viewModel.isLoading {
                            ProgressView()
                                .scaleEffect(0.7)
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView(viewModel: viewModel, preselectedLocation: selectedLocation)
            }
            .sheet(isPresented: $showingDifficultyPicker) {
                NavigationView {
                    List {
                        Button(action: {
                            difficultyFilter = nil
                            showingDifficultyPicker = false
                        }) {
                            HStack {
                                Text("全部")
                                Spacer()
                                if difficultyFilter == nil {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                        
                        ForEach(Level.allCases) { level in
                            Button(action: {
                                difficultyFilter = level
                                showingDifficultyPicker = false
                            }) {
                                HStack {
                                    Text(level.displayName)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(level.color))
                                        .cornerRadius(8)
                                    
                                    Spacer()
                                    
                                    if difficultyFilter == level {
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
                            Button("取消") {
                                showingDifficultyPicker = false
                            }
                        }
                    }
                }
            }
        }
        .withDefaultBackground()
        .onAppear {
            // Load initial data from cloud
            viewModel.loadPosts(for: selectedLocation)
            
            // Setup real-time updates
            cloudListener = viewModel.setupRealtimeUpdates(for: selectedLocation)
        }
    }
}

#Preview {
    NavigationView {
        LocationSelectionView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

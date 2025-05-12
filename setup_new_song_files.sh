#!/bin/bash

# Move to project directory
cd /Users/carlsonc09/Code/maimatch

# Backup original files
echo "Creating backups of original files..."
mkdir -p backups
cp maimatch/Song.swift backups/Song.swift.bak
cp maimatch/SongDatabase.swift backups/SongDatabase.swift.bak
cp maimatch/SongSelectionView.swift backups/SongSelectionView.swift.bak
cp maimatch/ForumPost+Extension.swift backups/ForumPost+Extension.swift.bak
cp maimatch/ForumViewModel.swift backups/ForumViewModel.swift.bak
cp maimatch/ForumPostView.swift backups/ForumPostView.swift.bak
cp maimatch/CreatePostView.swift backups/CreatePostView.swift.bak
cp maimatch/Persistence.swift backups/Persistence.swift.bak

# Copy new files with different names
echo "Copying new files to project..."
cp new_files/SongModel.swift maimatch/SongModel.swift
cp new_files/SongDatabaseService.swift maimatch/SongDatabaseService.swift
cp new_files/SongSelectionUI.swift maimatch/SongSelectionUI.swift
cp new_files/ForumPost+Extension.swift maimatch/ForumPost+Extension.swift
cp new_files/ForumViewModel.swift maimatch/ForumViewModel.swift
cp new_files/ForumPostView.swift maimatch/ForumPostView.swift
cp new_files/CreatePostView.swift maimatch/CreatePostView.swift
cp new_files/Persistence.swift maimatch/Persistence.swift

# Delete original files to avoid conflicts
echo "Removing original files..."
rm -f maimatch/Song.swift
rm -f maimatch/SongDatabase.swift
rm -f maimatch/SongSelectionView.swift

echo "Done. Now open the project in Xcode and add the new files to the project."
echo "Use File > Add Files to 'maimatch'... to add the new files." 
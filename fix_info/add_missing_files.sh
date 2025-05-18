#!/bin/bash

# Add missing files to Xcode project
PROJECT_FILE="maimatch.xcodeproj/project.pbxproj"

# Backup the project file
cp "$PROJECT_FILE" "${PROJECT_FILE}.files.bak"

echo "Adding missing files to Xcode project..."
echo "Note: This is a basic script and may not work perfectly."
echo "It's recommended to add the files directly in Xcode."

# Find the PBXGroup section for the main source files
GROUP_ID=$(grep -A 3 "/* maimatch */ =" "$PROJECT_FILE" | grep "isa = PBXGroup" -B 1 | head -1 | awk '{print $1}')

echo "Found main group ID: $GROUP_ID"

# Find the PBXSourcesBuildPhase section
SOURCES_ID=$(grep -A 3 "isa = PBXSourcesBuildPhase;" "$PROJECT_FILE" | head -1 | awk '{print $1}')

echo "Found sources build phase ID: $SOURCES_ID"

# Generate a unique file ID for each file
SONG_ID="FA$(openssl rand -hex 10 | tr '[:lower:]' '[:upper:]')"
SONGDB_ID="FB$(openssl rand -hex 10 | tr '[:lower:]' '[:upper:]')"
SONGVIEW_ID="FC$(openssl rand -hex 10 | tr '[:lower:]' '[:upper:]')"

# Add file references to PBXGroup section
sed -i '' "/$GROUP_ID =/,/children = (/s/children = (/children = (\n\t\t\t\t$SONG_ID /* Song.swift */,\n\t\t\t\t$SONGDB_ID /* SongDatabase.swift */,\n\t\t\t\t$SONGVIEW_ID /* SongSelectionView.swift */,/" "$PROJECT_FILE"

# Add file references to PBXFileReference section
sed -i '' "//* Build configuration list for PBXProject/i\\
\t\t$SONG_ID /* Song.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = Song.swift; sourceTree = \"<group>\"; };\\
\t\t$SONGDB_ID /* SongDatabase.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = SongDatabase.swift; sourceTree = \"<group>\"; };\\
\t\t$SONGVIEW_ID /* SongSelectionView.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = SongSelectionView.swift; sourceTree = \"<group>\"; };\\
" "$PROJECT_FILE"

# Add file build references to PBXSourcesBuildPhase section
sed -i '' "/$SOURCES_ID/,/files = (/s/files = (/files = (\n\t\t\t\t$SONG_ID /* Song.swift in Sources */,\n\t\t\t\t$SONGDB_ID /* SongDatabase.swift in Sources */,\n\t\t\t\t$SONGVIEW_ID /* SongSelectionView.swift in Sources */,/" "$PROJECT_FILE"

echo "Script completed. Please restart Xcode and try building again."
echo "If you encounter issues, restore from the backup: ${PROJECT_FILE}.files.bak" 
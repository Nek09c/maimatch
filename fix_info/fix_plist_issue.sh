#!/bin/bash

# Fix Info.plist conflict in Xcode project
PROJECT_FILE="maimatch.xcodeproj/project.pbxproj"

# Create backup
cp "$PROJECT_FILE" "${PROJECT_FILE}.bak"

# Remove GENERATE_INFOPLIST_FILE setting
sed -i '' 's/GENERATE_INFOPLIST_FILE = YES;/GENERATE_INFOPLIST_FILE = NO;/g' "$PROJECT_FILE"

echo "Project file updated. Original file backed up as ${PROJECT_FILE}.bak"
echo "Please clean the build folder in Xcode and try building again." 
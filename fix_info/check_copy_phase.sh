#!/bin/bash

# Check if Info.plist is being copied in a Copy Files build phase
PROJECT_FILE="maimatch.xcodeproj/project.pbxproj"

echo "Checking for Info.plist in copy files build phases..."
plutil -p "$PROJECT_FILE" | grep -i -A 10 "copyFilesBuildPhase" | grep -i "Info.plist"

echo "Checking for potential conflicts in build settings..."
plutil -p "$PROJECT_FILE" | grep -i "info.plist"

echo "Done. If any matches were found above, they may be causing conflicts." 
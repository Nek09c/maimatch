# MaiMatch

MaiMatch is a SwiftUI forum app for arcade game enthusiasts in Hong Kong, focused on the popular rhythm game "maimai".

## Features

- **Location-based Posts**: View and create posts for specific arcade locations in Hong Kong
- **Genre Selection**: Choose your favorite music genres (Pop & Anime, Niconico & Vocaloid, etc.)
- **Song Selection**: Browse and select songs from the maimai arcade game
- **Community Interaction**: Share your maimai experiences with other players

## Available Arcade Locations

- 鑽石山 (Diamond Hill)
- 旺角新之城 (Mongkok New Century)
- 旺角 Smart Games
- 荃金 (Tsuen Wan Gold)
- 大埔李福林 (Tai Po Lee Fuk Lam)
- 油麻地金星 (Yau Ma Tei Golden Star)
- 旺角金雞 (Mongkok Golden Chicken)
- 灣仔金星 (Wan Chai Golden Star)

## Song Database

The song database includes tracks from the maimai arcade game, categorized as:

- Pop & Anime
- Niconico & Vocaloid
- Touhou Project
- Game & Variety
- Maimai Original
- Ongeki & Chunithm
- Party Room (宴会場)

Song data is sourced from public repositories like [CrazyKidCN/maimaiDX-CN-songs-database](https://github.com/CrazyKidCN/maimaiDX-CN-songs-database) and [zetaraku/arcade-songs](https://github.com/zetaraku/arcade-songs).

## Technical Implementation

- Built with SwiftUI and CoreData
- Uses MVVM architecture
- Firebase Firestore for cloud storage
- Custom song selection interface
- Location-based post filtering
- Device ID-based authentication system

## Setup Instructions

### Prerequisites

- Xcode 14.0 or later
- iOS 16.0 or later
- Swift 5.7 or later
- CocoaPods (if using)

### Firebase Setup

This app uses Firebase for cloud storage. Since the Firebase configuration file contains API keys, it is not included in this repository. To set up Firebase:

1. Create a Firebase project at [firebase.google.com](https://firebase.google.com)
2. Add an iOS app to your Firebase project
   - Use `com.autismoC09.maimatch` as the Bundle ID or update the Bundle ID in the project to match yours
3. Download the `GoogleService-Info.plist` file
4. Add the file to your Xcode project by dragging it into the `maimatch` directory
5. Make sure the file is added to the main target

### Firestore Database Rules

Set up your Firestore database with these security rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow anyone to read and write the posts collection
    match /posts/{document=**} {
      allow read: if true;  // Anyone can read posts
      allow write: if true; // Anyone can write posts (since we're using device IDs for auth)
    }

    // Allow anyone to read and write the debug_tests collection (for testing)
    match /_test/{document=**} {
      allow read, write: if true;
    }

    match /debug_tests/{document=**} {
      allow read, write: if true;
    }
  }
}
```

## Running the App

1. Open `maimatch.xcodeproj` in Xcode
2. Ensure you've added the `GoogleService-Info.plist` file as described above
3. Select your target device or simulator
4. Build and run the app (⌘R)

## Privacy

MaiMatch respects user privacy and stores data locally on your device. The app uses device IDs for post ownership tracking but does not collect personal information.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is available as open source under the terms of the MIT License.

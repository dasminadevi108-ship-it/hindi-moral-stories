# Hindi Moral Stories - Mobile App

A mobile application featuring animated moral stories in Hindi to entertain and educate users with meaningful content.

## Features

- 📚 Collection of traditional Hindi moral stories
- 🎬 Animated video stories in Hindi
- 🎨 Beautiful UI with smooth animations
- 🔖 Bookmarking favorite stories
- ⭐ Rating and review system
- 🌙 Dark mode support
- 📱 Responsive design for all devices
- 🔍 Search and filter stories
- 👨‍👧‍👦 Family-friendly content

## Technology Stack

- **Framework**: Flutter (for cross-platform development)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **State Management**: Provider
- **Video Player**: video_player
- **UI**: Material Design 3

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Android Studio or Xcode
- Firebase account

### Installation

1. Clone the repository
```bash
git clone https://github.com/dasminadevi108-ship-it/hindi-moral-stories.git
cd hindi-moral-stories
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
```bash
flutterfire configure
```

4. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── story_model.dart        # Story data model
├── screens/
│   ├── home_screen.dart        # Home screen
│   └── story_detail_screen.dart # Story detail view
├── widgets/
│   ├── story_card.dart         # Story card widget
│   └── category_chip.dart      # Category filter chip
├── providers/
│   ├── story_provider.dart     # Story state management
│   └── theme_provider.dart     # Theme state management
├── services/
│   └── story_service.dart      # Firebase operations
├── utils/
│   └── app_theme.dart          # App theme configuration
└── firebase_options.dart       # Firebase configuration
```

## Stories Included

- The Lion and the Mouse (शेर और चूहा)
- The Crow and the Pitcher (कौआ और घड़ा)
- The Tortoise and the Hare (कछुआ और खरगोश)
- And many more...

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
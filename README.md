# Insta Feed Clone

A highly polished, visually identical replication of the Instagram Home Feed built in Flutter. This answers the requirement of replicating Instagram with high visual fidelity, smooth interactions, and a clean architecture.

## 📱 Features Implemented

- **Pixel-Perfect Mirror Test**: Top navigation bar with custom typography (`Grand Hotel` font), Story tray, and post feed matching colors, spacing, and icon sizes.
- **Advanced Media Handling**: 
  - Posts with multiple images smoothly scroll horizontally with a synchronized dotted indicator.
  - High-quality public images are utilized from Unsplash. Memory is handled efficiently using `cached_network_image`.
- **Pinch-to-Zoom**: Includes a custom `PinchZoomOverlay` widget allowing seamless pan/zoom over the UI on images, snapping back perfectly when released.
- **Stateful Interactions**: 'Like' and 'Save' bookmark icons toggle locally in real-time. Unimplemented buttons trigger temporary Snackbars.
- **Mock Data Layer**: Built `PostRepository` to simulate a network call querying JSON data with an intentional `1.5` second delay.
- **Shimmer Loading State**: Displays a custom `ShimmerFeed` skeleton loading screen instead of simple spinners for high-perceived performance.
- **Infinite Pagination**: Uses a `ScrollController` listener to lazy load the next batch of posts seamlessly when the user gets close to the bottom.

## 🏗️ Architecture & State Management

This project uses **Provider** (`ChangeNotifierProvider`) for State Management. 
- `PostProvider`: Acts as the View-Model coordinating data fetching, holding the `List<PostModel>`, managing `_isLoading` UI flags, and exposing simple `toggleLike` acts. 
- Provider was chosen for this project because it perfectly suits the scale of a single-feature MVP. It avoids the heavy boilerplate of BLoC while remaining testable, robust, and cleanly separating the UI from the business logic.

### Folder Structure
```text
lib/
 ├── main.dart
 ├── models/
 │    └── post_model.dart       # Data class and JSON Parsing
 ├── providers/
 │    └── post_provider.dart    # State Management
 ├── screens/
 │    └── home_feed_screen.dart # Main View / Orchestrator
 ├── services/
 │    └── post_repository.dart  # Data Layer (Mocking API Logic)
 └── widgets/                   # Reusable UI component isolation
      ├── pinch_zoom_overlay.dart
      ├── post_card.dart
      ├── post_carousel.dart
      ├── shimmer_feed.dart
      └── story_tray.dart
```

## 🚀 How to Run

1. Clone the repository.
2. Run `flutter pub get` to download dependencies.
3. Start the application on iOS, Android, macOS, or Windows using `flutter run` or the Play button in your IDE.

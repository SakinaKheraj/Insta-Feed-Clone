#  Instagram Feed Clone — Flutter

A highly polished **Instagram Home Feed replica built with Flutter**, focusing on **pixel-perfect UI**, smooth gestures, and clean architecture.
The project demonstrates advanced UI handling, efficient state management, and production-style code organization.

This assignment was built to replicate the **Instagram Home Feed experience** as closely as possible, including stories, carousels, pinch-to-zoom interactions, and seamless infinite scrolling.

---

#  Demo

**Screen Recording:**
[Link
](https://drive.google.com/file/d/1m7AmEOrHY-J4QDNUvkfYgTZ2RZsPImzv/view?usp=drive_link)

The demo showcases:

* Shimmer loading state
* Smooth infinite scrolling
* Pinch-to-zoom interaction
* Like / Save toggle interactions

---

#  Features

## Pixel-Perfect Feed UI

* Replicates the Instagram Home Feed layout including:

  * Top navigation bar
  * Stories tray
  * Scrollable post feed
* Accurate spacing, icon sizing, and typography using the **Grand Hotel font**.

---

## Advanced Media Handling

### Carousel Posts

* Multiple images per post.
* Smooth horizontal swiping using `PageView`.
* **Synchronized dot indicator** to show current image.

### Network Image Optimization

* Images are fetched from **public Unsplash URLs**.
* Efficient caching and memory handling using:

```
cached_network_image
```

---

## Pinch-to-Zoom Interaction

A custom `PinchZoomOverlay` widget enables:

* Natural pinch-to-zoom gestures
* Panning while zoomed
* Smooth animation returning to original position when released

This interaction closely mimics Instagram’s behavior.

---

## Stateful Post Interactions

The following actions update **locally in real-time**:

*  Like toggle
*  Save bookmark toggle

Unimplemented buttons (Share / Comment) trigger a **temporary Snackbar**.

---

## Mock Data Layer

A **Repository Pattern** is implemented through:

```
PostRepository
```

Responsibilities:

* Simulate fetching JSON data
* Artificial **1.5 second latency**
* Provide paginated post data

This demonstrates real-world asynchronous data loading.

---

## Shimmer Loading State

Instead of traditional loading spinners, a **skeleton shimmer UI** is displayed while data loads.

Benefits:

* Higher perceived performance
* Better UX during simulated network delay

Implemented using:

```
shimmer
```

---

## Infinite Scroll Pagination

Feed implements **lazy loading** using `ScrollController`.

Behavior:

* When the user approaches the bottom of the feed
* The next batch of posts loads automatically
* New content is appended smoothly without interrupting scrolling

---

#  Architecture

The project follows a **clean and modular architecture**, separating UI, business logic, and data access.

Key principles:

* Separation of concerns
* Reusable UI components
* Maintainable folder structure
* Minimal boilerplate

---

#  State Management

State management is implemented using **Provider (`ChangeNotifierProvider`)**.

### PostProvider

Responsibilities:

* Fetch posts from `PostRepository`
* Maintain the feed state (`List<PostModel>`)
* Handle loading flags
* Manage post interactions (like/save)
* Notify UI when state changes

### Why Provider?

Provider was selected because:

* Lightweight and easy to maintain
* Minimal boilerplate compared to BLoC
* Perfect for **small to medium feature modules**
* Clean separation between UI and logic

---

#  Folder Structure

```
lib/
 ├── main.dart
 ├── models/
 │    └── post_model.dart
 │
 ├── providers/
 │    └── post_provider.dart
 │
 ├── screens/
 │    └── home_feed_screen.dart
 │
 ├── services/
 │    └── post_repository.dart
 │
 └── widgets/
      ├── pinch_zoom_overlay.dart
      ├── post_card.dart
      ├── post_carousel.dart
      ├── shimmer_feed.dart
      └── story_tray.dart
```

This structure ensures:

* **Clear responsibility per module**
* Easy scalability
* Better readability for collaborators

---

#  Packages Used

```
provider
cached_network_image
shimmer
smooth_page_indicator
google_fonts
```

---

#  How to Run

### Clone the repository.

```
git clone <your-repository-link>
```

###  Navigate into the project

```
cd insta-feed-clone
```

###  Install dependencies

```
flutter pub get
```

###  Run the project

```
flutter run
```

Run on:

* Android Emulator
* iOS Simulator
* Physical Device

---

#  Edge Case Handling

The application gracefully handles:

* Network image loading failures
* Loading states
* Pagination triggers
* Empty data scenarios

Fallback UI ensures the feed remains stable.

---

#  Focus Areas for Evaluation

This implementation prioritizes:

* **Visual fidelity**
* **Smooth gesture interactions**
* **Jank-free scrolling**
* **Clean architecture**
* **Efficient network image caching**

Quality and polish were prioritized over adding multiple screens.

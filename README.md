# YouTube Clone - Flutter Application

## Overview

This is a YouTube Clone application built using **Flutter** and **Dart**. It demonstrates a robust, scalable architecture and implements core features of a video streaming platform, including authentication, video browsing, playback, search, and downloads.

## Architecture

The project follows **Clean Architecture** principles combined with the **BLoC (Business Logic Component)** pattern for state management. This ensures a separation of concerns, testability, and maintainability.

### Layers

1.  **Presentation Layer (`lib/presentation`)**:
    -   Contains UI components (Pages, Widgets).
    -   Manages state using **BLoC** / **Cubit**.
    -   Reacts to user input and renders data from the Domain layer.

2.  **Domain Layer (`lib/domain`)**:
    -   Contains **Business Logic** and **Entities**.
    -   Defines **Use Cases** (e.g., `LoginUser`, `FetchVideos`) that encapsulate specific business rules.
    -   Defines **Repository Interfaces** (Contracts) that the Data layer must implement.
    -   *Pure Dart code, no Flutter dependencies (mostly).*

3.  **Data Layer (`lib/data`)**:
    -   Implements Repository interfaces defined in the Domain layer.
    -   **Data Sources**:
        -   **Remote**: API calls (Dio), Firebase Authentication.
        -   **Local**: Local database (Hive), Secure Storage.
    -   **Models**: Data transfer objects (DTOs) that parse JSON and map to Domain Entities.

4.  **Core (`lib/core`)**:
    -   Contains shared utilities, constants, dependency injection setup (`GetIt`), networking clients (`DioClient`), and themes.

## Tech Stack & Services

-   **Framework**: Flutter & Dart
-   **State Management**: `flutter_bloc`
-   **Dependency Injection**: `get_it`, `injectable` concepts
-   **Routing**: `go_router`
-   **Networking**: `dio` (with interceptors for logging and error handling)
-   **Backend / Services**:
    -   **Firebase Auth**: For Email/Password, Phone (OTP), and Google Sign-In.
    -   **Pexels API**: Used as the video content source (mocking YouTube's backend).
-   **Local Storage**:
    -   `hive`: For search history and lightweight data.
    -   `flutter_secure_storage`: For storing sensitive tokens/keys.
-   **Video Player**: `better_player_plus` (Customized with overlay controls).
-   **Utilities**: `equatable`, `timeago`, `cached_network_image`.

## Folder Structure

```
lib/
├── core/                   # Core utilities and configuration
│   ├── di/                 # Dependency Injection (Service Locator)
│   ├── network/            # Dio client and connectivity
│   ├── theme/              # App themes and styles
│   └── utils/              # Constants, helpers
├── data/                   # Data layer implementation
│   ├── datasources/        # Remote and Local data sources
│   ├── models/             # JSON parsing models
│   └── repositories/       # Repository implementations
├── domain/                 # Business logic and entities
│   ├── entities/           # Core business objects
│   ├── repositories/       # Abstract repository interfaces
│   └── usecases/           # specific business actions
├── presentation/           # UI and State Management
│   ├── auth/               # Authentication screens & BLoC
│   ├── home/               # Home feed & BLoC
│   ├── player/             # Video player & BLoC
│   ├── search/             # Search functionality & BLoC
│   ├── downloads/          # Downloads screen
│   └── navigation/         # App Routing (GoRouter)
└── main.dart               # Entry point
```

## Setup & specific Prerequisites

1.  **Flutter SDK**: Ensure you have a stable version of Flutter installed.
2.  **Firebase Configuration**:
    -   This project uses Firebase. You must have a `google-services.json` file in `android/app/` for Android and `GoogleService-Info.plist` for iOS.
    -   **Note**: Phone Auth and Google Sign-In require SHA-1 and SHA-256 keys to be added to your Firebase Console project settings.
3.  **API Keys**:
    -   The app uses the **Pexels API** for video data. The API key is stored in `lib/core/utils/app_constants.dart`.

## How to Run

1.  **Get Dependencies**:
    ```bash
    flutter pub get
    ```

2.  **Run the App**:
    -   Select your device (Emulator or Physical).
    -   Run the command:
    ```bash
    flutter run
    ```

## Key Features

-   **Authentication**:
    -   Sign Up / Login with Email & Password.
    -   Phone Number Login with OTP Verification.
    -   Google Sign-In.
-   **Home Feed**:
    -   Infinite scrolling list of popular videos.
    -   Pull-to-refresh functionality.
-   **Video Player**:
    -   Custom controls (Play/Pause, Seek, Fullscreen).
    -   Gesture controls (Double-tap to seek, swipe for volume/brightness).
    -   Orientation handling (Landscape/Portrait).
-   **Search**:
    -   Search for videos with history tracking (saved locally).
    -   Debounced search queries.
-   **Downloads**:
    -   (UI implementation) Section for managing offline content.
-   **Theme**:
    -   Light and Dark mode support.

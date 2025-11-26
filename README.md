# Villain Arc - The Ultimate Fitness Tracker

> "You either die a hero, or you live long enough to see yourself become the villain."

## 🦸‍♂️ Introduction: Enter Your Villain Arc

Welcome to **Villain Arc**, the fitness tracker designed for those who are ready to stop making excuses and start making progress. We all know the feeling—the world is against you, the odds are stacked, and the only way out is *through*. This app isn't just about logging reps; it's about documenting your transformation.

Whether you're training for revenge, redemption, or just to be the best version of yourself, Villain Arc provides the tools you need to crush your goals. We've stripped away the clutter and focused on what matters: **Health**, **Workouts**, and **Nutrition**. It's time to embrace the grind. It's time for your Villain Arc.

---

## 🚀 Features

-   **Health Dashboard**: Keep a pulse on your vital stats.
-   **Workout Tracking**: Log your exercises, sets, and reps with precision.
-   **Nutrition Logging**: Fuel your body right and track your macros.
-   **Dark Mode UI**: Sleek, focused design that looks great in the gym or at night.
-   **Secure Authentication**: Your data is yours, protected by Firebase Auth.

---

## 🛠️ Under the Hood: A Step-by-Step Explanation

Villain Arc is built using the latest iOS technologies to ensure a smooth and reliable experience. Here's how it works:

### 1. Authentication (Firebase)
The journey begins with security. We use **Firebase Authentication** to manage user accounts.
-   When you launch the app, `Villain_ArcApp.swift` initializes Firebase.
-   The `ContentView` checks the `@AppStorage("userLoggedIn")` state.
-   If you're not logged in, you're greeted by the `WelcomeView`. Once authenticated, the main app interface unlocks.

### 2. Navigation Structure
The app uses a `TabView` architecture in `ContentView.swift` to separate the three main pillars of fitness:
-   **HealthTab**: For monitoring overall wellness.
-   **WorkoutTab**: The core of the app where the grinding happens.
-   **NutritionTab**: For tracking your intake.
This structure ensures that every feature is just one tap away, keeping navigation intuitive and fast.

### 3. Data Persistence (SwiftData)
We use **SwiftData** to store your hard-earned progress locally on your device.
-   **Models**: We have defined robust models like `User`, `Workout`, `WorkoutExercise`, and `ExerciseSet`.
-   **Container**: The `modelContainer` is injected at the root level in `Villain_ArcApp.swift`, ensuring that your data is available across all views.
-   **Real-time Updates**: Thanks to SwiftUI's `@Query` macro (used within the tabs), any new workout or meal you log is instantly reflected in the UI.

### 4. User Interface (SwiftUI)
The entire app is built with **SwiftUI**, Apple's modern declarative framework.
-   We utilize composable views to keep the code clean and modular.
-   The UI is designed to be responsive and accessible, adapting to different device sizes.
-   Custom assets and system images (SF Symbols) are used to create a visually appealing aesthetic.

---

## 🎥 Video Demonstration

See Villain Arc in action. This video walks you through creating an account, logging a workout, and checking your stats.

<!-- 
    TODO: Replace the src attribute below with your actual video URL. 
    You can use a YouTube link, a link to a video file in your repo, or an embedded MP4.
-->

<div align="center">
  <video src="https://user-images.githubusercontent.com/placeholder-video.mp4" controls="controls" style="max-width: 100%;">
    Your browser does not support the video tag.
  </video>
  <br>
  <em>(Click to play audio explanation)</em>
</div>

> **Note**: If the video above doesn't play, you can [watch the demo here](https://your-video-link.com).

---

## 💻 Tech Stack

-   **Language**: Swift 5
-   **Framework**: SwiftUI
-   **Backend/Auth**: Firebase
-   **Database**: SwiftData
-   **Platform**: iOS 17+

---

## 🏃‍♂️ Getting Started

1.  Clone the repository.
2.  Open `Villain-Arc.xcodeproj` in Xcode.
3.  Ensure you have the necessary Firebase configuration (`GoogleService-Info.plist`) in the project root.
4.  Build and run on your simulator or device.

---

*Built by Fernando Caudillo Tafoya*

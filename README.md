# Zyphastio 🌙

**Zyphastio** is a modern, privacy-focused Intermittent Fasting tracker built with Flutter. It is designed to help you easily manage your fasting schedules, track your progress, and visualize your health journey with a sleek, dark-themed interface.

## 🚀 Features

### ⏱️ Fasting Timer
*   **Visual Tracker**: Beautiful circular progress timer showing elapsed and remaining time.
*   **Live Status**: "Ready to Fast" vs "Fasting" states with dynamic updates.
*   **Flexible Protocols**: Built-in presets for popular fasting methods:
    *   **16:8** (Lean Gains)
    *   **18:6** (Intermediate)
    *   **20:4** (Warrior)
    *   **OMAD** (One Meal A Day)
    *   **ADF** (Alternate Day Fasting)
    *   **Custom**: Set your own duration (1-72 hours).
*   **Adjustable Start Time**: Forgot to start the timer? Manually adjust start times for active fasts.

### 📊 Statistics & Insights
*   **Weekly Analysis**: Interactive bar charts (using `fl_chart`) to visualize your fasting hours over the week.
*   **Streak Tracking**: Robust streak calculation (with 1-day grace period) to keep you motivated.
*   **History Log**: Comprehensive list of all past fasting sessions.
*   **Personal Bests**: Automatically tracks your longest fast and current streak.

### 🔔 Smart Notifications
*   **Completion Alerts**: Get notified exactly when your fast ends.
*   **Ongoing Status**: Optional persistent notification to keep your progress visible in the shade.
*   **Customizable**: Toggle specific notification types in Settings.

### 🛠️ Technical Highlights
*   **Offline First**: All data is stored locally on your device using **Isar Database** for blazing speed and privacy.
*   **Dark Mode**: Enforced premium dark theme for battery saving and eye comfort.
*   **State Management**: Powered by **Riverpod 2.x** with code generation for type-safe, reactive state.
*   **Navigation**: Declarative routing with **GoRouter**. The app preserves tab state (Timer, Stats, Profile) seamlessly.

---

## 🛠️ Technology Stack

*   **framework**: [Flutter](https://flutter.dev) (Dart)
*   **State Management**: [Riverpod](https://riverpod.dev)
*   **Database**: [Isar](https://isar.dev)
*   **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
*   **Charts**: [fl_chart](https://pub.dev/packages/fl_chart)
*   **Notifications**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
*   **Date formatting**: [intl](https://pub.dev/packages/intl)

---

## 📸 Screenshots

<div align="center" style="display: flex; gap: 10px; flex-wrap: wrap; justify-content: center;">
  <img src="assets/screenshots/1.jpeg" width="220" alt="Screenshot 1" />
  <img src="assets/screenshots/2.jpeg" width="220" alt="Screenshot 2" />
  <img src="assets/screenshots/3.jpeg" width="220" alt="Screenshot 3" />
  <img src="assets/screenshots/4.jpeg" width="220" alt="Screenshot 4" />
</div>

---

## 🏁 Getting Started

### Prerequisites
*   Flutter SDK (3.10.0 or higher)
*   Dart SDK (3.0.0 or higher)

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/zyphastio.git
    cd zyphastio
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run code generation** (required for Riverpod & Isar):
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app**:
    ```bash
    flutter run
    ```

## 📱 Building for Production

To build an APK for Android release:

```bash
flutter build apk --release
```

To build an App Bundle (for Play Store):

```bash
flutter build appbundle --release
```

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

Made with ❤️ by the Zyphastio Team.

# 🚀 Zyphastio Publishing Guide

This guide covers how to publish your app to **GitHub Releases** (for direct downloads) and submit it to **F-Droid** (for the app store).

---

## ✅ Prerequisites

1.  **Version Check**: Open `pubspec.yaml` and ensure your version is correct.
    ```yaml
    version: 1.0.0+1  # Update this for every new release (e.g., 1.0.1+2)
    ```
2.  **Clean Build**: Ensure your project builds cleanly.
    ```bash
    flutter clean
    flutter pub get
    dart run build_runner build --delete-conflicting-outputs
    ```

---

## 📦 Part 1: GitHub Releases (Direct APK)

This allows users to download the `.apk` file directly from your repository.

### Step 1: Build the Release APK
Run the following command in your terminal:
```bash
flutter build apk --release
```
*   This creates the file: `build/app/outputs/flutter-apk/app-release.apk`
*   **Note**: This APK is signed with the default debug key or your release key if configured. For F-Droid, this doesn't matter (they build their own), but for direct downloads, a proper keystore is recommended to avoid "Unsafe App" warnings.

### Step 2: Tag the Release
Tag your current code version in git:
```bash
git tag v1.0.0
git push origin v1.0.0
```

### Step 3: Create Release on GitHub
1.  Go to your repo: [https://github.com/BloodBlinker/Zyphastio](https://github.com/BloodBlinker/Zyphastio)
2.  Click **Releases** (on the right sidebar) -> **Draft a new release**.
3.  Choose the tag `v1.0.0`.
4.  Title: `Zyphastio v1.0.0`.
5.  Description: Paste your changelog or features list.
6.  **Attach binaries**: Drag and drop the `build/app/outputs/flutter-apk/app-release.apk` file into the upload box.
7.  Click **Publish release**.

---

## 🤖 Part 2: F-Droid Submission

F-Droid is strict. They build the app **from your source code** on their servers. They do *not* accept uploaded APKs.

### Step 1: Verify F-Droid Compliance
*   **No Analytics**: Ensure you aren't using Firebase Analytics or similar proprietary trackers (Zyphastio is clean).
*   **Open Source**: Project must use an OSI-approved license (Apache 2.0, MIT, etc.).

### Step 2: Fork `fdroiddata`
1.  Go to [https://gitlab.com/fdroid/fdroiddata](https://gitlab.com/fdroid/fdroiddata).
2.  **Fork** the repository to your own GitLab account (you need a GitLab account).

### Step 3: Create Metadata File
In your forked `fdroiddata` repo, create a new file: `metadata/com.example.zyphastio.yml` (Use your *actual* package ID from `android/app/build.gradle`: `applicationId`).

**Example Metadata (`metadata/com.example.zyphastio.yml`):**
```yaml
Categories:
  - Health & Fitness
License: MIT
SourceCode: https://github.com/BloodBlinker/Zyphastio
IssueTracker: https://github.com/BloodBlinker/Zyphastio/issues

AutoName: Zyphastio
Summary: Modern Intermittent Fasting Tracker
Description: |
    Zyphastio is a privacy-focused Intermittent Fasting tracker.
    Features:
    * Multiple protocols (16:8, OMAD, etc.)
    * Statistics and Streak tracking
    * Dark Mode interface
    * Local-only database (Isar)

RepoType: git
Repo: https://github.com/BloodBlinker/Zyphastio.git

Builds:
  - versionName: 1.0.0
    versionCode: 1
    commit: v1.0.0
    subdir: .
    flutter: yes
    gradle: yes
    output: build/app/outputs/flutter-apk/app-release.apk
    srclibs:
      - Flutter artifact signatures
    scandelete:
      - .idea
      - .git
```

*Note: Submitting Flutter apps to F-Droid can sometimes require specific build recipes depending on how F-Droid handles dependencies at that moment. Check [F-Droid's Flutter Guide](https://f-droid.org/docs/Build_Metadata_Reference/#flutter) for the latest syntax.*

### Step 4: Submit Merge Request
1.  Commit your new metadata file to your forked `fdroiddata`.
2.  Open a **Merge Request** (MR) from your fork to the main `fdroid/fdroiddata` repository.
3.  The F-Droid bot will run checks. If it fails, follow the bot's instructions to fix the YAML.

---

## 🔑 Signing (Optional but Recommended)

For the GitHub APK to be updateable by users without uninstalling, you should sign it with a Keystore.

1.  **Create Keystore**:
    ```bash
    keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
    ```
2.  **Configure Android**:
    Create `android/key.properties` and reference it in `android/app/build.gradle`.
    *(Ask me if you need help setting this up!)*

For now, the default debug/release key works for testing, but users will see "Unsafe App" simply because it's not from the Play Store.

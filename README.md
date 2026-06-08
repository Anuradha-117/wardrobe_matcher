# ClosetLens (Repository: wardrobe_matcher)

**ClosetLens** is a Flutter-based Augmented Reality (AR) application that allows users to test out clothing virtually. By uploading a transparent cutout of a clothing item, users can overlay it onto a live camera feed, scale and position it perfectly, and snap a picture to save directly to their device's gallery.

*Note: This project's repository is originally named `wardrobe_matcher`, but the official application name is **ClosetLens**.*

## ✨ Features
* **AR Clothing Overlay:** Live camera feed integration to preview outfits in real-time.
* **Interactive AR Controls:** Fully supports pinch-to-zoom and panning to precisely fit the clothing item on the user.
* **Seamless Cutout Integration:** In-app guide and direct link to Remove.bg for easy background removal of clothing images.
* **One-Tap Capture:** Snap a picture of your AR setup and save it directly to your phone's native gallery for easy sharing.
* **Premium UI:** Clean, modern interface with custom branding and app icons.

## 📱 Download & Install (APK)
> **Note:** This direct installation file (.apk) is for Android devices only. Due to Apple's ecosystem restrictions, compiling the iOS equivalent (.ipa) requires building the app from source using a Mac and Xcode.
> 
You don't need to build the project from scratch to try it out! A fully optimized Android APK is available.

1. Go to the **Releases** section on the right side of this GitHub repository.
2. Download the latest `app-release.apk` file.
3. Open the file on your Android device and tap **Install** (you may need to allow installations from unknown sources in your settings).

*For developers: This APK was compiled directly from the `main` branch using the `flutter build apk --release` command.*

## 🛠️ Tech Stack & Dependencies
Built with **Flutter** and **Dart**. Key packages include:
* `camera`: For managing the device's hardware camera and live feed.
* `screenshot` & `gal`: For capturing the layered AR view and writing it to the native device storage.
* `image_picker`: For loading user cutouts from local device storage.
* `url_launcher`: For redirecting users to web-based background removal tools.
* `path_provider`: For handling temporary file storage during the capture process.

## 💻 Local Development Setup
If you want to clone and run this project locally:

1. Clone this repository: `git clone https://github.com/YourUsername/wardrobe_matcher.git`
2. Navigate to the directory: `cd wardrobe_matcher`
3. Install dependencies: `flutter pub get`
4. Connect a physical Android/iOS device (camera features do not work on standard emulators).
5. Run the app: `flutter run`

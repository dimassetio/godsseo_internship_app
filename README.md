# Godsseo

Production-ready Flutter application using Firebase, GetX, localization, and multi-platform support.

## Overview
- Role-aware navigation (Admin vs User) with `GetX` routing.
- Firebase integration: Auth, Firestore, Storage, and App Check.
- Internationalization (multiple locales) and date formatting via `intl`.
- Theming, cached images, SVG assets, image picking and compression.
- Geolocation and reverse geocoding support.

## Tech Stack
- Flutter + Dart
- GetX (state management, routing, DI)
- Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_app_check`)
- Internationalization: `intl`
- Media & UI: `cached_network_image`, `flutter_svg`, `google_fonts`, `flutter_image_compress`
- Device & permissions: `device_info_plus`, `permission_handler`, `image_picker`, `geolocator`, `geocoding`

## Requirements
- Flutter (stable channel) installed and on PATH
- A configured Firebase project (Android, iOS, Web, and/or Desktop as needed)
- Dart SDK compatible with the project (see `pubspec.yaml`)

## Setup
1. Install dependencies:
	 ```bash
	 flutter pub get
	 ```
2. Configure Firebase (recommended via FlutterFire CLI):
	 ```bash
	 dart pub global activate flutterfire_cli
	 flutterfire configure
	 ```
	 - Android: ensure `android/app/google-services.json` is present (already included in this repo).
	 - iOS: add `ios/Runner/GoogleService-Info.plist`.
	 - Web: configuration is injected by FlutterFire; verify at `web/index.html` if needed.
3. (Optional) Generate launcher icons:
	 ```bash
	 flutter pub run flutter_launcher_icons:main
	 ```

## Run
- Mobile (auto-detect device/emulator):
	```bash
	flutter run
	```
- Web (Chrome):
	```bash
	flutter run -d chrome
	```
- Desktop (enable once per platform if needed):
	```bash
	flutter config --enable-windows-desktop
	flutter run -d windows
	```

## Build
- Android APK:
	```bash
	flutter build apk --release
	```
- Android App Bundle:
	```bash
	flutter build appbundle --release
	```
- iOS (requires Xcode/macOS):
	```bash
	flutter build ios --release
	```
- Web:
	```bash
	flutter build web --release
	```
- Windows:
	```bash
	flutter build windows --release
	```

## Project Structure
```
lib/
	main.dart                       # App entrypoint, initializes Firebase and routing
	app/
		data/
			helpers/
				firebase_options.dart     # FlutterFire options
				languages.dart            # Localization setup
				themes.dart               # Material theme(s)
			models/
				user_model.dart           # User and role model
		modules/
			auth/                       # Auth flows (controllers, views)
		routes/
			app_pages.dart              # GetX routes, incl. HOME/HOME_ADMIN/AUTH
assets/
	image/                          # Raster assets
	svg/                            # SVG assets
```

## Features Highlight
- Role-based initial route: Admin users land on the admin home; others on user home; unauthenticated users go to sign-in.
- Localization: preloads date symbols per supported locales.
- App Check: adds protection to Firebase resources.
- Media: image pick + compress; network image caching; SVG rendering; Google Fonts.
- Location: geolocation and reverse geocoding utilities.

## Testing
Run all tests:
```bash
flutter test
```

## Troubleshooting
- Dependency issues: run `flutter clean && flutter pub get`.
- Firebase initialization errors: re-run `flutterfire configure` and confirm platform config files exist.
- Permissions (Android/iOS): ensure required permissions are declared (location, storage, camera as applicable) and requested at runtime.
- Web CORS or App Check: confirm Firebase console settings and domain allowlists.

## Useful Commands
```bash
# Analyze and format (if you use flutter_lints and formatter)
flutter analyze
dart format .

# Generate launcher icons
flutter pub run flutter_launcher_icons:main
```

## Notes
- App title: "Godsseo-App" (see `main.dart`).
- Versioning is managed via `pubspec.yaml` (current: 2.0.0+4).
- Assets are loaded from `assets/image/` and `assets/svg/` (declared in `pubspec.yaml`).

---
If you need environment-specific guidance (e.g., iOS provisioning, Play/App Store submission), let me know and I can add a brief checklist.

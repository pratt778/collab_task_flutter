# CollabTask: Development Guide

Transitioned from the Flutter Clean Starter to the **CollabTask** implementation.

## Project Status: Supabase Task MVP

The app has moved beyond the original starter plan. Current code uses Supabase for auth, workspaces, and task CRUD. Realtime collaboration, notifications, and production route guards remain follow-up work. See `build_plan.md` for the historical roadmap and current gaps.

## Reference Features
- **`auth/`** — full data/domain/presentation example.
- **`tasks/`** — current task board, task detail, and task CRUD feature.

Read [`CLAUDE.md`](CLAUDE.md) for conventions and [`test.md`](test.md) for the testing curriculum.


## Day-1 setup

1. **Clone** to your project folder and `flutter pub get`.
2. **Rename the package** in two places:
   - `pubspec.yaml` → change `name:` from `flutter_clean_starter` to your package name.
   - Globally: `find . -type f \( -name '*.dart' -o -name '*.yaml' \) -exec sed -i '' 's/flutter_clean_starter/your_package/g' {} +`
3. **Rename the bundle ID**:
   - `android/app/build.gradle.kts` — `applicationId` and `namespace`.
   - `android/app/src/main/kotlin/com/example/flutter_clean_starter/MainActivity.kt` — move into a folder matching your reverse-DNS (and update its `package` declaration).
   - `ios/Runner.xcodeproj/project.pbxproj` — search-and-replace `com.example.flutter_clean_starter`.
4. **Swap the app display name**:
   - `android/app/src/main/res/values/strings.xml` → `<string name="app_name">…</string>`.
   - `ios/Runner/Info.plist` → `CFBundleDisplayName`.
   - `lib/core/l10n/app_en.arb` → `appName`.
5. **Point the API at your backend**: `lib/core/config/constants/api_constant.dart` → `devIp`, `localIp`, and the endpoint paths.
6. **Run** with the dev flavor:
   ```bash
   flutter run -t lib/main.dart
   ```
   Splash → IP-config screen in debug → auth → task board.

## App icons

Default Flutter icons are placeholders (a tiny "F" mark). Replace before submission:

1. Drop a single **1024×1024 PNG** at `assets/icon.png`. (Create the `assets/` directory if it doesn't exist; `flutter_launcher_icons` reads from there.)
2. Run `dart run flutter_launcher_icons`. Generates every Android `mipmap-*` size and the full iOS `AppIcon.appiconset` set in one shot.
3. (Optional, Android 8+) Provide a transparent-foreground variant for adaptive icons. Uncomment the `adaptive_icon_*` lines in `pubspec.yaml`'s `flutter_launcher_icons:` block and drop a `assets/icon_foreground.png`.

Repeat any time the icon changes. The config block is already in `pubspec.yaml`.

## Native splash screen

Built-in Flutter launches with a blank white screen. To get a branded splash:

1. Drop a **centered logo PNG** at `assets/splash.png` (transparent background recommended; the splash background color comes from the config).
2. Run `dart run flutter_native_splash:create`. Generates the iOS `LaunchScreen.storyboard` and Android `launch_background.xml` from one config.
3. To remove later: `dart run flutter_native_splash:remove`.

The default brand color is `#096B72` (AppColors.primaryTeal). Edit `flutter_native_splash:` in `pubspec.yaml` to switch.

## Firebase + FCM (off by default)

The starter does **not** ship with a Firebase project. Push notifications and Firebase init are commented out in `lib/main.dart`, and the Google Services Gradle plugin is commented out in `android/settings.gradle.kts` + `android/app/build.gradle.kts` (without that, Gradle fails on missing `google-services.json` even when Dart never calls `Firebase.initializeApp()`). The `firebase_core` and `firebase_messaging` packages stay in `pubspec.yaml` so you can wire them when you're ready.

To enable:

1. `dart pub global activate flutterfire_cli`
2. From the project root: `flutterfire configure` — pick or create your Firebase project; the CLI generates `lib/firebase_options.dart`, `android/app/google-services.json`, and `ios/Runner/GoogleService-Info.plist`.
3. In `android/settings.gradle.kts`: uncomment the `id("com.google.gms.google-services")…` line.
4. In `android/app/build.gradle.kts`: uncomment the `id("com.google.gms.google-services")` line.
5. In `lib/main.dart`: uncomment the Firebase imports and the Firebase + FCM block inside `initializeApp()`.
6. In `lib/core/app/di/injection_container.dart`: uncomment the `FcmNotificationService` registration in `_registerExternal()`.
7. The chassis `AuthSessionWriter` (`lib/features/auth/data/services/auth_session_writer.dart`) does **not** call FCM. Add `fcm.subscribeToTopics(...)` and the matching `fcm.unsubscribeFromTopics(...)` there if your project subscribes users to FCM topics on login. The file's docstring shows the pattern.

The `FcmNotificationService` itself (`lib/core/services/fcm_notification_service.dart`) is fully written — permission request, background handler, foreground display, tap routing — and ready to use.

If your project doesn't need push notifications: remove `firebase_core` and `firebase_messaging` from `pubspec.yaml`, delete `lib/core/services/fcm_notification_service.dart`, and remove the commented Firebase block from `main.dart` and the two `build.gradle.kts` files.

## Common scripts

`scripts/` ships with three shell shortcuts: `fix_ios.sh` (iOS pod nuke + reinstall), `clean.sh` (Dart-side reset), and `check.sh` (`flutter analyze && flutter test` pre-push guard). See the **Scripts** section in [`CLAUDE.md`](CLAUDE.md) for what each does and when to run it.

## Smoke-test before shipping

Once you've renamed the package, swapped icons + splash, and (optionally) wired Firebase, do a real launch:

```bash
flutter run -t lib/main.dart
```

Expected flow: splash → IP-config in debug → auth → task board. If splash or auth crashes, check `main.dart`'s `initializeApp()` and the `MultipleBlocProviders` in `lib/core/app/di/multi_bloc_provider.dart`.

## Logging changes to CHANGES.md

Append a dated entry to [`CHANGES.md`](CHANGES.md) for every meaningful code change. The format and a seed entry are already in the file. Group all entries from the same calendar day under one `## YYYY-MM-DD` heading; newest date at the top. This habit makes it trivial to write release notes, audit drift, and onboard new contributors. Skip the entry only for trivial mechanics (formatting, typo fixes, lint-only changes).

## Adding your first feature

The fastest path: copy an existing real feature with a similar shape, then rename the files/classes and adjust the layer contracts.

The chassis uses **`injectable`** for DI. Annotated datasources, repositories, use cases, and cubits wire through generated registrations after codegen. Two manual steps remain:

1. **Routes** — add a `GoRoute` to `lib/core/app/router/app_router.dart` and a `name` / `path` constant in `MainRoutes`.
2. **ARB** — add user-facing copy to `lib/core/l10n/app_en.arb` (and the other locale ARB), then `flutter pub get` to regenerate.

Then run codegen for both freezed states and the injectable registrations:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or just `./scripts/clean.sh` which does everything plus a fresh pub get.

## What's already done for you

- **Architecture**: clean architecture per feature (`data/domain/presentation`), freezed sealed cubit states (`initial / loading / loaded / error`), dartz `Either<Failure, T>` repos, single-method use cases.
- **Network**: Dio + `ApiHelper` + `SafeRequest.call()` wrapper. Three interceptors: `AuthInterceptor` (forces logout on 401), `ApiLoggerInterceptor` (request/response logs), `RetryInterceptor` (method-aware: connection errors retry on any verb; timeouts/5xx retry on idempotent verbs only).
- **Error handling**: typed `Failure` hierarchy (`ApiFailure`, `NetworkFailure`, `ServerFailure`, `AuthFailure`, `CacheFailure`). Full-screen vs inline error routing via `error_page_helper.dart`. Localized failure messages via `failure_messages.dart`.
- **DI**: `get_it` with all chassis singletons + factories registered in `injection_container.dart`.
- **Routing**: `go_router` with multi-flavor entry points, splash → auth/feature redirect logic, dev IP-config screen for swapping API hosts at runtime.
- **Storage**: `flutter_secure_storage` via `SecureStorageHelper` — token, user code, base IP, all cached in memory after init.
- **Theming**: `ThemeExtension`-based `AppColorsExtension` with light + dark themes cached as `static final`. Persisted via `ThemeCubit`.
- **Localization**: ARB-based with `gen-l10n`. English + a placeholder second locale you can swap.
- **Network recovery**: `NetworkCubit` + `GlobalNetworkRecoveryListener` (snackbar on reconnect) + `NetworkAutoRefreshMixin` (re-fetches on connectivity recovery).
- **Image cache**: `AppImageCacheManager` capping the on-disk image cache at 100 objects / 7 days.
- **FCM**: `FcmNotificationService` set up — wire it in `main.dart` if you need push (else delete the file + remove from DI).
- **Lint rules**: see `analysis_options.yaml`.
- **Tests**: see `test/` and `test.md`.

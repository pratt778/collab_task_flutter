# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**CollabTask**: A lightweight, real-time collaborative workspace for small teams. It combines Trello-style task boards with contextual chat. Built on a clean-architecture mobile-first chassis (Android/iOS).

- **Dart SDK**: ^3.11.0
- **Features**: Auth, Task Board (Kanban), Real-time Chat (WebSockets), Notifications.
- **Status**: Transitioning from starter to Phase 1 (WebSocket + Mock API).


## Architecture Rules

- Organize code by feature under `lib/features/`.
- Each feature must follow clean architecture layers:
  - `data/` — models, datasources, repository implementations
  - `domain/` — entities, repository interfaces, use cases
  - `presentation/` — Cubit/Bloc, pages, widgets
- Do not use data-layer models directly in presentation.
- Repositories return `Either<Failure, T>` using dartz.
- Use cases have a single `call()` method that forwards the repository result.
- **No `.gitkeep` files.** New feature folders must contain scaffold Dart files (dummy classes) instead of `.gitkeep`. Each layer gets a file named `<feature>_<layer>.dart` (e.g., `billing_datasource.dart`, `billing_entity.dart`). The `widgets/` folder is the only folder allowed to be empty.
- **Presentation-only feature exemption.** Two cases qualify — both contain only `presentation/`, no `data/` or `domain/`:
  1. **Pure local-state features** with no remote source (e.g., `theme/`, `locale/`). The cubit reads/writes local storage directly; there's nothing to fetch.
  2. **Composition features** that consume other features' cubits and have no remote of their own. Don't introduce a feature cubit "for consistency" — if you don't have your own remote source, you don't need one.

## Code Style

Base rule set: `package:flutter_lints/flutter.yaml`. Custom rules in `analysis_options.yaml` extend it — the high-leverage ones to write code against:

**Style**
- Single quotes (`prefer_single_quotes`). No double-quoted strings.
- Trailing commas required on multi-line argument lists (`require_trailing_commas`) — keeps `dart format` diffs clean.
- Prefer `const` everywhere possible (`prefer_const_constructors`, `prefer_const_constructors_in_immutables`, `prefer_const_declarations`, `prefer_const_literals_to_create_immutables`).
- `prefer_final_locals`, `prefer_final_in_for_each` — mutable locals must be explicit.
- `sort_child_properties_last` — in widget constructors, `child:` / `children:` go last.
- No `new` keyword (`unnecessary_new`), no `this.x` in method bodies (`unnecessary_this`), no redundant `const` (`unnecessary_const`), no redundant parens / interpolations.

**Error prevention**
- No `print` (`avoid_print`) — use `debugPrint` instead. `ApiLoggerInterceptor` already handles network logs.
- `cancel_subscriptions` / `close_sinks` — always clean up in `dispose()`.
- `use_build_context_synchronously` — after an `await`, check `if (!mounted) return;` before touching `context`.
- `unrelated_type_equality_checks`, `no_duplicate_case_values`, `avoid_empty_else` — static catches for common footguns.

**Other**
- `use_super_parameters` — forward `super.key` etc. without redeclaring.
- `use_key_in_widget_constructors` — every widget takes `super.key`.
- `avoid_unnecessary_containers` — don't wrap a single child in a no-op `Container`.
- `await_only_futures` — don't `await` a non-Future.

**Escape hatches.** For justified one-offs, use `// ignore: rule_name` on the line or `// ignore_for_file: rule_name` at the top of the file. Do not disable rules globally in `analysis_options.yaml` without discussion.

**Enforcement.** `flutter analyze` must be clean before calling work done. If a hook blocks a commit on a lint, fix the root cause — don't bypass with `--no-verify`.

## State Management

- Use Cubit (from flutter_bloc) for feature state management.
- **All state classes use `@freezed` sealed unions** following the `initial / loading / loaded(data) / error(Failure)` pattern (mutation cubits use `submitting / success / error`). See `AuthState` and `DemoState` for canonical examples. Run `dart run build_runner build --delete-conflicting-outputs` after creating/changing a state.
- UI consumes states via `state.when(...)` / `state.maybeWhen(...)`, not field reads.
- Parallel flows (e.g. list + add + types in one feature) → split into separate cubits, each with its own freezed state. Don't stuff multiple status fields into one state.
- Cubits consume use case results via `.fold()`.
- **Optimistic updates for mutation actions.** On success of a mutation API call, *don't* re-fetch the full list — project the server's new state locally by reading the current `loaded(data)`, applying a `copyWith` to the affected field, and re-emitting `loaded(updated)`. Avoids a shimmer flash and an extra round-trip. Only safe when the endpoint's response is deterministic given the request.

## Dependency Injection

- `get_it` + `injectable` codegen. The `sl` singleton is in `lib/core/app/di/injection_container.dart`; the registrations themselves live in the generated `injection_container.config.dart` (do not edit by hand).
- **To register a new class**: annotate it.
  - Datasources, repository impls, helpers/services, "always-loaded" cubits → `@LazySingleton` (or `@LazySingleton(as: AbstractType)` if registered as the abstract).
  - Use cases → `@lazySingleton` (cheap, immutable).
  - "Per-screen" cubits that should be re-created → `@injectable`.
  - Run `dart run build_runner build --delete-conflicting-outputs` after annotating. The `.config.dart` regenerates and `setupInjection()` picks up the new class on next start.
- **Third-party / chassis providers** that injectable can't construct directly (`Dio`, `ApiHelper`, plugin singletons) live in `lib/core/app/di/register_module.dart` as a `@module abstract class`. Add new providers there.
- **Manual post-init wiring**: `setupInjection()` calls `configureDependencies()` first (the injectable-generated init), then runs the manual interceptor wiring (`AuthInterceptor`, `RetryInterceptor`) that needs an `AuthCubit` reference, then awaits `ApiHelper.init()`. Do not put manual `sl.registerXxx(...)` calls anywhere else; either annotate the class or add a `@module` provider.

## Network & Error Handling

- Use Dio through `ApiHelper` (`lib/core/network/api_helper.dart`).
- Wrap all datasource API calls with `SafeRequest.call()` (`lib/core/utils/safe_request_mapper.dart`).
- `SafeRequest` catches exceptions and throws typed `Failure` subclasses.
- `NetworkFailure` = connectivity issues only. `ApiFailure` = 4xx client errors. `ServerFailure` = 5xx.
- `ApiLoggerInterceptor` handles all request/response logging — do not add debugPrint in error handling code.
- **Cubit error variant holds `Failure`, not a `String`.** All cubits emit `error(Failure failure)`. UI resolves to user-facing text at render time via `localizedFailureMessage(context, failure)` in `lib/core/error/failure_messages.dart`. `ApiFailure.message` passes through (backend text is already user-readable); every other `Failure` type maps to a localized ARB key (`errNoInternet`, `errTimeout`, `errServer`, `errAuth`, `errSessionExpired`, `errCache`, `errUnexpected`). Do not build localized copy inside the cubit — state needs the `Failure`, not a string.
- **Global force-logout.** `AuthInterceptor` calls `AuthCubit.forceLogout()` on 401, which emits `AuthState.unauthenticated()`. A single `BlocListener<AuthCubit, AuthState>` in `lib/core/app/app.dart` (inside `MaterialApp.router`'s `builder:`) catches that and routes to `/auth` via `MainRoutes.router.goNamed(authName)` + a "logged out" snackbar. Do not add per-screen listeners for `unauthenticated` — the global one handles it.
- **Custom image cache manager.** Every `CachedNetworkImage` and `CachedNetworkImageProvider` must pass `cacheManager: AppImageCacheManager.instance` (`lib/core/network/app_image_cache_manager.dart`). Default `DefaultCacheManager` keeps 200 objects for 30 days, too generous for a typical mobile footprint — our singleton caps at 100 objects with a 7-day TTL.
- **Transient-failure retries.** `RetryInterceptor` (`lib/core/network/retry_interceptor.dart`) is the last interceptor in the chain. It auto-retries up to 2× with linear backoff (250ms → 750ms) for **transient** failures, before SafeRequest sees them. Policy: `connectionError` and `connectionTimeout` always retry (request never reached the server, safe regardless of method); `sendTimeout` / `receiveTimeout` and 5xx retry on **idempotent verbs only** (GET/HEAD/OPTIONS) so non-idempotent requests can't double-fire; 4xx, 401, cancel, and certificate errors never retry. To disable retry for a specific call, set `requestOptions.extra['_retry_attempt'] = 99` before the request.

## Routing

- go_router with routes defined in `lib/core/app/router/app_router.dart`.
- Initial route: `/` (splash). Splash decides destination: release → `/auth` via `isUserLoggedIn()`; debug → `/ipConfig`.

## Project Configuration

- Single entry point: `lib/main.dart`.
- `AppConfig` in `lib/core/config/constants/app_constant.dart` controls runtime behavior. `AppConfig.enableIpConfig` is `true` in debug mode, `false` in release mode.
- Chucker HTTP inspector disabled in release mode.
- **Runtime base URL (Debug only).** `ApiConstants.baseUrl` is a mutable `static String` so the dev IP-config screen can swap hosts without a rebuild. `main.dart` reads the saved host via `SecureStorageHelper.getBaseIp()` and patches `baseUrl` *before* `setupInjection()` so `Dio`'s `baseUrl` is correct on first request.
- **IP config screen** (`lib/features/dev/presentation/pages/ip_config_screen.dart`) is routed-to from splash when `enableIpConfig` is true. On "Next" it saves the host, mutates `ApiConstants.baseUrl`, patches `sl<Dio>().options.baseUrl` for live session, then navigates to `/auth`.

## Theming

- `AppColorsExtension` (`lib/core/config/theme/app_colors_extension.dart`) — semantic color tokens as `ThemeExtension`. Access via `context.appColors`.
- `AppTheme.light` / `AppTheme.dark` (`lib/core/config/theme/app_theme.dart`) — cached as `static final` to avoid rebuilding `ThemeData` on every frame during theme transitions.
- `ThemeCubit` (`lib/features/theme/presentation/cubit/theme_cubit.dart`) — drives `MaterialApp.themeMode`, persists to `SecureStorageHelper`.
- **Color migration rules:** Static brand colors stay in `AppColors`. Text on fixed brand backgrounds (e.g. white on a teal AppBar) stays static. Theme-driven surfaces/text use `context.appColors.*`.

## Push Notifications (FCM)

- `FcmNotificationService` (`lib/core/services/fcm_notification_service.dart`) — singleton handling all FCM: permission request, background handler, foreground display via `flutter_local_notifications`, tap handling.
- Wire it via `FcmNotificationService().init()` in `main_common.dart` after Firebase init when your project needs push notifications. If you don't, delete the file and remove its DI registration.
- Background handler must remain a top-level function (Firebase requirement).

## Storage

- `SecureStorageHelper` (`lib/core/helper/secure_storage_helper.dart`) for tokens and credentials via `flutter_secure_storage`.

## Network Recovery & Error Pages

- **Auto-refetch on reconnect.** List screens that fetch data should mix in `NetworkAutoRefreshMixin` (`lib/features/shared/widget/network_auto_refresh_mixin.dart`) on their `State<...>` and implement `onNetworkRestored()` to re-trigger their fetches. The mixin subscribes to `NetworkCubit.onRecoveryStream` and calls the override when connectivity comes back. Canonical example: `DemoScreen`.
- **Global "back online" banner.** `GlobalNetworkRecoveryListener` (`lib/features/shared/widget/global_recovery_listener_widget.dart`) wraps the app inside `MaterialApp.router`'s `builder:` and shows a single snackbar via `navigatorKey.currentContext` on recovery. Already wired — don't add per-screen banners.
- **Full-screen error pages.** When a load fails in a way that makes the screen unusable, swap the whole scaffold for a shared page instead of rendering an inline error:
  - `AppErrorPage` (`lib/core/app/pages/app_error_page.dart`) — takes `title?`, `message?`, `onRetry?`. Title/message default to localized `somethingWentWrong` / `errUnexpected` when null.
  - `NotFoundPage` (`lib/core/app/pages/not_found_page.dart`) — takes `message?`, `statusCode?`. Shows the code prominently.
  - `UnAuthorizedPage` (`lib/core/app/pages/un_authorized_page.dart`) — for 403s etc.
- **Pattern for choosing which page to show.** Use the helpers in `lib/core/error/error_page_helper.dart`: `isFullScreenFailure(failure)` (the predicate — `NetworkFailure || statusCode == 404`) and `fullScreenErrorPageOrNull(context, failure: ?, onRetry: ?)` (returns `NotFoundPage` for 404s, `AppErrorPage` otherwise, or `null` if `failure` is null). Pull the failure with `context.select` and short-circuit at the top of `build()`:
  ```dart
  final error = context.select((SomeCubit c) => c.state.maybeWhen(
    error: (f) => isFullScreenFailure(f) ? f : null,
    orElse: () => null,
  ));
  final page = fullScreenErrorPageOrNull(context, failure: error, onRetry: _fetch);
  if (page != null) return page;
  ```
  For screens that gate on **two** cubits' errors together, keep the AND-combiner inline — `if (errA != null && errB != null) { ... }` — and use `isFullScreenFailure` only as the per-cubit predicate.

  Non-connectivity failures (generic 4xx / 5xx) keep rendering inline in the normal `error:` branch of the `BlocBuilder`.

## Localization

- ARB-based with `flutter_localizations` + `gen-l10n`. Source: `lib/core/l10n/app_en.arb` + `app_ne.arb`. Generated into `lib/l10n/gen/app_localizations.dart`.
- UI strings go through `AppLocalizations.of(context).xxx` — **not** static string constants.
- For the active locale, use `Localizations.localeOf(context).languageCode` — **not** `context.read<LocaleCubit>().state.languageCode`. The framework's source is the correct one and properly subscribes to rebuilds. Only write path uses `context.read<LocaleCubit>().setLocale(...)`.
- For ICU interpolation, use ARB `placeholders` with `@key` metadata.
- Constructor default values cannot reference `AppLocalizations.of(context)` (not const). Pattern: make the field nullable, resolve at render via `title ?? l.somethingWentWrong`.
- Dev-only screens (e.g. `ip_config_screen.dart`) stay in plain English — don't pollute ARB with dev-surface keys.

## Change Log

After **every** meaningful code change, append an entry to [`CHANGES.md`](CHANGES.md) under today's date (`## YYYY-MM-DD`). Format:

```
- **Added** / **Removed** / **Updated** / **Refactored** / **Fixed** [the thing]. [Why, in 1-3 sentences. Reference filenames + line numbers when useful.]
```

Group entries from the same day under one heading; newest date at the top. Skip the log only for trivial mechanics (lint-only, formatting). The history is the project's audit trail and release-notes source.

## Push Notifications & Firebase

Firebase + FCM are **off by default** in the starter. To wire them, follow the steps in [`STARTER.md`](STARTER.md). Until you do:

- `lib/main.dart` has the Firebase + FCM init commented out with TODOs.
- `injection_container.dart` does **not** register `FcmNotificationService`.
- `AuthSessionWriter` does **not** call FCM. Re-add `fcm.subscribeToTopics(...)` there once you've enabled FCM and want post-login topic subscriptions.

## Common Commands

```bash
# Run the app
flutter run

# Run all tests
flutter test

# Static analysis
flutter analyze

# Get dependencies
flutter pub get

# Build runner (for freezed/json_serializable)
dart run build_runner build --delete-conflicting-outputs
```

## Scripts (`scripts/`)

Shell shortcuts for the recurring chores. All exit non-zero on failure so they're safe to chain.

| Script | What it does | When to run |
|---|---|---|
| `./scripts/build.sh` | Run `build_runner` once | When you add/change code-gen files (freezed, injectable) |
| `./scripts/watch.sh` | Run `build_runner` in watch mode | Auto-generate files on save during development |
| `./scripts/fix.sh` | Apply automated dart fixes | To quickly resolve lint issues and deprecations |
| `./scripts/feature.sh <name>` | Create clean-architecture folders | Starting a new feature (e.g., `./scripts/feature.sh projects`) |
| `./scripts/fix_ios.sh` | `pod deintegrate` + nuke `Pods/` and `Podfile.lock` + `pod install --repo-update` | "pod install failed", linker errors, module-not-found, after switching branches with iOS dep changes |
| `./scripts/clean.sh` | `flutter clean` + remove `.dart_tool/` and `pubspec.lock` + `pub get` + `build_runner` | Freezed gen drifted, dep changes flaky, "this should work but doesn't" after a branch switch. Doesn't touch iOS Pods — use `fix_ios.sh` for that |
| `./scripts/check.sh` | `flutter analyze` + `flutter test` | Before pushing a branch or opening a PR. Pre-CI guard |

Add new scripts when a chore becomes recurring; resist adding one for every command.

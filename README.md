# CollabTask

A modern, real-time collaborative task management and team productivity mobile application built with **Flutter** and powered by **Supabase**. CollabTask enables teams to organize workspaces, manage projects through visual Kanban boards, track task deadlines, and engage in instant, per-task discussions synced live across devices via WebSockets.

---

## 📌 Table of Contents

- [What CollabTask Does](#-what-collabtask-does)
- [Key Features](#-key-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation & Setup](#installation--setup)
  - [Database & Backend Setup](#database--backend-setup)
  - [Code Generation](#code-generation)
  - [Running the App](#running-the-app)
- [Testing](#-testing)
  - [Testing Stack](#testing-stack)
  - [Running Tests](#running-tests)
  - [Static Analysis](#static-analysis)
  - [Testing Conventions & Patterns](#testing-conventions--patterns)

---

## 💡 What CollabTask Does

CollabTask is designed to simplify project tracking and team collaboration in fast-paced environments. It bridges the gap between high-level task tracking and contextual communication:

1. **Workspace Collaboration:** Users can create distinct workspaces for different teams or projects, invite members, and switch seamlessly between them.
2. **Visual Workflow Tracking:** Tasks move across visual Kanban columns (**To Do**, **In Progress**, and **Done**), giving team members immediate visibility into project velocity and bottlenecks.
3. **Contextual Task Discussions:** Instead of disjointed communication in external chat tools, each task houses its own real-time discussion thread. Messages appear live across all connected devices using Supabase Realtime channels.
4. **Cross-Platform Resilience:** Built using Clean Architecture principles and Cubit state management to ensure offline responsiveness, robust error handling, and high testability.

---

## 🚀 Key Features

### 🏢 Workspace Management
- Create, update, and manage multiple workspaces.
- Invite members by email and assign workspace roles.
- Switch between active workspaces with state persisted across app launches.

### 📋 Kanban Task Board
- Intuitive task status categorization: **To Do**, **In Progress**, and **Done**.
- Quick task creation modal accessible directly from the floating action button (FAB).
- Task cards displaying assignees, due dates, and status indicators.

### 📝 Task Details & Assignment
- Comprehensive task view with editable titles and descriptions.
- Assign team members and update deadlines.
- Status transition actions with immediate UI feedback.

### 💬 Real-Time Task Chat
- In-task discussion screen for contextual collaboration.
- Live message streaming powered by Supabase Realtime (WebSocket channels).
- Optimistic UI updates with resilient connection and stream handling.

### 🔐 Authentication & Security
- Secure user registration and login powered by Supabase Auth.
- Session persistence via secure local storage.
- Backend Row-Level Security (RLS) guaranteeing data isolation across workspaces and users.

### 👤 Profile & Customization
- User profile management with display name and avatar updates via image picker.
- Dynamic theme switching (**Light** and **Dark** modes).
- Full internationalization support with 5 languages (**English**, **German**, **Spanish**, **French**, **Nepali**).

### 🛠️ Stability & Developer Tooling
- **SafeRequest Mapper:** Centralized error handling mapping network and database exceptions to typed `Failure` objects.
- **Network Resilience:** Connectivity status detection and Dio retry interceptors.
- **In-App HTTP Inspector:** Integrated Chucker network inspector available in debug builds for monitoring API traffic.

---

## 🛠️ Tech Stack

| Category | Technology / Library | Description |
|---|---|---|
| **Framework** | [Flutter](https://flutter.dev) (Dart SDK `^3.11.0`) | Cross-platform mobile application framework |
| **Architecture** | Feature-First Clean Architecture | Strict separation into `domain`, `data`, and `presentation` layers |
| **State Management** | [Cubit](https://bloclibrary.dev/bloc-concepts/#cubit) (`flutter_bloc`) | Lightweight, method-driven state management using Cubits (without event boilerplate) |
| **State Models & Immutability** | [freezed](https://pub.dev/packages/freezed) & [equatable](https://pub.dev/packages/equatable) | Code-generated unions, value equality, and copyWith helpers |
| **Dependency Injection** | [get_it](https://pub.dev/packages/get_it) + [injectable](https://pub.dev/packages/injectable) | Code-generated compile-time service locator container |
| **Backend & Database** | [Supabase](https://supabase.com) (`supabase_flutter`) | PostgreSQL, Auth, Row-Level Security (RLS), and Realtime WebSockets |
| **Networking** | [Dio](https://pub.dev/packages/dio) | HTTP client configured with auth, retry, and inspection interceptors |
| **Navigation & Routing** | [go_router](https://pub.dev/packages/go_router) | Declarative routing with deep-link support and route guards |
| **UI & Styling** | `flutter_screenutil`, `google_fonts`, `flutter_svg`, `shimmer` | Adaptive screen sizing, custom typography, vector graphics, and skeleton loading |
| **Local Storage** | [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) | Encrypted key-value persistence for sensitive tokens |
| **Localization** | `flutter_localizations`, `intl` | ARB-based localization with multi-language code generation |
| **Testing** | `flutter_test`, `bloc_test`, `mocktail` | Unit testing, Cubit stream testing, and mock verification |

---

## 📁 Project Structure

The project follows a **Feature-First Clean Architecture** approach. Code is organized into modular feature slices under `lib/features/`, supported by a shared foundation in `lib/core/`.

```
lib/
├── core/                                # App-wide chassis & shared infrastructure
│   ├── app/                             # Application bootstrap, router, DI setup, bloc observer
│   │   ├── di/                          # GetIt container and MultiBlocProvider setup
│   │   ├── pages/                       # Global error and placeholder screens
│   │   └── router/                      # go_router configuration and route definitions
│   ├── config/                          # Application configuration, themes, constants
│   │   ├── constants/                   # API endpoints and app-wide constants
│   │   └── theme/                       # Light & dark theme palettes and typography
│   ├── error/                           # Error domain: Failure types, exception definitions
│   ├── extension/                       # Dart extensions (String formatting, BuildContext, SnackBar)
│   ├── gen/                             # Generated asset references (flutter_gen)
│   ├── helper/                          # Utility helpers (DateTime, secure storage, page transitions)
│   ├── l10n/                            # ARB localization files (app_en.arb, app_de.arb, etc.)
│   ├── network/                         # Dio client, interceptors, WebSocket service, image cache
│   ├── services/                        # System services (FCM push notification service)
│   └── utils/                           # SafeRequest exception mapper, locale utilities, mock data
│
├── features/                            # Independent feature modules
│   ├── auth/                            # User login, registration, password management
│   ├── chat/                            # Real-time task discussion and messaging
│   ├── dev/                             # Developer utilities and debug tools
│   ├── locale/                          # Locale selection cubit and preferences
│   ├── notifications/                   # Notification display and handlers
│   ├── profile/                         # User profile view, avatar upload, and updates
│   ├── settings/                        # App settings (theme toggle, language switcher)
│   ├── shared/                          # Feature-shared widgets and cubits
│   ├── theme/                           # ThemeCubit and theme mode persistence
│   ├── tasks/                           # Kanban board, task creation, details, and assignment
│   └── workspaces/                      # Workspace CRUD, membership, and workspace switcher
│
└── main.dart                            # Application entry point and initialization
```

### Layer Organization Within Each Feature

Each feature directory adheres to the Clean Architecture layer separation:

- **`domain/`**: The core business logic layer, free from external dependencies. Contains **Entities**, abstract **Repository interfaces**, and specific **UseCases**.
- **`data/`**: The infrastructure layer. Contains **Data Sources** (Supabase clients, Dio requests), **Models** (JSON serialization with `freezed`), and concrete **Repository implementations**.
- **`presentation/`**: The UI layer. Contains **Screens/Pages**, **BLoC/Cubits** managing UI state, and feature-specific **Widgets**.

---

## 🏁 Getting Started

### Prerequisites

Ensure you have the following installed on your machine:

- **Flutter SDK:** `>= 3.11.0` ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Dart SDK:** `>= 3.11.0` (bundled with Flutter)
- **Supabase Account:** Free project at [supabase.com](https://supabase.com)
- **Android Studio** or **Xcode** (for device emulators/simulators)

### Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/collab_task_flutter.git
   cd collab_task_flutter
   ```

2. **Install Flutter packages:**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables:**
   Create a `.env` file in the root directory of the project:
   ```env
   SUPABASE_URL=https://your-project-ref.supabase.co
   SUPABASE_ANON_KEY=your-supabase-anon-key
   ```

### Database & Backend Setup

CollabTask relies on Supabase for authentication, PostgreSQL storage, and Realtime messaging.

1. Open your Supabase project dashboard.
2. Navigate to the **SQL Editor**.
3. Execute the SQL schema script provided in [SUPABASE_SETUP.md](SUPABASE_SETUP.md). This creates:
   - Tables (`profiles`, `workspaces`, `workspace_members`, `tasks`, `task_assignees`, `messages`)
   - Automated profile creation triggers upon sign-up
   - Row-Level Security (RLS) policies
   - Realtime publication hooks for `tasks` and `messages`
4. In **Database -> Replication**, verify that `supabase_realtime` is enabled for the `tasks` and `messages` tables.

### Code Generation

Generate immutable models, dependency injection containers, and localization files:

```bash
# Generate Freezed models, JSON serializers, and Injectable DI
dart run build_runner build --delete-conflicting-outputs

# Generate localization classes from ARB files
flutter gen-l10n
```

### Running the App

Launch the application on a connected device or emulator:

```bash
# Run in debug mode
flutter run

# Run on a specific device
flutter run -d <device_id>
```

---

## 🧪 Testing

The codebase employs an automated testing strategy covering pure utility logic, async exception mapping, and BLoC/Cubit state machines.

### Testing Stack

- **[flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html):** Core test framework and widget test harness.
- **[bloc_test](https://pub.dev/packages/bloc_test):** Declarative testing for BLoC and Cubit state emission streams.
- **[mocktail](https://pub.dev/packages/mocktail):** Type-safe, null-safe mocking library without code generation.

### Running Tests

Execute test suites via the Flutter CLI:

```bash
# Run all unit and cubit tests
flutter test

# Run tests with detailed, expanded output
flutter test -r expanded

# Run a specific test file
flutter test test/core/utils/safe_request_mapper_test.dart

# Run tests matching a specific description
flutter test --plain-name "SafeRequest"
```

### Static Analysis

Check for lint issues, type mismatches, and code formatting rules:

```bash
flutter analyze
```

### Testing Conventions & Patterns

The project follows consistent testing conventions across layers:

1. **Pure Function Tests:**
   Standard `expect(actual, expected)` assertions for extension functions and utilities (e.g. `string_extension_test.dart`).

2. **Async Error Mapping (`SafeRequest`):**
   Validates that all network and database exceptions (e.g., timeouts, 401s, 404s, 500s) map cleanly to their corresponding domain `Failure` types (`NetworkFailure`, `AuthFailure`, `ServerFailure`).

3. **Cubit State Machine Tests (`blocTest`):**
   State emissions follow a strict 3-phase test structure:
   ```dart
   blocTest<MyCubit, MyState>(
     'emits [loading, loaded] when operation succeeds',
     build: () {
       when(() => mockUseCase.call()).thenAnswer((_) async => Right(sampleData));
       return MyCubit(useCase: mockUseCase);
     },
     act: (cubit) => cubit.performAction(),
     expect: () => [
       const MyState.loading(),
       const MyState.loaded(sampleData),
     ],
   );
   ```

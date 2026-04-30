Here’s the complete project specification in Markdown format. You can copy everything below, paste it into a text editor, and save it as `COLLABTASK_SPEC.md`.

```markdown
# 📱 CollabTask: Project Specification & Architecture Guide

## 🎯 App Concept & Vision
**CollabTask** is a lightweight, real-time collaborative workspace for small teams (2–10 users). It combines **Trello-style task cards** with **Slack-style contextual chat**, eliminating tool-switching friction. Built for speed, reliability, and zero manual refreshes.

## 👥 Target Audience & Core Problem
| Audience | Pain Point | CollabTask Solution |
|----------|------------|---------------------|
| Students & Freelancers | Task tracking scattered across emails, chats, notes | Unified board + live sync + smart notifications |
| Small Remote Pods | Context lost in generic channels | Task-anchored chat threads, @mentions, deep links |
| Power Users | Unreliable offline states, poor UX | Graceful retry, cached UI, strict error boundaries, pixel-perfect design |

## 🧩 Core Features & Screens
| Screen | Purpose | Key Interactions |
|--------|---------|------------------|
| **Auth & Onboarding** | Login, signup, workspace creation | Email/password, social OAuth, password reset, session persistence |
| **Task Board** | Kanban-style view (To Do / In Progress / Done) | Drag/reorder, assignees, due dates, real-time status sync |
| **Task Detail** | Deep dive into a single task | Description, checklist, contextual chat, share button, deep link routing |
| **Notifications** | In-app feed of updates & reminders | Filter by type, mark read, tap → navigate to source card/chat |
| **Settings** | App preferences & environment toggle | Theme, language, notification prefs, flavor switching (`dev`/`staging`/`prod`) |

## 🔄 End-to-End User Flow
1. **Open App** → Checks secure storage → if token exists, skips login → fetches workspace.
2. **Create Card** → Fills form → submits → server saves → WebSocket broadcasts update → all teammates see it appear instantly.
3. **Assign & @Mention** → Triggers FCM push to mentioned user.
4. **Tap Notification** → Deep link opens → bypasses home → lands directly on task detail + scrolls to chat.
5. **Network Drops** → UI shows retry banner → queues pending actions locally → auto-syncs when connection returns.
6. **Cold Start / Reinstall** → Restores session via secure storage → resumes exact workspace state.

## 🛠️ Tech Stack & Feature Mapping
| Technology | Product Role | Why It's Required |
|------------|--------------|-------------------|
| **Dio + Interceptors** | REST API communication | Auto token injection, 401 refresh, retry, error normalization, logging |
| **Cubit / Bloc** | UI state management per screen | Predictable state for loading, success, error, real-time updates |
| **Feature-Based Clean Architecture** | Code organization & scalability | Isolate features, enforce boundaries, make testing & scaling possible |
| **WebSockets** | Live card moves, chat, typing indicators, presence | Zero-latency updates without polling |
| **FCM + Push Notifications** | Background alerts, reminders, @mentions | Keep users engaged when app is closed |
| **Deep Linking** | Task sharing, password resets, notification routing | Seamless navigation from external sources |
| **Shared Preferences** | App settings, onboarding state, theme, notification toggles | Fast, lightweight local config storage |
| **Flutter Secure Storage** | JWT tokens, user/workspace IDs, encrypted session data | Prevent token leakage, enable secure auto-login |
| **Proper Error Handling** | Network failures, server errors, parse errors, offline states | Graceful UI fallbacks, retry logic, centralized logging |
| **Writing Tests** | Unit, widget, integration, golden tests | Catch regressions, verify state flows, ensure UI accuracy |
| **Dart DevTools** | Debugging, profiling, memory inspection, state tracking | Find jank, leaks, inefficient rebuilds, verify interceptors |
| **Flutter Flavors** | `dev`, `staging`, `prod` environments | Separate APIs, Firebase configs, app icons, debug toggles |
| **Flutter Lints** | Code quality, consistency, CI-ready standards | Enforce best practices, reduce bugs, speed up reviews |
| **Design Accuracy** | Figma → Flutter, responsive, accessible, token-driven | Professional UX, consistent spacing/typography, dark mode, a11y |

## 🏗️ Architecture & Folder Structure
```
lib/
├── core/
│   ├── constants/          # API URLs, strings, assets, env keys
│   ├── errors/             # Failure types, Either/Result pattern, exceptions
│   ├── network/            # Dio client, interceptors, websocket service
│   ├── storage/            # SecureStorage & SharedPrefs wrappers
│   ├── utils/              # Logger, validators, formatters, retry logic
│   └── theme/              # Design tokens, ThemeData, responsive helpers
├── common/                 # Shared widgets, extensions, routes, DI setup
├── features/
│   ├── auth/               # data/ domain/ presentation/
│   ├── tasks/              # Board, Card, Detail, Chat
│   ├── notifications/      # Feed, FCM handlers, local schedulers
│   └── settings/           # Prefs, theme, account, flavor toggle
├── main.dart
└── injection.dart          # GetIt + Injectable setup
```
**Rule:** Each feature owns its `data/domain/presentation`. `core/` handles cross-cutting concerns. `common/` holds reusable UI/routing. No feature imports from sibling features.

## 🚀 Implementation Roadmap
| Phase | Focus | Deliverables |
|-------|-------|--------------|
| **1. Foundation** | Flavors, lints, routing, core network, storage | `analysis_options.yaml`, `go_router`, `dio_client.dart`, `secure_storage.dart` |
| **2. Auth & Session** | Login/signup, token refresh, route guards | `AuthCubit`, `AuthInterceptor`, `RefreshInterceptor`, deep link resets |
| **3. Task Board** | CRUD, pagination, drag/drop, error handling | `TaskCubit`, REST fetch, retry UI, offline cache prep |
| **4. Real-Time Sync** | WebSockets, reconnect, chat stream | `WebSocketService`, exponential backoff, `ChatCubit` subscription |
| **5. Notifications** | FCM, local fallback, tap routing | `firebase_messaging` setup, `go_router` deep link parsing, in-app feed |
| **6. Design & Polish** | Figma tokens, responsive UI, accessibility | `AppTheme`, `DesignTokens`, skeleton loaders, `Semantics` tags |
| **7. Testing & DevTools** | Unit, widget, integration, profiling | `bloc_test`, `mocktail`, `integration_test`, DevTools workflows |
| **8. CI/CD & Release** | Lint, test, build pipelines, flavor configs | GitHub Actions, fastlane (optional), release builds |

## 💡 Key Production Patterns

### 🔑 Dio Interceptors (Auth + Refresh + Error)
```dart
class AuthInterceptor extends Interceptor {
  final SecureStorage storage;
  AuthInterceptor(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.read(key: 'access_token');
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/auth/refresh')) {
      final newToken = await _refreshToken();
      if (newToken != null) {
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        handler.resolve(await Dio().fetch(err.requestOptions));
        return;
      }
    }
    handler.next(err);
  }
}
```

### 🌐 WebSocket Service (Reconnect + Streams)
```dart
class WebSocketService {
  WebSocketChannel? _channel;
  final _statusController = StreamController<WSStatus>.broadcast();
  final _dataController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<WSStatus> get statusStream => _statusController.stream;
  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;

  Future<void> connect({required String token}) async {
    _channel = IOWebSocketChannel.connect(Uri.parse('wss://api.dev/ws?token=$token'));
    _channel!.stream.listen(
      (data) => _dataController.add(jsonDecode(data)),
      onError: (_) => _scheduleReconnect(),
      onDone: () => _scheduleReconnect(),
      cancelOnError: false,
    );
  }
  // Exponential backoff & graceful disconnect implemented in full version
}
```

### 🛤️ Deep Link Routing (go_router)
```dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (_, state) => TaskDetailScreen(id: state.pathParameters['id']!),
    ),
  ],
  errorBuilder: (_, state) => const ErrorScreen(),
);
```

### 🧪 Testing Strategy
| Layer | Tool | Example |
|-------|------|---------|
| Unit | `test` + `mocktail` + `bloc_test` | `blocTest<AuthCubit, AuthState>()` |
| Widget | `flutter_test` | `await tester.pumpWidget(TestApp(child: LoginScreen()))` |
| Integration | `integration_test` | Full auth → create task → receive push → verify deep link |
| Golden | `golden_toolkit` | Pixel-perfect UI comparison across themes |

## 🛡️ Pro Tips & Common Pitfalls
| Pitfall | Solution |
|---------|----------|
| Overcomplicating Clean Architecture | Keep `data` simple. Use `Cubit` until you need streams. Don't over-engineer use cases. |
| Memory leaks in streams | Always `close()` cubits, cancel WebSocket subscriptions, dispose controllers. |
| FCM not delivering in background | Use `FirebaseMessaging.onBackgroundMessage`, keep payload minimal, test on real device. |
| Deep links failing on iOS | Configure `Associated Domains`, add `apple-app-site-association`, test with Safari. |
| Dio retry loops | Limit retries, check `isNetworkError`, clear tokens before retry. |
| Testing async flows | Use `pumpAndSettle()`, `await tester.pump()`, mock timers with `fake_async`. |

## 🚦 Next Steps
1. Initialize repo with the folder structure above
2. Configure `analysis_options.yaml` with strict lints (`very_good_analysis` or `flutter_lints`)
3. Set up Flutter Flavors (`dev`, `staging`, `prod`) with separate `firebase_options.dart` & API URLs
4. Build `core/` → `auth/` → `tasks/` sequentially
5. Write tests alongside features (don't leave them for last)
6. Use Dart DevTools early to catch performance/memory issues

---
**Need the next step?** Reply with:
- `1` → Full `pubspec.yaml` + Flavor setup scripts
- `2` → `core/network/` (Dio + WS + Interceptors + Error Mapping)
- `3` → `go_router` + Deep Link + Notification Tap Routing
- `4` → `AuthCubit` + Secure Storage + Route Guards
- `5` → `TaskBoardCubit` + Drag/Drop + Optimistic Updates
- `6` → Test Pyramid Setup + DevTools Profiling Workflow
```

### 📥 How to Save as `.md`
1. Copy everything inside the code block above
2. Open any text editor (VS Code, Notepad++, TextEdit, etc.)
3. Paste → Save As → `COLLABTASK_SPEC.md`
4. Open in any Markdown viewer or GitHub/GitLab for clean rendering

Let me know which number (`1`–`6`) you want to build next, and I’ll drop production-ready code with exact setup steps, test cases, and DevTools tips.

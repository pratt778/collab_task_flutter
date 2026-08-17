# 📋 CollabTask: Complete Build Guide

**Date**: 2026-04-30  
**User**: Pratham Sharma  
**Status**: Supabase-backed MVP largely complete. ✅ Auth, workspaces, task CRUD, board UI, realtime chat. ⏳ Remaining: task-board realtime sync, **access/refresh token handling at the app layer**, notifications/FCM, route hardening, broader tests. Track progress with the checkbox trackers below.

---

## 🚀 QUICK START CHECKLIST (Before Any Phase)

Run these once to validate your local setup:

```bash
# 1. Get dependencies
flutter pub get

# 2. Generate all code (freezed, injectable, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# 3. Run lint check
flutter analyze

# 4. Run tests
flutter test

# 5. Run app (dev flavor)
flutter run -t lib/main.dart
```

**Expected outcome**: App launches → splash → IP config in debug → login screen → task board.

If all ✅, proceed to Phase 1.

---

## 🏗️ ARCHITECTURE DECISION TREE

### WebSocket Strategy: **Simple (Last-Write-Wins)**
- **Why**: Easiest to implement, suitable for small teams (2–10 users)
- **Tradeoff**: If two users edit simultaneously, last save wins
- **Upgrade path**: Can evolve to Operational Transforms (OT) / CRDT later if concurrent editing becomes critical
- **Decision**: ✅ Proceed with simple WebSocket

### API Approach: **Supabase**
- Current app uses Supabase for auth, workspaces, and task CRUD.
- The old mock endpoint plan below is retained as historical context only.
- Add real migrations under `supabase/migrations/` before treating the backend as production-managed.

### Testing: **Minimal for MVP**
- Manual testing primary
- Widget tests for critical flows (LoginScreen, TaskBoard, ErrorPages)
- No integration tests yet
- Can add bloc_test / mocktail later as codebase stabilizes

### State Management: **Multi-Cubit Per Feature**
- `TaskListCubit` → handles list fetch, filtering, pagination
- `TaskDetailCubit` → handles single-task mutations (assignee, status, dueDate)
- `ChatCubit` → handles message stream, sending
- **Why**: Separation of concerns, easier testing, independent scaling

---

## 📊 PHASE BREAKDOWN & DEPENDENCY GRAPH

```
┌─ Phase 0: Pre-Phase Checks ✅
├─ Phase 1: WebSocket + Mock API ✅ (built, later superseded by Supabase Realtime)
│  └─ Phase 1.5: Auth & Token Management (Access + Refresh) ⏳
│     ├─ Supabase SDK auto-refresh ✅ (managed internally)
│     ├─ App-layer 401 → refresh-and-retry ❌
│     ├─ Persist access + refresh token pair ❌
│     └─ Session-expired force logout on refresh failure ⏳
├─ Phase 2: Task Board Core ✅
├─ Phase 3: Kanban Board UI ✅
├─ Phase 4: Real-Time Sync ⏳
│  ├─ Realtime chat ✅ (via Supabase Realtime websockets)
│  ├─ Task board realtime sync ❌
│  └─ Optimistic updates ⏳ (chat done, board pending)
└─ Phase 5: Task Detail + Chat ✅
   └─ Phase 6: Notifications & Polish ❌
```

**Critical Path**: Phase 1 → 2 → 3 → 4 → 5 (6 is optional for MVP)

---

## 📡 API CONTRACT (Mock Implementation)

All endpoints return JSON. Error responses use Failure types from `lib/core/error/failures.dart`.

### Task Entity
```json
{
  "id": "task_1",
  "title": "Design login flow",
  "description": "Finalize wireframes and color scheme",
  "status": "todo",  // "todo" | "inProgress" | "done"
  "assignees": ["user_1", "user_2"],
  "dueDate": "2026-05-15T00:00:00Z",
  "createdAt": "2026-04-30T10:00:00Z",
  "updatedAt": "2026-04-30T10:00:00Z",
  "labels": ["design", "urgent"],
  "checklist": [
    {"id": "check_1", "title": "Wireframes", "completed": true},
    {"id": "check_2", "title": "Color palette", "completed": false}
  ]
}
```

### REST Endpoints (HTTP)

| Method | Path | Description | Request | Response |
|--------|------|-------------|---------|----------|
| GET | `/tasks` | List all tasks | Query: `?status=todo&assignee=user_1&page=1&limit=20` | `{ tasks: Task[], total: int, hasMore: bool }` |
| GET | `/tasks/:id` | Get single task | — | `{ task: Task }` |
| POST | `/tasks` | Create task | `{ title, description, dueDate?, assignees? }` | `{ task: Task }` |
| PATCH | `/tasks/:id` | Update task | `{ title?, description?, status?, dueDate?, assignees? }` | `{ task: Task }` |
| DELETE | `/tasks/:id` | Delete task | — | `{ success: bool }` |
| POST | `/tasks/:id/checklist` | Add checklist item | `{ title }` | `{ checklist: ChecklistItem }` |
| PATCH | `/tasks/:id/checklist/:checkId` | Toggle checklist | `{ completed: bool }` | `{ checklist: ChecklistItem }` |

### WebSocket Endpoint (Real-Time)

**URL**: `wss://api.dev/ws?token=<JWT>`

**Server → Client Events**:
```json
{
  "type": "task_created",
  "data": { "task": Task }
}

{
  "type": "task_updated",
  "data": { "taskId": "task_1", "changes": { "status": "inProgress" } }
}

{
  "type": "task_deleted",
  "data": { "taskId": "task_1" }
}

{
  "type": "message_created",
  "data": { "message": Message }
}

{
  "type": "presence",
  "data": { "userId": "user_1", "status": "online" }
}
```

**Client → Server Actions**:
```json
{
  "action": "subscribe",
  "channels": ["task", "chat"]
}

{
  "action": "send_message",
  "taskId": "task_1",
  "text": "Let's discuss this tomorrow"
}
```

### Error Response Format
```json
{
  "error": {
    "code": "VALIDATION_ERROR",  // or API_ERROR, AUTH_ERROR, SERVER_ERROR, NETWORK_ERROR
    "message": "Title is required",
    "statusCode": 400
  }
}
```

Maps to one of 9 Failure types in `lib/core/error/failures.dart`.

---

## 🔧 PHASE 1: WebSocket + Mock API Setup

**Deliverables**:
- ✅ `WebSocketService` in core/network with full reconnect logic (legacy — realtime now uses Supabase channels)
- ✅ Mock API endpoints (local or jsonplaceholder proxy)
- ✅ API contract docs
- ✅ Readiness check: App starts, routes work, no crashes
- ⏳ `AuthInterceptor` attempts access-token refresh and retries once before force-logout on 401
- ⏳ Persist the access + refresh token pair in `SecureStorageHelper` (today it stores a legacy single `token` / `userCode`)
- ⏳ Cold-start session restore via the refresh token (no re-login on relaunch)
- ⏳ `RefreshTokenExpiredFailure` → global session-expired logout

### Step 1.1: Create WebSocketService

**File**: `lib/core/network/websocket_service.dart`

**Key components**:
- `WebSocketStatus` enum: `connecting / connected / disconnected / error`
- `statusStream` → broadcasts connection status
- `dataStream` → broadcasts incoming messages
- `connect(token)` → establishes connection with JWT
- `disconnect()` → graceful close
- `send(action)` → client-to-server action
- Auto-reconnect with exponential backoff (250ms → 500ms → 1s max)
- Handle network disconnection gracefully

**Reference**: Study existing `NetworkCubit` in `lib/features/shared/network_cubit.dart` for Stream + debounce patterns

**DI Registration**: Add to `lib/core/app/di/register_module.dart` as `@module` provider

### Step 1.2: Set Up Mock API Endpoints

**Option A: Use jsonplaceholder Proxy**
- Endpoint: `https://jsonplaceholder.typicode.com`
- Create `/tasks` mapper: fetch `/posts`, transform to Task schema

**Option B: Local Mock Server (Spring Boot / Node.js)**
- Simpler for development (no latency, easy to test)
- Can run locally on `http://localhost:8080`
- Configure base URL via IP config screen

**Recommendation**: Option A for quick start (no extra server), Option B once feature set stabilizes

### Step 1.3: Define Mock Data Service (Optional)

**File**: `lib/core/utils/mock_data_generator.dart`

Generate 10–20 sample tasks for UI testing:
```dart
List<TaskModel> generateMockTasks() => [
  TaskModel(id: 'task_1', title: 'Design login', status: 'todo', ...),
  TaskModel(id: 'task_2', title: 'Set up database', status: 'inProgress', ...),
  ...
];
```

Use this in demo feature or create a "seed data" endpoint.

### Step 1.4: Update API Constants

**File**: `lib/core/config/constants/api_constant.dart`

Add task endpoints:
```dart
static const String tasksEndpoint = '/tasks';
static const String taskDetailEndpoint = '/tasks/:id';
static const String wsEndpoint = '/ws';
```

### Step 1.5: Readiness Checks

**Checklist**:
- [ ] `flutter analyze` passes (no lints)
- [ ] WebSocketService compiles (injectable annotation, Stream setup)
- [ ] Mock endpoint is accessible (via curl or Postman)
- [ ] Chucker shows successful API calls (dev flavor only)
- [ ] Go to `IP config` screen → swap API URL → verify it sticks on next request
- [ ] Manually subscribe to WebSocket → send test message → receive on dataStream

**Verification Script**:
```bash
# Check code quality
flutter analyze

# Run build_runner to regenerate DI + freezed
dart run build_runner build --delete-conflicting-outputs

# Start app
flutter run -t lib/main.dart

# Manually test in app:
# 1. Login (any credentials)
# 2. Open Chucker (icon in IP config or dev menu)
# 3. Make API call → verify in Chucker
# 4. Check WebSocket connection logs in console (debugPrintWs or similar)
```

---

## 🔐 PHASE 1.5: Auth & Token Management (Access + Refresh)

**Goal**: Use Supabase's access-token + refresh-token session model everywhere, so requests never die on an expired token and cold starts restore the session without re-login.

**Current state**: The Supabase SDK already stores and auto-refreshes the token pair internally — `AuthCubit.checkLoginStatus()` reads `Supabase.instance.client.auth.currentSession` (`auth_cubit.dart:37`). What's missing is the app-layer wiring: `AuthInterceptor` (`core/network/auth_interceptor.dart`) force-logs-out on any 401 instead of refreshing, and `SecureStorageHelper` persists a legacy single `token` / `userCode` rather than the pair.

**Deliverables**:
- [ ] `SecureStorageHelper` stores access token + refresh token as a pair (keep `userCode` only as a legacy alias or drop it)
- [ ] `AuthInterceptor` on 401 → call `auth.refreshSession()` once, retry the original request with the fresh token, and only force-logout if the refresh itself fails
- [ ] Refresh token is never sent to business APIs — only the access token is (Supabase REST/PostgREST already does this via its JWT)
- [ ] Cold start / splash restores the session from the persisted pair (or Supabase storage) instead of relying on `userCode`
- [ ] `RefreshTokenExpiredFailure` (already defined in `core/error/failures.dart`) surfaces `errSessionExpired` + the global force-logout — no per-screen handling
- [ ] Logout clears the full token pair from secure storage
- [ ] Realtime websocket channel reconnects with the refreshed access token after a 401-refresh

**Verification**:
- [ ] Wait for access-token expiry → next API call auto-refreshes and succeeds (no logout, no error snackbar)
- [ ] Kill the app mid-session → cold start lands on the task board without re-login
- [ ] Revoke the refresh token (or wait past expiry) → app logs out with the session-expired message

---

## 🛠️ PHASE 2: Task Board Core Layer

**Deliverables**:
- ✅ Task entities & models (JSON serializable)
- ✅ Task datasource + repository
- ✅ UseCases (GetTasks, CreateTask, UpdateTask, DeleteTask)
- ✅ TaskListCubit + TaskDetailCubit (Freezed states)
- ✅ DI wiring (all annotations done, `build_runner` runs clean)

### Architecture Decisions
- **Entity**: Pure Dart class (no JSON), represents business object
- **Model**: JSON serializable (auto via `json_serializable`), has `toEntity()` method
- **Datasource**: Abstract (for testing) + concrete implementation wrapping SafeRequest
- **Repository**: Returns `Either<Failure, T>`, maps models to entities
- **UseCase**: Single `call()` method, forwards repo result
- **Cubit**: Freezed sealed union state, fold() from usecase, emit updates

### Key Patterns
1. **All datasource API calls wrapped in `SafeRequest.call()`**
   ```dart
   Future<List<TaskModel>> getTasks() => SafeRequest.call(() async {
     final response = await apiHelper.get(path: ApiConstants.tasksEndpoint);
     return (response.data as List).map((e) => TaskModel.fromJson(e)).toList();
   });
   ```

2. **Repository maps models to entities**
   ```dart
   @override
   Future<Either<Failure, List<TaskEntity>>> getTasks() async {
     final result = await datasource.getTasks();
     return Right(result.map((m) => m.toEntity()).toList());
   }
   ```

3. **Cubit folds result**
   ```dart
   Future<void> getTasks() async {
     emit(const TaskListState.loading());
     final result = await getTasksUseCase();
     result.fold(
       (failure) => emit(TaskListState.error(failure)),
       (tasks) => emit(TaskListState.loaded(tasks)),
     );
   }
   ```

### Folder Structure
```
lib/features/tasks/
├── data/
│   ├── datasources/
│   │   ├── task_datasource.dart      # Abstract + impl
│   ├── models/
│   │   ├── task_model.dart           # JSON serializable
│   │   └── checklist_item_model.dart
│   └── repositories/
│       └── task_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── task_entity.dart
│   │   └── checklist_item_entity.dart
│   ├── repositories/
│   │   └── task_repository.dart     # Abstract
│   └── usecases/
│       ├── get_tasks_usecase.dart
│       ├── create_task_usecase.dart
│       ├── update_task_usecase.dart
│       └── delete_task_usecase.dart
└── presentation/
    ├── cubit/
    │   ├── task_list_cubit.dart
    │   ├── task_list_state.dart     # Freezed
    │   ├── task_detail_cubit.dart
    │   └── task_detail_state.dart   # Freezed
    ├── pages/
    │   ├── task_board_screen.dart   # Landing page (Kanban)
    │   └── task_detail_screen.dart  # Single task view
    └── widgets/
        ├── task_card.dart           # Reusable card widget
        └── task_form.dart           # Create/edit modal
```

### DI Registration Pattern
```dart
// In data/datasources or models
@LazySingleton()
class TaskDatasource { ... }

// In data/repositories
@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository { ... }

// In domain/usecases
@lazySingleton
class GetTasksUseCase { ... }

// In presentation/cubit
@injectable
class TaskListCubit extends Cubit<TaskListState> { ... }
```

Then run: `dart run build_runner build --delete-conflicting-outputs`

---

## 🎨 PHASE 3: Kanban Board UI

**Deliverables**:
- ✅ TaskBoardScreen with 3 columns (To Do / In Progress / Done)
- ✅ TaskCard widget (title, assignees, due date, labels)
- ✅ FAB → create task modal
- ✅ Tap card → navigate to TaskDetailScreen via deep link
- ✅ Drag/reorder between columns (basic reordering without WebSocket yet)
- ✅ Network error → full-screen retry (use `AppErrorPage`)

### UI Patterns from Starter

1. **Screen scaffold**
   ```dart
   class TaskBoardScreen extends StatefulWidget { ... }
   class _TaskBoardScreenState extends State<TaskBoardScreen> with NetworkAutoRefreshMixin { ... }
   ```
   Use `NetworkAutoRefreshMixin` to auto-refetch on reconnect

2. **BlocBuilder + Error Handling**
   ```dart
   BlocBuilder<TaskListCubit, TaskListState>(
     builder: (context, state) => state.when(
       initial: () => const SizedBox.shrink(),
       loading: () => const Center(child: CircularProgressIndicator()),
       loaded: (tasks) => _buildBoard(tasks),
       error: (failure) {
         final fullScreenPage = fullScreenErrorPageOrNull(context, failure: failure, onRetry: _fetch);
         if (fullScreenPage != null) return fullScreenPage;
         return Center(child: Text(localizedFailureMessage(context, failure)));
       },
     ),
   )
   ```

3. **Routing to detail**
   Add to `lib/core/app/router/app_router.dart`:
   ```dart
   GoRoute(
     path: '/tasks/:id',
     name: 'taskDetail',
     builder: (_, state) => TaskDetailScreen(
       taskId: state.pathParameters['id']!,
     ),
   ),
   ```

### Kanban Column Layout
```dart
Row(
  children: [
    _buildColumn('To Do', TaskStatus.todo, tasks),
    _buildColumn('In Progress', TaskStatus.inProgress, tasks),
    _buildColumn('Done', TaskStatus.done, tasks),
  ],
)

_buildColumn(String title, TaskStatus status, List<TaskEntity>) {
  return Expanded(
    child: Column(
      children: [
        // Header
        // Draggable list of cards in this status
      ],
    ),
  );
}
```

### Drag & Drop Pattern
Use `Draggable` + `DragTarget` for reordering:
```dart
Draggable<TaskEntity>(
  data: task,
  feedback: TaskCard(task: task),
  child: TaskCard(task: task),
  onDragEnded: (details) => context.read<TaskDetailCubit>().updateTask(
    taskId: task.id,
    status: newStatus, // Dragged to column
  ),
)
```

Or use third-party: `flutter_reorderable_grid_view`, `trello_kit`, etc. (add to pubspec if preferred)

---

## ⚡ PHASE 4: Real-Time Sync (WebSocket Integration)

**Deliverables**:
- ✅ TaskListCubit subscribes to WebSocket events
- ✅ On task_created → optimistic UI append (don't refetch)
- ✅ On task_updated → local `copyWith` + re-emit
- ✅ On task_deleted → filter list
- ✅ Offline → graceful queue (manual testing)

### Integration Points

1. **Cubit init subscribes to WebSocket**
   ```dart
   late final StreamSubscription _subscription;

   void _init() {
     _subscription = sl<WebSocketService>().dataStream.listen(
       (data) => _handleWebSocketEvent(data),
       onError: (err) => emit(TaskListState.error(...)),
     );
   }

   @override
   Future<void> close() {
     _subscription.cancel();
     return super.close();
   }
   ```

2. **Handle incoming events**
   ```dart
   void _handleWebSocketEvent(Map<String, dynamic> data) {
     final type = data['type'] as String?;
     if (type == 'task_created') {
       final task = TaskModel.fromJson(data['data']['task']).toEntity();
       state.maybeWhen(
         loaded: (tasks) => emit(TaskListState.loaded([...tasks, task])),
         orElse: () {},
       );
     }
     // Handle other types: task_updated, task_deleted, etc.
   }
   ```

3. **Optimistic updates on mutation**
   ```dart
   // Inside updateTask() method
   state.maybeWhen(
     loaded: (tasks) {
       final idx = tasks.indexWhere((t) => t.id == taskId);
       if (idx >= 0) {
         final updated = [...tasks];
         updated[idx] = updated[idx].copyWith(status: newStatus);
         emit(TaskListState.loaded(updated));
       }
       // Also send API request in background (fire-and-forget after emit)
     },
     orElse: () {},
   );
   ```

### NetworkAutoRefreshMixin Usage
Already in starter, just use it:
```dart
class _TaskBoardScreenState extends State<TaskBoardScreen> with NetworkAutoRefreshMixin {
  @override
  void onNetworkRestored() {
    context.read<TaskListCubit>().getTasks();
  }
}
```

---

## 💬 PHASE 5: Task Detail + Chat

**Deliverables**:
- ✅ TaskDetailScreen (full task info + description + checklist)
- ✅ ChatCubit + ChatWidget (messages, send)
- ✅ Real-time chat via WebSocket subscription
- ✅ Tap notification → deep link to task detail with auto-scroll to chat

### Chat Structure
```
Message {
  id: string,
  taskId: string,
  userId: string,
  userName: string,
  text: string,
  createdAt: datetime,
  reactions?: { emoji, count }
}
```

### ChatCubit Pattern
```dart
@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = _Initial;
  const factory ChatState.loading() = _Loading;
  const factory ChatState.loaded(List<Message> messages) = _Loaded;
  const factory ChatState.submitting() = _Submitting;
  const factory ChatState.error(Failure failure) = _Error;
}

@injectable
class ChatCubit extends Cubit<ChatState> {
  final GetMessagesUseCase getMessages;
  final SendMessageUseCase sendMessage;

  void init(String taskId) {
    // Similar to TaskListCubit: subscribe to WS, fetch initial
    sl<WebSocketService>().dataStream.listen((data) {
      if (data['type'] == 'message_created' && data['data']['taskId'] == taskId) {
        state.maybeWhen(
          loaded: (msgs) => emit(ChatState.loaded([...msgs, Message.fromJson(...)])),
          orElse: () {},
        );
      }
    });
  }

  Future<void> sendMsg(String text) async {
    emit(const ChatState.submitting());
    // Optimistic: add to list immediately
    state.maybeWhen(
      loaded: (msgs) {
        final newMsg = Message(id: uuid(), text: text, userId: currentUser.id, ...);
        emit(ChatState.loaded([...msgs, newMsg]));
        // Then fire API in background
        sendMessage(taskId, text).then((_) => {}).catchError((e) {
          emit(ChatState.error(Failure.fromException(e)));
        });
      },
      orElse: () {},
    );
  }
}
```

### Deep Link from Notifications
Add to `app_router.dart`:
```dart
GoRoute(
  path: '/tasks/:id',
  // ... existing config
  onExit: (context) {
    // If coming from notification tap and query param ?scroll=chat
    final queryParams = GoRouterState.of(context).uri.queryParameters;
    if (queryParams['scroll'] == 'chat') {
      // Auto-scroll to chat in detail screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(chatWidgetOffset);
      });
    }
    return true;
  },
)
```

---

## 🔔 PHASE 6: Notifications & Polish (Optional for MVP)

**Deliverables**:
- ✅ In-app notification feed (list of updates)
- ✅ FCM setup (optional; skip if no push needed yet)
- ✅ Tap notification → deep link to task detail
- ✅ Manual testing across scenarios

### In-App Notification Feed
```
NotificationCubit → NotificationState(List<InAppNotification>)
On WS event → emit updated list
UI shows badge count + snackbar on new notification
Tap notification → navigate via deep link
```

### FCM Setup (If Needed)
Uncomment in `lib/main.dart`:
```dart
// Import firebase_core, firebase_messaging
// await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// await FcmNotificationService().init();
```

Then in `lib/features/auth/data/services/auth_session_writer.dart`, add topic subscription:
```dart
// After login
await fcm.subscribeToTopic('workspace_${workspace.id}');
```

---

## 📝 SUMMARY TABLE

| Phase | Focus | Duration | Blocker | Files Created | Status |
|-------|-------|----------|---------|---|--------|
| 0 | Pre-checks | 5 min | None | None | ✅ |
| 1 | WebSocket + API | 2–3 hrs | None | websocket_service.dart, api_contract.md | ✅ (superseded by Supabase) |
| 1.5 | Access + Refresh tokens | 2–3 hrs | None | auth_interceptor.dart, secure_storage_helper.dart | ⏳ |
| 2 | Task CRUD layer | 4–5 hrs | Phase 1 | 15–20 files (entities, models, datasources, repos, cubits) | ✅ |
| 3 | Kanban UI | 3–4 hrs | Phase 2 | task_board_screen, task_card, task_detail_screen | ✅ |
| 4 | Real-time sync | 2–3 hrs | Phase 1 + 2 | TaskListCubit subscription, chat cubit | ⏳ (chat done, board pending) |
| 5 | Chat + Detail | 3–4 hrs | Phase 4 | ChatCubit, ChatWidget, ChatState | ✅ |
| 6 | Notifications | 2–3 hrs | Phase 5 | NotificationCubit, NotificationScreen, FCM init | ❌ |
| **Total** | **MVP Complete** | **19–25 hrs** | — | ~30 files | ✅ ⏳ ❌ |

---

## ✅ VERIFICATION CHECKLIST (End of Each Phase)

### Phase 0 ✅
- [x] `flutter pub get` succeeds
- [x] `dart run build_runner build --delete-conflicting-outputs` succeeds
- [x] `flutter analyze` clean
- [x] `flutter run -t lib/main.dart` launches app
- [x] IP config screen accessible (dev only)
- [x] Chucker showing API calls

### Phase 1 ✅ (realtime later moved to Supabase channels)
- [x] WebSocketService compiles & injectable annotations correct
- [x] Manual WebSocket connection test: send message → receive in stream
- [x] Mock endpoint accessible via curl/browser
- [x] DI registration picked up (no build errors)

### Phase 1.5 ⏳ (Auth & Token Management)
- [ ] App-layer 401 → `auth.refreshSession()` + retry once before logout
- [ ] Access + refresh token pair persisted in `SecureStorageHelper`
- [ ] Cold start restores session via refresh token (no re-login)
- [ ] Refresh token never sent to business APIs
- [ ] `RefreshTokenExpiredFailure` → `errSessionExpired` + global logout
- [ ] Logout clears the full token pair
- [ ] Realtime channel reconnects with refreshed access token

### Phase 2 ✅
- [x] `dart run build_runner build` regenerates task models/cubits
- [x] `flutter analyze` passes with new files
- [x] TaskListCubit emits states correctly (test in console logs)
- [x] TaskDetailCubit optimistic update works locally

### Phase 3 ✅
- [x] TaskBoardScreen renders without crash
- [x] Tap card → navigate to detail page
- [x] FAB → task creation modal opens
- [x] Column layout responsive (portrait + landscape)

### Phase 4 ⏳
- [ ] Task board realtime: `TaskListCubit` reacts to Supabase `tasks` channel (chat already does)
- [ ] Optimistic: create task → see in list immediately
- [ ] WS event arrives → UI updates without refetch
- [x] Realtime chat via Supabase channels (message appears live on other devices)
- [ ] Manual offline test: disconnect network → queue actions → reconnect → auto-sync

### Phase 5 ✅
- [x] TaskDetailScreen loads single task
- [x] ChatWidget renders message list
- [x] Send message → appears in list + sent via API
- [x] WS chat event → appears in chat
- [ ] Deep link `/tasks/task_1?scroll=chat` → opens detail + scrolls to chat

### Phase 6 ❌
- [ ] In-app notification appears on WS event
- [ ] Tap notification → navigate to task
- [ ] (Optional) FCM: push received on device when app backgrounded

---

## 🎯 NEXT STEPS

When ready, implement (in this order):
1. **Phase 1.5**: Access + refresh token flow — refresh-and-retry in `AuthInterceptor`, persist the token pair, session restore on cold start
2. **Phase 4**: Task board realtime via a Supabase `tasks` channel subscription in `TaskListCubit` (mirror the chat pattern)
3. **Phase 5 leftover**: Notification-tap deep link with `?scroll=chat` auto-scroll
4. **Phase 6**: In-app notification feed + optional FCM

---

## 📌 KEY PATTERNS (Reference)

### SafeRequest Wrapper (All Datasources)
```dart
Future<List<TaskModel>> getTasks() => SafeRequest.call(() async {
  final response = await apiHelper.get(path: ApiConstants.tasksEndpoint);
  return (response.data as List).map((e) => TaskModel.fromJson(e)).toList();
});
```

### Freezed Sealed Union State (All Cubits)
```dart
@freezed
class TaskListState with _$TaskListState {
  const factory TaskListState.initial() = _Initial;
  const factory TaskListState.loading() = _Loading;
  const factory TaskListState.loaded(List<TaskEntity> tasks) = _Loaded;
  const factory TaskListState.error(Failure failure) = _Error;
}
```

### Cubit Fold & Emit
```dart
Future<void> getTasks() async {
  emit(const TaskListState.loading());
  final result = await getTasksUseCase();
  result.fold(
    (failure) => emit(TaskListState.error(failure)),
    (tasks) => emit(TaskListState.loaded(tasks)),
  );
}
```

### Widget State Consumption
```dart
BlocBuilder<TaskListCubit, TaskListState>(
  builder: (context, state) => state.when(
    initial: () => const SizedBox.shrink(),
    loading: () => const CircularProgressIndicator(),
    loaded: (tasks) => _buildBoard(tasks),
    error: (failure) => Text(localizedFailureMessage(context, failure)),
  ),
)
```

### DI: Annotate & Register
```dart
// Data layer
@LazySingleton()
class TaskDatasource { ... }

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl { ... }

// Domain layer
@lazySingleton
class GetTasksUseCase { ... }

// Presentation
@injectable
class TaskListCubit { ... }

// Then run: dart run build_runner build --delete-conflicting-outputs
```

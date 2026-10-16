# CollabTask — Progress

> Last updated: 2026-10-10
> Source of truth for what's shipped vs. what's left. Keep this updated as you complete items.
> Detailed phase plan lives in [`build_plan.md`](build_plan.md).

Legend: `[x]` done · `[~]` partially done / exists but not verified end-to-end · `[ ]` not started

## ✅ Done

### Core infrastructure
- [x] Flutter project initialized with clean architecture boilerplate
- [x] DI setup (GetIt + injectable, code-generated)
- [x] Theme (light/dark via ThemeCubit) + ScreenUtil + Google Fonts
- [x] Routing with go_router
- [x] Error handling (Failure types, SafeRequest wrapper)
- [x] Localization setup — 5 locales: en, de, es, fr, ne (ARB + generated files)
- [x] Native splash screen + launcher icons config
- [x] Supabase initialization (flutter_dotenv for config)

### Auth
- [x] Login screen + flow (email/password via Supabase)
- [x] Registration screen + flow
- [x] Logout

### Workspaces
- [x] Fetch my workspaces
- [x] Create workspace
- [x] Add member to workspace
- [x] Delete workspace
- [x] Workspace selection persists across reloads (selected workspace preserved on reload)

### Tasks
- [x] Task CRUD (list, create, update, delete) via Supabase
- [x] Task board screen (Kanban: To Do / In Progress / Done)
- [x] Task detail screen (assignees, status, due date)
- [x] Task creation modal from FAB
- [x] Task discussion screen (chat entry point)

### Chat
- [x] Chat message model, repository, use cases
- [x] Realtime chat via Supabase Realtime channels (messages appear live across devices)
- [x] Emit-after-close guard on TaskChatCubit (stale subscription fix)

### Profile & settings
- [x] Profile management (remote data source, repository, state management)
- [x] Profile screen (avatar via image picker)
- [x] Settings screen (theme + language switching)
- [x] Localization coverage for settings, task board, forgot-password across all 5 locales

---

## ⏳ Left / In Progress

### Auth (flows exist as screens/use cases but need completion & verification)
- [ ] OTP verification — wire end-to-end and verify (screen + `verify_otp_usecase` exist)
- [ ] Forgot password — wire end-to-end and verify (screen + `reset_password_usecase` exist)
- [ ] Reset password (set new password) — wire end-to-end and verify
- [ ] Session restore on cold start

### Phase 1.5 — Auth & token management
- [ ] App-layer 401 → refresh-and-retry interceptor
- [ ] Persist access + refresh token pair (flutter_secure_storage)
- [ ] Session-expired → force logout on refresh failure

### Phase 4 — Realtime sync
- [ ] Task board realtime: `TaskListCubit` reacts to a Supabase `tasks` channel (chat pattern already proven)
- [ ] Optimistic updates: create task → appears in list immediately
- [ ] WS event → board updates without refetch
- [ ] Offline test: disconnect → queue actions → reconnect → auto-sync

### Phase 5 leftover
- [ ] Deep link `/tasks/task_1?scroll=chat` → opens detail + scrolls to chat

### Phase 6 — Notifications & polish
- [ ] In-app notification on WS event
- [ ] Tap notification → navigate to task
- [ ] FCM push when app backgrounded (firebase_messaging is integrated, flow pending)

### Testing & hardening
- [ ] Widget tests for critical flows (LoginScreen, TaskBoard, error pages)
- [ ] bloc_test + mocktail coverage for cubits/use cases
- [ ] Route hardening (auth guards, redirect logic edge cases)
- [ ] Supabase migrations under `supabase/migrations/`

---

## 🎯 Suggested next order

1. Finish & verify OTP verification, forgot password, and reset password flows
2. Phase 1.5 — token refresh interceptor + persisted token pair + force logout
3. Phase 4 — task board realtime (mirror the chat channel pattern)
4. Phase 5 leftover — notification deep link auto-scroll
5. Phase 6 — in-app notifications + FCM

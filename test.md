# Testing guide — irrigation_flutter

A hands-on walkthrough for writing Flutter tests in this codebase. Each milestone adds one new concept against a real file in `lib/`. The pattern you learn in each milestone applies to many similar files elsewhere in the project.

---

## Progress

- [x] **Step 0** — Setup (deps, folder tree)
- [x] **Milestone 1** — Pure function (`nepali_converter_extension`)
- [x] **Milestone 2** — Async + exceptions (`SafeRequest`)
- [x] **Milestone 3** — Use case + mocked repository (`GetComplaintTypesUseCase`)
- [ ] **Milestone 4** — Cubit with `bloc_test` (`ComplaintCubit`)
- [ ] **Milestone 5** — Cubit with optimistic updates (`NotificationCubit`)
- [ ] **Milestone 6** — Widget test (`LogoutButton`)

---

## Step 0 — Setup

### Dependencies added (`pubspec.yaml` → `dev_dependencies`)

```yaml
bloc_test: ^10.0.0    # matchers for Cubit/Bloc state streams
mocktail: ^1.0.4      # mocking without codegen
```

Why `mocktail` over `mockito`? No code generation, works cleanly with null-safety, and plays well with `dartz`'s `Either<Failure, T>` return types.

### Folder layout

Tests mirror `lib/`. Created:

```
test/
  core/
    extension/
    utils/
  features/
    complaint/presentation/cubit/
    notification/presentation/cubit/
    home/domain/usecases/
    profile/presentation/widgets/
```

### Sanity-check command

```bash
flutter test   # should be green or "No tests found" — never red during setup
```

---

## Milestone 1 — Pure function, no Flutter

**Target:** `lib/core/extension/nepali_converter_extension.dart`
**Test file:** `test/core/extension/nepali_converter_extension_test.dart`

The extension adds `.toNepali()` on `Object`. It returns the object's string form with ASCII digits swapped for Devanagari (`2082` → `२०८२`).

### The test file

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:irrigation_flutter/core/extension/nepali_converter_extension.dart';

void main() {
  group('NepaliNumberConverter', () {
    test('converts a single ASCII digit to its Devanagari equivalent', () {
      expect('0'.toNepali(), '०');
      expect('9'.toNepali(), '९');
    });

    test('converts a multi-digit string digit-by-digit', () {
      expect('2082'.toNepali(), '२०८२');
    });

    test('works on int via the Object.toString() path', () {
      expect(9841.toNepali(), '९८४१');
    });

    test('passes non-digit characters through unchanged', () {
      expect('v1.2'.toNepali(), 'v१.२');
      expect(''.toNepali(), '');
    });
  });
}
```

### Anatomy of a test file

| Piece | What it does |
|-------|--------------|
| `import 'package:flutter_test/flutter_test.dart';` | The test framework (extends the `test` package with Flutter helpers). |
| `import '.../code_under_test.dart';` | The thing you're testing. |
| `void main()` | Entry point. `flutter test` runs every `*_test.dart` file's `main`. |
| `group(name, body)` | Organizational scope. Prepends `name` to every inner test's reported title. |
| `test(name, body)` | One behavior, one test. Name describes the behavior in present tense. |
| `expect(actual, expected)` | Assertion. Literal `expected` is implicitly wrapped in the `equals(...)` matcher. |

### Arrange / Act / Assert

Every test follows the same shape:

```dart
test('converts a multi-digit string digit-by-digit', () {
  // Arrange — set up inputs (here, just the literal '2082')
  // Act     — call the thing under test ('2082'.toNepali())
  // Assert  — verify the result
  expect('2082'.toNepali(), '२०८२');
});
```

For trivial pure functions, all three collapse into one `expect` line. For a cubit test, Arrange becomes "seed a mock," Act becomes "call `cubit.getX()`," Assert becomes "check emitted states." The shape never changes.

### Why these four tests

| Test | What it proves |
|------|----------------|
| `'0'` → `'०'`, `'9'` → `'९'` | Mapping table wired at both ends. |
| `'2082'` → `'२०८२'` | The `split('').map(...).join()` pipeline handles multiple chars. |
| `9841.toNepali()` (int) | Extension on `Object` funnels through `.toString()`. Regression guard. |
| `'v1.2'` and `''` | Non-digits pass through via the `?? c` fallback; empty input doesn't crash. |

Happy path + the two edges most likely to break under refactor.

### Naming tests

Test names are your documentation. Good names:
- Start with a verb in present tense: `converts`, `passes`, `throws`, `emits`.
- Describe behavior, not mechanism: ✅ `"returns cached value on second call"` ❌ `"test2"`.
- Are **unique enough to filter on** (see `--plain-name` below).

---

## Running tests

### Reporters — formatting of the output

| Reporter | Flag | When to use |
|----------|------|-------------|
| `compact` | (default) | Daily dev loop. Overwriting single line. Quiet on pass, verbose on fail. |
| `expanded` | `-r expanded` | Debugging, demos, learning. Every test name on its own line. |
| `github` | `-r github` | CI on GitHub Actions — annotations on PRs. |
| `json` | `-r json` | Machine-readable stream for IDEs / custom dashboards. |

```bash
flutter test -r expanded
```

Counter format: `+N` = passed so far, `-N` = failed so far.

### Filtering — run a subset

```bash
flutter test --plain-name "multi-digit"   # substring match on combined "<group> <test>" name
flutter test --name "^NepaliNumber"       # regex version
flutter test test/core/extension/         # path scope
flutter test test/core/extension/nepali_converter_extension_test.dart   # single file
```

Combine freely:

```bash
flutter test -r expanded --plain-name "converts" test/core/
```

### Matching rules

The full name is `<group name> <test name>`. If your group is `NepaliNumberConverter` and your test is `"converts a multi-digit string digit-by-digit"`, the matcher sees `NepaliNumberConverter converts a multi-digit string digit-by-digit`. Substring/regex matches against that.

---

## Style — tests follow the same lint rules

Tests go through `analysis_options.yaml` too. Which means:
- Single quotes (`prefer_single_quotes`).
- Trailing commas on multi-line calls (`require_trailing_commas`).
- `prefer_final_locals` — immutable test locals.
- No `print` — use `debugPrint` or let `expect` failure messages do the talking.

`flutter analyze` must stay clean across `test/` as well.

---

## Milestone 2 — Async + exceptions + branch coverage

**Target:** `lib/core/utils/safe_request_mapper.dart`
**Test file:** `test/core/utils/safe_request_mapper_test.dart` (15 tests)

`SafeRequest.call<T>(Future<T> Function() request)` wraps a datasource call, awaits it, and converts any thrown `Exception` or `DioException` into a typed `Failure`. Every datasource in this project calls its API through this — getting it right is load-bearing.

### What's new in this milestone

| Concept | Syntax |
|---------|--------|
| Async test | `test('name', () async { ... })` |
| Await an assertion | `await expectLater(future, matcher)` |
| Assert a future rejects | `throwsA(matcher)` |
| Assert the rejection type | `isA<Failure>()` |
| Assert fields on the error | `isA<AuthFailure>().having((f) => f.statusCode, 'statusCode', 401)` |
| Chain multiple field checks | `.having(...).having(...)` |
| Reduce ceremony with a helper | a local `DioException dioException({...})` factory |

### `expectLater` vs `expect`

`expect(actual, matcher)` is synchronous — fine for pure values. For futures, use:

```dart
await expectLater(
  SafeRequest.call(() async => throw const ApiException('boom')),
  throwsA(isA<ApiFailure>().having((f) => f.message, 'message', 'boom')),
);
```

- `expectLater` returns a `Future<void>` that completes when the matcher resolves.
- `await` in front guarantees the test function doesn't return until the assertion is done — otherwise your test could "pass" before the assertion fails.
- `throwsA(matcher)` matches the *error* a rejected future produces, against `matcher`.

### `isA<T>().having(...)` — the matcher composition pattern

```dart
isA<AuthFailure>()
    .having((f) => f.statusCode, 'statusCode', 401)
    .having((f) => f.message, 'message', 'token expired')
```

Reads as: *"a value of type `AuthFailure` whose `statusCode` equals `401` and whose `message` equals `'token expired'`."*

- First arg: an extractor function — pulls the field off the matched value.
- Second arg: a **name** used in the failure message (e.g. `Expected: ... having statusCode that equals 401`). Purely for diagnostics.
- Third arg: the expected value or a nested matcher.

Chain `.having(...)` as many times as you need fields verified.

### Reducing ceremony with a test helper

`DioException`'s constructor needs a `requestOptions`, a `type`, and optionally a `response`. Ten tests that each build one = noise. Instead, declare a helper at the top of `main`:

```dart
final requestOptions = RequestOptions(path: '/test');

DioException dioException({
  required DioExceptionType type,
  int? statusCode,
  Object? data,
}) {
  return DioException(
    requestOptions: requestOptions,
    type: type,
    response: statusCode != null
        ? Response(
            requestOptions: requestOptions,
            statusCode: statusCode,
            data: data,
          )
        : null,
  );
}
```

Each test then reads as one line of intent:

```dart
dioException(type: DioExceptionType.connectionTimeout)
dioException(type: DioExceptionType.badResponse, statusCode: 401, data: {'message': 'token expired'})
```

Rule of thumb: if three tests share identical construction boilerplate, extract a helper. Put it in `main()` (closure captures) unless it's big enough to deserve its own `test_helpers/` file.

### Structuring tests around the production code

`SafeRequest.call` has three distinct responsibility groups:
1. Typed exceptions (`ApiException`, `AuthException`, `CacheException`, unknown).
2. `DioException.type` branches (timeouts, network, cancel).
3. `DioException.badResponse` by status code (401, 403, 404, generic 4xx, 5xx).

The test file mirrors that structure with **nested `group`s**:

```dart
group('SafeRequest.call', () {
  group('typed exception → matching Failure', () { ... });
  group('DioException.type branches', () { ... });
  group('DioException.badResponse by status code', () { ... });
});
```

Each nested group corresponds to a `switch` arm in the source. Test names read like a spec: `"401 → AuthFailure with server message and statusCode"` describes the contract in one line. If you add a new status-code arm in `_mapBadResponse`, you add exactly one test in the "by status code" group — and the tree structure makes the gap obvious.

### Branch coverage

`_mapDioError` has 6 branches (3 timeouts, badResponse, connectionError, cancel, default). `_mapBadResponse` has 6 (401, 403, 404, 4xx, 5xx, fallback). We wrote one test per meaningful branch:

- **3 timeouts** collapse to one outcome, but we test each separately because `||` patterns in `switch` can silently desync from the `DioExceptionType` enum when Dio updates. One test per enum value = fast detection.
- We **did not** test the `default → UnexpectedFailure()` fallback on `_mapDioError` or the fallback on `_mapBadResponse` — those require invalid enum values that can't actually happen at runtime. Test behavior users can trigger, not the compiler's happy-path.

### Stale `debugPrint`

Running the test surfaces `response is ...` lines on stdout — `_mapBadResponse` has a leftover `debugPrint('response is $data');` at `safe_request_mapper.dart:41`. Tests still pass, but the noise is a good signal that the line shouldn't be in production. Flagged for cleanup; not in scope for this milestone.

### Run it

```bash
flutter test -r expanded test/core/utils/safe_request_mapper_test.dart
# → 15 tests, all passing
```

---

## Milestone 3 — Use case + mocked repository

**Target:** `lib/features/complaint/domain/usecases/get_complaint_types_usecase.dart`
**Test file:** `test/features/complaint/domain/usecases/get_complaint_types_usecase_test.dart` (3 tests)

`GetComplaintTypesUseCase` is 14 lines. It holds a `ComplaintRepository` and forwards `repository.getComplaintTypes()`. There's no branching to test — the whole value of the test is verifying **the wiring**: that the use case calls the right repo method, returns whatever the repo returned (no transformation), and does it exactly once.

### What's new in this milestone

| Concept | Syntax |
|---------|--------|
| Mock class | `class MockComplaintRepository extends Mock implements ComplaintRepository {}` |
| Stub an async method | `when(() => mock.getComplaintTypes()).thenAnswer((_) async => const Right(types))` |
| Assert method was called | `verify(() => mock.getComplaintTypes()).called(1)` |
| Assert no other calls | `verifyNoMoreInteractions(mock)` |
| Fresh state per test | `setUp(() { mock = ...; useCase = ...; })` |
| Late-init pattern | `late MockComplaintRepository repository;` |
| dartz success | `const Right<Failure, List<ComplaintTypeEntity>>(types)` |
| dartz failure | `const Left<Failure, List<ComplaintTypeEntity>>(failure)` |

### Why we need a mock

`GetComplaintTypesUseCase` holds `ComplaintRepository` — an abstract interface. In production, DI injects `ComplaintRepositoryImpl`, which calls a real HTTP datasource. Unit-testing the use case doesn't want real HTTP; it wants to **control what the repo returns** so each test can assert specific forwarding behavior.

`mocktail` creates a stand-in that:
- Satisfies the `ComplaintRepository` interface (so `GetComplaintTypesUseCase(mock)` type-checks).
- Records every method call for later `verify(...)`.
- Returns a stub-controlled value instead of running real logic.

```dart
class MockComplaintRepository extends Mock implements ComplaintRepository {}
```

One line. `extends Mock` gets the recording + stubbing machinery. `implements ComplaintRepository` gets the interface. No codegen.

### The `setUp` pattern

```dart
late MockComplaintRepository repository;
late GetComplaintTypesUseCase useCase;

setUp(() {
  repository = MockComplaintRepository();
  useCase = GetComplaintTypesUseCase(repository);
});
```

- `late` means "assigned before first read." Required because `setUp` runs before each test — not at field-declaration time.
- `setUp(...)` runs its body **before each `test(...)`** in the enclosing `group` (or file if top-level).
- Fresh mock per test = no leaked stubs or call counts between tests. This is the single most important habit in stateful testing.
- `tearDown(...)` would run *after* each test — we don't need it here because Dart GCs the mock and we're not touching external state.

### `when` / `thenAnswer` — stubbing behavior

```dart
when(() => repository.getComplaintTypes())
    .thenAnswer((_) async => const Right(types));
```

- `when(() => ...)` declares "when the argument expression is invoked on the mock, apply the following stub."
- The argument is a **callback** (`() => ...`), not a direct call — that lets mocktail intercept the invocation without actually running it.
- `thenAnswer((_) async => ...)` handles **async** returns. The `_` is the `Invocation` (which args were passed — ignored here). Use `thenAnswer` for `Future` / `Stream` returns.
- For sync returns, use `thenReturn(value)` instead.

### `verify` — asserting calls happened

```dart
verify(() => repository.getComplaintTypes()).called(1);
verifyNoMoreInteractions(repository);
```

- `verify(() => ...).called(N)` fails the test if the method wasn't called exactly N times.
- `.called(greaterThan(0))` or matcher args work for looser assertions.
- `verifyNoMoreInteractions(mock)` fails if any method on the mock was called that hasn't been verified yet. Great guardrail on single-responsibility classes — catches "the use case accidentally invoked a second repo method."

### dartz `Either`, `Right`, `Left`

This codebase uses `Either<Failure, T>` as the return type for every repository method:

- `Right(value)` = success branch, carries a `T`.
- `Left(failure)` = failure branch, carries a `Failure`.

Both are `Either<L, R>` where `L = Failure` and `R = List<ComplaintTypeEntity>`. At the `expect` site, you often need to **annotate the generic**:

```dart
expect(result, const Right<Failure, List<ComplaintTypeEntity>>(types));
```

Why? `const Right(types)` alone would infer as `Right<dynamic, List<ComplaintTypeEntity>>`, which doesn't `==` a `Right<Failure, List<ComplaintTypeEntity>>`. Pinning both generics makes the equality check work. If you see a mysterious "equal values don't match" failure in `Either` tests, a generic mismatch is the usual cause.

### The three tests

| Test | What it proves |
|------|----------------|
| Returns `Right(types)` when repo does | Happy path forwarding. |
| Returns `Left(failure)` when repo does | Failure path forwarding. No logic transforms the failure — we pin that in place. |
| Calls `getComplaintTypes()` exactly once (+ no other interactions) | Use case isn't accidentally calling a second method or calling the same one twice. |

Three tests is the floor for any use case: happy, sad, call count. Every use case in this project (`GetComplaintUseCase`, `AddComplaintUseCase`, `GetNotificationUseCase`, `MarkAllReadUseCase`, `GetMenuUseCase`, `LoginUseCase`, …) has the same shape — you can copy this file and port it in under a minute.

### List equality subtlety

`ComplaintTypeEntity` extends `Equatable` with all fields in `props`. That makes `==` value-based: two `ComplaintTypeEntity(id: 1, ...)` instances are equal even if they're different objects. `List<T>` propagates element `==` via Dart's `ListEquality` (which Flutter's `expect` uses internally), so:

```dart
const types = [
  ComplaintTypeEntity(id: 1, nameEn: 'Leakage', nameNp: 'चुहावट'),
  ComplaintTypeEntity(id: 2, nameEn: 'Blockage', nameNp: 'अवरोध'),
];
expect(result, const Right<Failure, List<ComplaintTypeEntity>>(types));
```

…just works. If an entity forgot to extend `Equatable`, identity comparison would kick in and this test would fail despite the content matching. So when you write new entities, **always extend `Equatable` + list every field in `props`** or tests become painful.

### When you'd need `registerFallbackValue`

Not here. `getComplaintTypes()` takes no arguments. But when you're stubbing a method with arguments and you want `any()` to match any value:

```dart
when(() => repository.submit(any())).thenAnswer(...);
```

…mocktail needs to know how to construct a fallback value of the parameter type. You register it once in `setUpAll`:

```dart
setUpAll(() {
  registerFallbackValue(const AddComplaintRequest());  // or whatever the param type is
});
```

`setUpAll` runs **once** for the file (not per test) — registration is a one-shot. You'll hit this in Milestone 4 when the cubit tests call use cases that take arguments.

### Run it

```bash
flutter test -r expanded test/features/complaint/domain/usecases/get_complaint_types_usecase_test.dart
# → 3 tests, all passing
```

---

## Milestone 4 — Cubit state machine with `bloc_test`

**Target:** `lib/features/complaint/presentation/cubit/complaint_cubit.dart`
**Test file:** `test/features/complaint/presentation/cubit/complaint_cubit_test.dart` (3 tests)

`ComplaintCubit` is 21 lines. One method (`getComplaints()`) emits `loading` immediately, awaits the use case, then emits `loaded(data)` on `Right` or `error(failure)` on `Left`. Three tests pin the entire state machine: initial state, happy path, sad path.

This is the first milestone where we test a **stream of states**, not a return value. `bloc_test` (built on top of `flutter_test`) gives us `blocTest<Cubit, State>(...)` — a higher-level matcher that pumps the cubit, waits for emissions to settle, and asserts the exact ordered sequence of states.

### What's new in this milestone

| Concept | Syntax |
|---------|--------|
| Pull in `bloc_test` | `import 'package:bloc_test/bloc_test.dart';` |
| State-machine test | `blocTest<ComplaintCubit, ComplaintState>('name', build: ..., act: ..., expect: ...)` |
| Stub the use case | `when(() => mockUseCase.call()).thenAnswer((_) async => const Right(data))` |
| Build the cubit fresh | `build: () => ComplaintCubit(getComplaintUseCase: mockUseCase)` |
| Trigger the method | `act: (cubit) => cubit.getComplaints()` |
| Assert emitted states (in order) | `expect: () => [ComplaintState.loading(), ComplaintState.loaded(...)]` |
| Register a fallback for `any()` | `setUpAll(() { registerFallbackValue(const ComplaintEntity(...)); })` |
| Freezed state equality | `const ComplaintState.loaded(list) == const ComplaintState.loaded(list)` works because freezed generates value-based `==` |

### `blocTest` — what it actually does

```dart
blocTest<ComplaintCubit, ComplaintState>(
  'emits [loading, loaded] when getComplaints succeeds',
  build: () {
    when(() => mockUseCase.call()).thenAnswer((_) async => const Right(data));
    return ComplaintCubit(getComplaintUseCase: mockUseCase);
  },
  act: (cubit) => cubit.getComplaints(),
  expect: () => [
    const ComplaintState.loading(),
    const ComplaintState.loaded(data),
  ],
);
```

What happens, step by step:

1. **`build:`** runs first. Stub the mock, return a *fresh* cubit. Each `blocTest` gets its own cubit instance — no leaked emissions between tests.
2. **`act:`** runs once the cubit is built. Trigger the method under test. `bloc_test` listens to `cubit.stream` from this point.
3. The cubit's `emit(...)` calls flow through the stream.
4. After `act` settles (all `await`s in the cubit complete), `bloc_test` collects every state that was emitted.
5. **`expect:`** asserts the collected list equals the expected list, **in order**, by `==`.
6. The cubit is closed automatically — no manual `cubit.close()` needed.

If you've ever tried to test a cubit by manually calling `cubit.stream.listen(...)` and bookkeeping a list, `blocTest` is the boilerplate-free version.

### Why `setUpAll` + `registerFallbackValue`

```dart
setUpAll(() {
  registerFallbackValue(
    const ComplaintEntity(
      complainId: 0,
      complainTypeId: 0,
      complainTypeEn: '',
      // ... all required fields
    ),
  );
});
```

`mocktail` lets you stub argument-matchers like `when(() => mock.submit(any()))` — `any()` says "match anything for this position." But `mocktail` needs a sample object of the parameter type to construct its internal matcher. You provide it via `registerFallbackValue` **once** in `setUpAll`.

In `complaint_cubit_test.dart`, no `any()` matcher is actually used (the success stub returns a hardcoded `Right(data)`, the failure stub returns a hardcoded `Left(NetworkFailure())`). The `registerFallbackValue` here is precautionary — the file's author left it in case a future test wants to match `any<ComplaintEntity>()`. Harmless, but you could delete it without breaking anything **today**.

You'll need it for real in tests where the cubit calls a method **with arguments**. Example: testing `AddComplaintCubit.addComplaint(...)` would mock `AddComplaintUseCase` and want `when(() => mock.call(any())).thenAnswer(...)` — that requires `registerFallbackValue(const AddComplaintRequest(...))` in `setUpAll`.

`setUpAll` runs **once for the entire file**, before any `setUp`. Use it for one-shot setup that doesn't need fresh state per test (registration, suite-wide constants).

### Freezed state equality

`ComplaintState` is a freezed sealed union:

```dart
@freezed
class ComplaintState with _$ComplaintState {
  const factory ComplaintState.initial() = _Initial;
  const factory ComplaintState.loading() = _Loading;
  const factory ComplaintState.loaded(List<ComplaintEntity> data) = _Loaded;
  const factory ComplaintState.error(Failure failure) = _Error;
}
```

Freezed auto-generates `==` and `hashCode` based on the constructor args. Two `ComplaintState.loading()` are `==` because both are `_Loading` instances with no fields. Two `ComplaintState.loaded([entity1])` are `==` if the lists contain `==` elements (which is true because `ComplaintEntity` extends `Equatable` and lists fall through to element equality).

This means your `expect:` argument can use literal state-constructors:

```dart
expect: () => [
  const ComplaintState.loading(),
  const ComplaintState.error(NetworkFailure()),
],
```

…and the assertion will pass when the cubit emits the same shapes. No custom matchers, no `isA<>` walking, no field-by-field comparison.

If a state isn't matching when you think it should: check that **every** field of every entity inside the state is `==`-able. A nested object that doesn't extend `Equatable` (or override `==`) will silently fail equality even when the displayed fields look identical.

### Why three tests is the floor for a cubit

| Test | What it proves |
|------|----------------|
| `initial state is ComplaintState.initial()` | Constructor seeds the state correctly. Catches `super(const ComplaintState.loading())` typos. |
| Success: emits `[loading, loaded]` | Happy-path state sequence. Catches "forgot to emit loading" and "swallowed the success". |
| Failure: emits `[loading, error]` | Sad-path state sequence. Catches "treated failure as success" and "didn't include loading first". |

Three tests, three minutes per cubit. Every other cubit (`MenuCubit`, `StatementCubit`, `ProfileCubit`) has the same `loading → loaded | error` shape — copy this file, swap the use-case mock and entity, ship.

For cubits with multiple methods (`AuthCubit.login` + `logout`, `NotificationCubit.markAsRead` + `markAsUnread` + `markAllAsRead`), repeat the pattern per method. Milestone 5 shows the multi-method case.

### One-test-per-`blocTest` vs grouped

`bloc_test` doesn't have a `group:` parameter. To group related tests, use the standard `flutter_test` `group(...)` and put `blocTest`s inside:

```dart
group('getComplaints', () {
  blocTest(...);  // success
  blocTest(...);  // failure
});
```

The `complaint_cubit_test.dart` file is small enough that flat top-level tests work fine. As cubits grow, group by method name.

### Run it

```bash
flutter test -r expanded test/features/complaint/presentation/cubit/complaint_cubit_test.dart
# → 3 tests, all passing
```

---

## Milestone 5 — Seeded state, optimistic updates, and the dedup quirk

**Target:** `lib/features/notification/presentation/cubit/notification_cubit.dart`
**Test file:** `test/features/notification/presentation/cubit/notification_cubit_test.dart` (5 tests)

`NotificationCubit` has three mutation methods (`markAsRead`, `markAsUnread`, `markAllAsRead`) that **only do anything if the cubit is already in `loaded(list)` state** — they project the API success onto the cached list. Testing them from `initial` would prove nothing because the `state.whenOrNull(loaded: ...)` guard would short-circuit.

The new tool: **`seed:`** — `bloc_test`'s mechanism for placing the cubit in a specific starting state before `act:` runs.

### What's new in this milestone

| Concept | Syntax |
|---------|--------|
| Start from a non-initial state | `seed: () => NotificationState.loaded(makePage(items: [...], unreadCount: 1))` |
| Helper to build test data | `NotificationPageEntity makePage({required List<NotificationEntity> items, int unreadCount = 0}) { ... }` |
| Multiple `blocTest`s exercising the same cubit | Each test re-runs `setUp` (fresh mocks) and `build` (fresh cubit) — no state leaks |
| Failure preserves prior state | `expect: () => [const NotificationState.error(NetworkFailure())]` — only one emission, list isn't touched |
| Dedup quirk | `Cubit.emit` skips emissions where new state `==` current state (Equatable + freezed) |

### `seed:` — pre-loading the state machine

```dart
blocTest<NotificationCubit, NotificationState>(
  'markAsRead on unread item: emits loaded with isRead=true and unreadCount-1',
  seed: () => NotificationState.loaded(
    makePage(
      items: [
        makeNotification(id: 1, isRead: false),
        makeNotification(id: 2, isRead: true),
      ],
      unreadCount: 1,
    ),
  ),
  build: () {
    when(() => mockMarkRead.call('1')).thenAnswer((_) async => const Right(null));
    return NotificationCubit(...);
  },
  act: (cubit) => cubit.markAsRead('1'),
  expect: () => [
    NotificationState.loaded(
      makePage(items: [
        makeNotification(id: 1, isRead: true),  // ← flipped
        makeNotification(id: 2, isRead: true),
      ]),
      // unreadCount: 0 implied (default 0)
    ),
  ],
);
```

`bloc_test` calls `seed()` before recording any emissions, so the cubit lands in `loaded(...)` and *that* state is **not** counted in the emission list. Only states emitted **after** `act:` show up in `expect:`.

This is a critical mental model: the seed isn't an emission, it's the starting position.

### Test-data helpers

```dart
NotificationPageEntity makePage({
  required List<NotificationEntity> items,
  int unreadCount = 0,
}) => NotificationPageEntity(items: items, unreadCount: unreadCount);

NotificationEntity makeNotification({
  required int id,
  required bool isRead,
  String title = 'Test',
}) => NotificationEntity(
  id: id,
  title: title,
  message: 'msg',
  isRead: isRead,
  moduleType: 'modulee',
  createdAtHuman: '1.4 mins ago',
);
```

Why factories matter: real entities have 6+ required fields. Without these, every test would have 30 lines of constructor calls. Factories pin the shape with **defaults that don't matter for the test** (`title`, `message`, `moduleType`) and let the test override the **fields that do matter** (`id`, `isRead`).

Rule of thumb: the moment you write the same entity twice in two tests, extract a `make...` factory. It pays for itself within 3 tests.

### One file, five `blocTest`s, one cubit type

```dart
test('initial state is NotificationState.initial()', () { ... });

blocTest<NotificationCubit, NotificationState>(
  'markAsRead on unread item: ...',
  seed: ..., build: ..., act: ..., expect: ...,
);

blocTest<NotificationCubit, NotificationState>(
  'markAsRead on already-read item: unreadCount unchanged',
  seed: ..., build: ..., act: ..., expect: ...,
);

blocTest<NotificationCubit, NotificationState>(
  'markAsUnread on read item: ...',
);

blocTest<NotificationCubit, NotificationState>(
  'markAllAsRead: all items isRead=true and unreadCount=0',
);

blocTest<NotificationCubit, NotificationState>(
  'markAsRead failure: emits error, items unchanged',
  // ...
  build: () {
    when(() => mockMarkRead.call('1'))
        .thenAnswer((_) async => const Left(NetworkFailure()));
    return NotificationCubit(...);
  },
  act: (cubit) => cubit.markAsRead('1'),
  expect: () => [
    const NotificationState.error(NetworkFailure()),
  ],
);
```

Each `blocTest` runs `setUp` first (fresh mocks via `mockMarkRead = MockMarkIndividualUseCase()`), then `build` (fresh cubit). No state leaks between tests — even though they all hit the same cubit class, there's no shared instance.

The **failure path is one emission**, not two. The cubit's success branch has `state.whenOrNull(loaded: ...)` guarding the projection, but the failure branch directly `emit(NotificationState.error(failure))` — no `loading` first because optimistic-update methods don't show a loading shimmer (the user already sees the data; they just see the change apply on success or a snackbar on failure).

### The dedup quirk — a real foot-gun

`Cubit.emit(newState)` checks `if (newState == state) return;` before emitting. This is a `bloc` library guard against redundant rebuilds — same state in, same state out, no-op. It's correct behavior and you usually want it.

But it bites tests. Look at this case:

```dart
blocTest<NotificationCubit, NotificationState>(
  'markAsRead on already-read item: unreadCount unchanged (no double-decrement)',
  seed: () => NotificationState.loaded(
    makePage(items: [makeNotification(id: 1, isRead: true)]),  // already read!
  ),
  build: () {
    when(() => mockMarkRead.call('1')).thenAnswer((_) async => const Right(null));
    return NotificationCubit(...);
  },
  act: (cubit) => cubit.markAsRead('1'),
  expect: () => [
    NotificationState.loaded(
      makePage(items: [makeNotification(id: 1, isRead: true)]),  // unchanged
    ),
  ],
);
```

Reading the cubit's `_projectItemRead` helper: when the item is already read, `wasUnread = false`, the mapped item is `copyWith(isRead: true)` of an already-read item (no change), and `unreadCount` stays the same. The new state is **value-equal** to the seed.

`Cubit.emit` sees `newState == seed`, skips the emission. The test's collected list is `[]`, but `expect:` claims `[loaded(...)]`. **Test fails** — `Expected: [loaded(...)] / Actual: []`.

This is **not a bug in the cubit** — the dedup is correct (rebuilding on no-op state would just trigger UI churn). It's a quirk in the test expectation. Two ways to write this test correctly:

1. Make the seed *meaningfully different* from the result. E.g., the seed has `unreadCount: 1` and the test asserts the result has `unreadCount: 0` — values differ → emit fires → test passes.
2. Drop this test. The "no double-decrement" property is already proven by the unread-item test (which asserts `unreadCount: 0` after the first decrement; running it twice would still give 0 because the second call is a no-op).

The current `complaint_cubit_test.dart` keeps this failing test in place as a **known pre-existing quirk** (documented in `CHANGES.md` 2026-04-27). When you run `flutter test`, you'll see `+30 -1` — that's the one. Don't "fix" it by adding `skip: true` to bypass; either reshape the test (option 1) or delete it (option 2). Skipping hides the lesson.

### Failure tests — assert one emission, not two

The success branch goes `loading? → loaded → projected_loaded`, but optimistic-update cubits **don't emit `loading`** for mark-as-read (the user is already looking at the list; flashing a shimmer would be jarring). So:

```dart
expect: () => [
  // No loading state — just the error
  const NotificationState.error(NetworkFailure()),
],
```

If a future contributor adds `emit(NotificationState.loading())` at the top of `markAsRead`, this test would fail because the actual list would be `[loading, error]` and the expected is `[error]`. That's a feature: the test pins the no-shimmer-on-mutation contract.

For methods that **do** emit loading (e.g., `getNotifications`), the test asserts `[loading, error]`. The cubit's contract dictates the test shape, not the other way around.

### Why the helpers don't need their own tests

`_projectAllRead`, `_projectItemRead`, `_projectItemUnread` are **private** functions in the cubit class. The state-machine tests cover their behavior end-to-end:

- "after `markAsRead('1')` from a state with item 1 unread, item 1 is read and `unreadCount` is decremented" exercises `_projectItemRead`.
- "after `markAllAsRead`, all items are read and `unreadCount: 0`" exercises `_projectAllRead`.

Adding direct unit tests for the helpers would duplicate coverage. If you ever extract them to a top-level function (e.g., for reuse in a different cubit), that's when they earn their own test file.

### Run it

```bash
flutter test -r expanded test/features/notification/presentation/cubit/notification_cubit_test.dart
# → 5 tests, 4 passing, 1 failing on the dedup quirk (intentional, see above)
```

---

## Milestone 6 — Widget testing a full screen with `MockCubit` + `pumpWidget`

**Target:** `lib/features/complaint/presentation/pages/complaint_screen.dart`
**Test file:** `test/features/complaint/presentation/pages/complaint_screen_test.dart` (6 tests)

`ComplaintScreen` is the first **widget test** — we render a real Flutter tree and verify the UI's reaction to specific cubit states. Unlike Milestones 4 and 5 (which assert *emitted states*), this milestone asserts *rendered widgets*: did the shimmer appear in loading? Did the right number of `ComplaintCard`s render in loaded? Did tapping the search icon reveal the `TextField`?

Picked this screen — not a single button — because it covers the full surface a real widget test has to handle: multiple cubits (`ComplaintCubit`, `ProfileCubit`, `NetworkCubit` via the auto-refresh mixin), shimmer / loaded / empty / error branches, an interactive search bar, and list filtering. Once this pattern clicks, every screen in the app is testable with the same scaffolding.

### What's new in this milestone

| Concept | Syntax |
|---------|--------|
| Widget test entry | `testWidgets('name', (tester) async { ... })` |
| Cubit mock subclass | `class MockComplaintCubit extends MockCubit<ComplaintState> implements ComplaintCubit {}` |
| Stub cubit state stream | `whenListen(mock, Stream<ComplaintState>.empty(), initialState: ComplaintState.loading())` |
| Stub a cubit method that returns Future | `when(() => cubit.getComplaints()).thenAnswer((_) async {})` |
| Stub a non-Bloc collaborator's stream | `when(() => networkCubit.onRecoveryStream).thenAnswer((_) => const Stream<void>.empty())` |
| Pump the widget | `await tester.pumpWidget(buildHarness())` |
| Settle one frame | `await tester.pump()` |
| Find widgets | `find.byType(Shimmer)`, `find.text('No complaints yet')`, `find.bySemanticsLabel('Search complaints')`, `find.byType(ComplaintCard)` |
| Count assertion | `findsOneWidget`, `findsNothing`, `findsNWidgets(3)`, `findsWidgets` |
| Simulate tap | `await tester.tap(finder); await tester.pump();` |
| Simulate text entry | `await tester.enterText(finder, 'leak'); await tester.pump();` |

### `MockCubit` vs `MockBloc` vs `Mock`

`MockCubit<S>` (from `bloc_test`) is the right tool when you need to **inject** a cubit into a widget tree. It:
- Implements the same `BlocBase<S>` interface as a real cubit, so `BlocProvider<ComplaintCubit>.value(value: mock)` type-checks.
- Plays a controlled stream of states via `whenListen(mock, stream, initialState: ...)`.
- Answers `mock.state` synchronously from the seeded `initialState` (and from subsequent values played through the stream).

```dart
class MockComplaintCubit extends MockCubit<ComplaintState>
    implements ComplaintCubit {}
```

Two parents:
1. `extends MockCubit<ComplaintState>` — gets the Bloc-compatible stub machinery.
2. `implements ComplaintCubit` — declares the same interface so `BlocProvider<ComplaintCubit>` accepts the mock.

This is *different* from the `Mock` we used for use-case mocks in Milestones 3-5. `Mock` is mocktail's general-purpose mock; `MockCubit` is a Bloc-aware specialization that handles the stream + state mechanics for you.

### `whenListen` — playing a controlled state sequence

```dart
whenListen(
  complaintCubit,
  const Stream<ComplaintState>.empty(),
  initialState: const ComplaintState.loaded([]),
);
```

- The `initialState:` is what `cubit.state` returns immediately after pump — what `BlocBuilder.builder` will see on the first frame.
- The stream argument is what `cubit.stream` will emit after pump. `Stream.empty()` means no further state changes — ideal for "test how the screen looks in this *one* state."
- For multi-state tests (e.g. "renders shimmer first, then card list"), pass `Stream.fromIterable([loading, loaded(...)])` and `pumpAndSettle` between assertions.

Each `testWidgets` gets a fresh mock from `setUp`, so leftover stubs from a prior test never leak.

### Stubbing methods the screen calls in `initState`

```dart
when(() => complaintCubit.getComplaints()).thenAnswer((_) async {});
```

`ComplaintScreen.initState` fires `getComplaints()` in a `postFrameCallback`. A `MockCubit` returns `null` for unstubbed methods — for a `Future<void>` return, that's `null is Future<void>` which throws `_TypeError: type 'Null' is not a subtype of type 'Future<void>'`. The fix is one stub: have the mock return a completed future. The mock won't really fetch anything (we don't want it to — we're driving state via `whenListen`), but it satisfies the type contract.

Same trick applies to other side effects the screen kicks off: any cubit method or stream getter the widget reads on first build needs a stub.

### Stubbing the `NetworkAutoRefreshMixin`'s recovery stream

`ComplaintScreen` mixes in `NetworkAutoRefreshMixin`, which subscribes to `context.read<NetworkCubit>().onRecoveryStream` in `initState`. In production, `NetworkCubit` checks connectivity via platform plugins (`connectivity_plus`, `internet_connection_checker_plus`) — those don't work in widget tests and crash with `MissingPluginException`.

The fix: provide a `MockNetworkCubit` and stub the getter to return an empty stream:

```dart
class MockNetworkCubit extends MockCubit<NetworkStatus>
    implements NetworkCubit {}

when(() => networkCubit.onRecoveryStream)
    .thenAnswer((_) => const Stream<void>.empty());
```

The mixin subscribes to nothing and never fires `onNetworkRestored()`. Test stays focused on the screen's UI logic, not network plumbing.

Use this pattern for any platform-plugin cubit (FCM, location, biometrics): mock the cubit, stub the streams/methods to return inert defaults.

### The harness — `MaterialApp` + `Localizations` + `ScreenUtilInit` + `MultiBlocProvider`

```dart
Widget buildHarness() {
  return ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (_, _) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ComplaintCubit>.value(value: complaintCubit),
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<NetworkCubit>.value(value: networkCubit),
        ],
        child: const ComplaintScreen(),
      ),
    ),
  );
}
```

Every layer matters and each one corresponds to something the screen *uses*:

- **`ScreenUtilInit`** — required because `flutter_screenutil`'s `.h` / `.w` / `.r` extensions need a context-aware initializer. Without it, the first `36.h` access crashes. `designSize` is the reference design (matches `main_common.dart`'s `Size(393, 852)`).
- **`MaterialApp`** — provides `Theme`, `Directionality`, `MediaQuery`, and `Navigator`. Without it, even `Text` won't render.
- **`localizationsDelegates` + `supportedLocales`** — required because the screen calls `AppLocalizations.of(context).noComplaintsYet`. Reuse the generated lists from `app_localizations.dart`.
- **`theme: AppTheme.light`** — the screen reads `context.appColors.surface`, etc., via the `AppColorsExtension`. The light theme registers it. Skip this and `context.appColors` returns null and crashes.
- **`MultiBlocProvider.value`** — `.value` (not the default constructor) lets the test own the cubit's lifecycle. The default constructor would close the cubit at widget disposal, which can race with the test's `whenListen` stream.

The harness is verbose for a reason: every layer maps to something the screen genuinely needs. Strip a layer and the test will surface a specific, fixable error.

### Six scenarios — the floor for a screen test

| Test | What it proves |
|------|----------------|
| `shows shimmer while ComplaintCubit is loading` | Loading-state UI renders. `find.byType(Shimmer)` finds the shimmer block; `findsNothing` for `ComplaintCard` confirms the loaded UI isn't leaked in. |
| `shows the empty-state copy when loaded with no complaints` | Loaded-with-empty branch — exercises `if (filtered.isEmpty)`. **Caught a real production bug here**: the empty branch had `Padding(child: Expanded(...))` instead of `Expanded(child: Padding(...))`. The test failed with `Incorrect use of ParentDataWidget` until the production code was swapped to put `Expanded` directly under the `Column`. |
| `renders one ComplaintCard per item when loaded` | Loaded-with-data branch — `findsNWidgets(3)` pins the count, `findsNothing` for empty-state text confirms branches are mutually exclusive. |
| `renders inline error message when ComplaintCubit fails (non-network)` | Error branch — uses `ApiFailure('Server rejected your filter', 422)` so the failure is *not* a connectivity error and is *not* a 404, so the screen falls into the inline error path (not the full-screen `AppErrorPage`). Asserts the `failure.message` text appears. |
| `tapping the search icon reveals the search field` | Search bar interaction. Pre-tap: `find.byType(TextField)` is `findsNothing`. Tap. Pump. Post-tap: `findsOneWidget`. Locating the icon by `find.bySemanticsLabel('Search complaints')` is more robust than `find.byIcon(Icons.search)` because the icon is rendered as an SVG, not a Material icon. |
| `typing in the search filters the visible cards` | End-to-end interaction: open search, type 'leak', verify only the `ComplaintCard` whose `complainTypeEn` or `complainEn` contains 'leak' (case-insensitive) remains. |

That's the recipe: one test per state branch, one per interaction. Other screens follow the same shape — copy the harness, swap the cubits, repeat.

### Catching real bugs — why widget tests earn their cost

`Padding(child: Expanded(...))` had been in production for weeks and never crashed because users always saw at least one complaint when the screen loaded. The empty state was unreachable in normal use. Adding the empty-state widget test surfaced the bug on the **first run** of the test:

```
══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞══
Incorrect use of ParentDataWidget.
The ParentDataWidget Expanded(flex: 1) wants to apply ParentData of type FlexParentData to a
RenderObject, which has been set up to accept ParentData of incompatible type BoxParentData.
The offending Expanded is currently placed inside a Padding widget.
```

The fix was a one-block reorder in `complaint_screen.dart` (commit logged in `CHANGES.md` 2026-04-27). This is the value proposition of widget tests: they exercise rendering branches that happen rarely in real use, where bugs hide for months.

### `findsOneWidget` vs `findsWidgets`

| Matcher | Asserts |
|---------|---------|
| `findsOneWidget` | exactly 1 |
| `findsNothing` | 0 |
| `findsNWidgets(N)` | exactly N |
| `findsWidgets` | ≥ 1 (any count) |
| `findsAtLeastNWidgets(N)` | ≥ N |

For shimmer tests, prefer `findsWidgets` — the screen often renders multiple `Shimmer.fromColors` instances (header shimmer + body shimmer). Pinning to a specific count is brittle. For card counts where the count itself is the assertion (3 complaints → 3 cards), use `findsNWidgets`.

### `tester.pump` vs `pumpAndSettle`

- `pump()` advances by one frame. Use after a single state change or interaction.
- `pump(Duration)` advances by N milliseconds. Use to exercise animations.
- `pumpAndSettle()` pumps until no more frames are scheduled. Use when an animation, debounce, or async completion needs to finish.

The `ComplaintScreen` tests use `pump()` because none of the assertions depend on animations completing. If a test asserts a `BouncingScrollPhysics` settle, switch to `pumpAndSettle`.

### Run it

```bash
flutter test -r expanded test/features/complaint/presentation/pages/complaint_screen_test.dart
# → 6 tests, all passing
```

---

## What comes next

The milestones cover the four layers a Flutter app actually needs tested:

1. **Pure functions** (extensions, helpers) — Milestone 1.
2. **Async + branch coverage** (mappers, error handling) — Milestone 2.
3. **Use cases** with mocked repositories — Milestone 3.
4. **Cubits** with `bloc_test` — Milestones 4 (linear flow) and 5 (seeded state, optimistic updates).
5. **Widgets/screens** with `pumpWidget` + `MockCubit` — Milestone 6.

What's not covered yet:
- **Datasources** with mocked Dio (`MockDio extends Mock implements Dio` + stub `dio.get/post`). Same pattern as Milestone 3 but one layer deeper. Useful for catching response-parsing bugs.
- **Integration tests** (`flutter test integration_test/...`) that exercise the real cubit + real repositories against a fake HTTP server. Higher cost, higher confidence; reserve for golden-path flows like login and complaint-submission.
- **Golden tests** (`matchesGoldenFile(...)`) for visual regression. Run them in CI on a fixed device profile. Worth it for design-heavy widgets like `ComplaintCard` once the design stabilizes.

Pick targets based on where bugs hurt most. Cubit tests catch state-machine regressions; widget tests catch rendering regressions; datasource tests catch contract-drift between the app and the backend. They aren't substitutes for each other — each layer fails in different ways.

---

## Cheat sheet

```bash
# all tests, default reporter
flutter test

# all tests, expanded reporter (see every name)
flutter test -r expanded

# one file
flutter test test/core/extension/nepali_converter_extension_test.dart

# one test by substring
flutter test --plain-name "multi-digit"

# one test by regex
flutter test --name "^NepaliNumber.*digit"

# watch mode isn't built-in — rerun manually, or use IDE test runners
```

| Concept | Syntax |
|---------|--------|
| Group | `group('name', () { ... })` |
| Single test | `test('name', () { ... })` |
| Async test | `test('name', () async { ... })` |
| Value assertion | `expect(actual, expected)` |
| Type assertion | `expect(obj, isA<Foo>())` |
| Exception assertion | `await expectLater(future, throwsA(isA<Foo>()))` |
| Exception + field check | `throwsA(isA<Foo>().having((f) => f.code, 'code', 42))` |
| Setup per test | `setUp(() { ... })` |
| Teardown per test | `tearDown(() { ... })` |
| Setup once | `setUpAll(() { ... })` |

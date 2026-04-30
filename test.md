# Testing curriculum

A short, ordered set of test patterns. Each one lands one tool and one habit. The starter ships three reference tests:

| File | What it teaches |
|------|----------------|
| `test/core/extension/string_extension_test.dart` | Plain `flutter_test` on a pure function. |
| `test/core/utils/safe_request_mapper_test.dart` | Async tests + branch coverage on a mapper that handles many error cases. |
| `test/features/demo/presentation/cubit/demo_cubit_test.dart` | `bloc_test` on a Cubit's state stream — `build`, `act`, `expect`. |

Each milestone explains one new concept. Once a pattern clicks, every other use case / cubit / screen in your project follows the same shape — copy the file, swap the names.

---

## Milestone 1 — Pure function, no Flutter

**Target:** `lib/core/extension/string_extension.dart`
**Test file:** `test/core/extension/string_extension_test.dart` (3 tests)

`StringExtension.capitalize()` is one line — but a one-line function still has three behaviors worth pinning: input that's already capitalized, input that's all caps, and the typical lowercase input. Three tests, three minutes.

### What's new in this milestone

| Concept | Syntax |
|---------|--------|
| Test entry point | `import 'package:flutter_test/flutter_test.dart';` |
| Group-level setup | `group('name', () { ... })` |
| Single test | `test('name', () { ... })` |
| Value assertion | `expect(actual, expected)` |

### Why this is the floor

Three tests for a one-liner sounds like overkill. It isn't. Each test pins **one decision** the function makes:

- `'flutter'.capitalize()` → `'Flutter'` — typical case.
- `'Flutter'.capitalize()` → `'Flutter'` — already capitalized; the function shouldn't mangle it.
- `'FLUTTER'.capitalize()` → `'Flutter'` — all caps; the tail must lowercase.

Anything else you write afterwards is just more of this same pattern.

### Run it

```bash
flutter test -r expanded test/core/extension/string_extension_test.dart
# → 3 tests, all passing
```

---

## Milestone 2 — Async + exceptions + branch coverage

**Target:** `lib/core/utils/safe_request_mapper.dart`
**Test file:** `test/core/utils/safe_request_mapper_test.dart`

`SafeRequest.call(...)` wraps every datasource call. It catches Dio's typed exceptions and maps them to typed `Failure` subclasses (`NetworkFailure`, `ApiFailure`, `ServerFailure`, `AuthFailure`, `CacheFailure`). The test covers each input → output mapping plus the happy path.

### What's new in this milestone

| Concept | Syntax |
|---------|--------|
| Async test | `test('name', () async { ... })` |
| Exception assertion | `await expectLater(future, throwsA(isA<Failure>()))` |
| Exception + field check | `throwsA(isA<ApiFailure>().having((f) => f.statusCode, 'statusCode', 404))` |
| Pass-through happy path | `expect(await SafeRequest.call(() async => 42), 42)` |

### Why this matters

A mapper test is the **cheapest insurance** in the codebase. Every datasource you add depends on `SafeRequest.call(...)` producing the right `Failure` subtype. If that mapping drifts (someone adds a new Dio exception case and routes it to the wrong `Failure`), every cubit's error branch lies. Pin the mapping once, sleep well.

### Run it

```bash
flutter test -r expanded test/core/utils/safe_request_mapper_test.dart
```

---

## Milestone 3 — Cubit state machine with `bloc_test`

**Target:** `lib/features/demo/presentation/cubit/demo_cubit.dart`
**Test file:** `test/features/demo/presentation/cubit/demo_cubit_test.dart` (3 tests)

`DemoCubit` has one method (`getDemos()`) that emits `loading` immediately, awaits the use case, then emits `loaded(data)` on `Right` or `error(failure)` on `Left`. Three tests pin the entire state machine.

This is the first milestone where we test a **stream of states**. `bloc_test` (built on `flutter_test`) gives us `blocTest<Cubit, State>(...)` — a higher-level matcher that pumps the cubit, lets emissions settle, and asserts the exact ordered sequence of states.

### What's new in this milestone

| Concept | Syntax |
|---------|--------|
| Pull in `bloc_test` | `import 'package:bloc_test/bloc_test.dart';` |
| Mock the use case | `class MockGetDemosUseCase extends Mock implements GetDemosUseCase {}` |
| Stub the use case | `when(() => mock.call()).thenAnswer((_) async => const Right(data))` |
| Build the cubit fresh | `build: () => DemoCubit(getDemosUseCase: mockUseCase)` |
| Trigger the method | `act: (cubit) => cubit.getDemos()` |
| Assert emitted states | `expect: () => [DemoState.loading(), DemoState.loaded(...)]` |
| Freezed state equality | `const DemoState.loaded(list) == const DemoState.loaded(list)` works because freezed generates value-based `==` |

### `blocTest` — what it actually does

```dart
blocTest<DemoCubit, DemoState>(
  'emits [loading, loaded] when getDemos succeeds',
  build: () {
    when(() => mockUseCase.call()).thenAnswer((_) async => const Right(data));
    return DemoCubit(getDemosUseCase: mockUseCase);
  },
  act: (cubit) => cubit.getDemos(),
  expect: () => [
    const DemoState.loading(),
    const DemoState.loaded(data),
  ],
);
```

Step by step:

1. **`build:`** runs first. Stub the mock, return a *fresh* cubit. Each `blocTest` gets its own cubit instance — no leaked emissions between tests.
2. **`act:`** runs once the cubit is built. Trigger the method under test. `bloc_test` listens to `cubit.stream` from this point.
3. The cubit's `emit(...)` calls flow through the stream.
4. After `act` settles (all `await`s in the cubit complete), `bloc_test` collects every state that was emitted.
5. **`expect:`** asserts the collected list equals the expected list, **in order**, by `==`.
6. The cubit is closed automatically — no manual `cubit.close()` needed.

### Three tests is the floor for a cubit

| Test | What it proves |
|------|----------------|
| `initial state is DemoState.initial()` | Constructor seeds the state correctly. Catches `super(const DemoState.loading())` typos. |
| Success: emits `[loading, loaded]` | Happy-path state sequence. Catches "forgot to emit loading" and "swallowed the success". |
| Failure: emits `[loading, error]` | Sad-path state sequence. Catches "treated failure as success" and "didn't include loading first". |

Three tests, three minutes per cubit. Every other cubit (`AuthCubit`, `YourFeatureCubit`) follows the same shape — copy this file, swap the use-case mock and entity, ship.

For cubits with multiple methods, repeat the pattern per method.

### `setUp` for fresh state per test

```dart
late MockGetDemosUseCase mockUseCase;

setUp(() {
  mockUseCase = MockGetDemosUseCase();
});
```

`setUp(...)` runs before each `test(...)` and `blocTest(...)` in the file. Fresh mock per test = no leaked stubs or call counts between tests. This is the single most important habit in stateful testing.

### When you'd need `registerFallbackValue`

Mocktail lets you stub argument-matchers like `when(() => mock.submit(any()))` — `any()` says "match anything for this position." But mocktail needs a sample object of the parameter type to construct its internal matcher. Register it once in `setUpAll`:

```dart
setUpAll(() {
  registerFallbackValue(const SomeRequest());
});
```

`setUpAll` runs **once** for the file (not per test). Use it for one-shot setup that doesn't need fresh state per test.

### Run it

```bash
flutter test -r expanded test/features/demo/presentation/cubit/demo_cubit_test.dart
```

---

## What comes next

The chassis ships three milestones. As your project grows, add tests for the layers you don't have yet:

- **Use case tests** — `class MockYourRepository extends Mock implements YourRepository {}` + a test verifying the use case forwards `Right(data)` and `Left(failure)` and calls the repo exactly once. Three tests per use case.
- **Optimistic-update tests** — when a cubit method mutates cached state (e.g., `markAsRead` flips a flag without re-fetching), use `seed:` in `bloc_test` to start from a `loaded(data)` state and assert the post-mutation state. Watch out for `Cubit.emit`'s equality dedup: if your projection produces a state value-equal to the seed, the emit is skipped and the test will see an empty emission list. Make the seed and the post-mutation state different in some observable field.
- **Widget tests** — `pumpWidget(...)` with `MockCubit<S>` from `bloc_test` injected via `BlocProvider.value`. Wrap with `MaterialApp` + `localizationsDelegates` + `ScreenUtilInit` so the screen renders without missing-context crashes. Use `find.byType(...)`, `find.text(...)`, `find.bySemanticsLabel(...)` to locate widgets. Use `await tester.tap(...)` / `await tester.enterText(...)` then `await tester.pump()` to simulate interaction. **Stub `Future<void>` cubit methods called in `initState`** — `when(() => cubit.fetchSomething()).thenAnswer((_) async {})` — or you'll hit `_TypeError: type 'Null' is not a subtype of type 'Future<void>'`.
- **Datasource tests** — `class MockDio extends Mock implements Dio {}` + stub `dio.get/post`. Useful for catching response-parsing bugs and contract drift between the app and the backend.
- **Integration tests** — `flutter test integration_test/...` exercising real cubits + real repositories against a fake HTTP server. Higher cost, higher confidence; reserve for golden-path flows like login.
- **Golden tests** — `matchesGoldenFile(...)` for visual regression. Run them in CI on a fixed device profile.

---

## Cheat sheet

```bash
# all tests, default reporter
flutter test

# all tests, expanded reporter
flutter test -r expanded

# one file
flutter test test/core/extension/string_extension_test.dart

# one test by substring
flutter test --plain-name "all-caps"

# one test by regex
flutter test --name "^StringExtension.*tail"
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
| Mock | `class MockX extends Mock implements X {}` |
| Stub async | `when(() => mock.call()).thenAnswer((_) async => result)` |
| Stub sync | `when(() => mock.value).thenReturn(value)` |
| Verify call | `verify(() => mock.call()).called(1)` |
| Cubit mock for widget tests | `class MockYCubit extends MockCubit<YState> implements YCubit {}` + `whenListen(mock, Stream.empty(), initialState: ...)` |
| `blocTest` | `blocTest<Cubit, State>('name', build: ..., act: ..., expect: ...)` |
| `blocTest` from non-initial state | add `seed: () => YState.loaded(...)` |

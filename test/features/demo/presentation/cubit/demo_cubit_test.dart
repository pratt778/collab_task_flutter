import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/demo/domain/entities/demo_entity.dart';
import 'package:collab_task/features/demo/domain/usecases/get_demos_usecase.dart';
import 'package:collab_task/features/demo/presentation/cubit/demo_cubit.dart';
import 'package:collab_task/features/demo/presentation/cubit/demo_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDemosUseCase extends Mock implements GetDemosUseCase {}

void main() {
  late MockGetDemosUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetDemosUseCase();
  });

  test('initial state is DemoState.initial()', () {
    final cubit = DemoCubit(getDemosUseCase: mockUseCase);
    expect(cubit.state, const DemoState.initial());
    cubit.close();
  });

  blocTest<DemoCubit, DemoState>(
    'emits [loading, loaded] when getDemos succeeds',
    build: () {
      when(() => mockUseCase.call()).thenAnswer(
        (_) async => const Right([
          DemoEntity(id: 1, title: 'first', body: 'body one'),
          DemoEntity(id: 2, title: 'second', body: 'body two'),
        ]),
      );
      return DemoCubit(getDemosUseCase: mockUseCase);
    },
    act: (cubit) => cubit.getDemos(),
    expect: () => [
      const DemoState.loading(),
      const DemoState.loaded([
        DemoEntity(id: 1, title: 'first', body: 'body one'),
        DemoEntity(id: 2, title: 'second', body: 'body two'),
      ]),
    ],
  );

  blocTest<DemoCubit, DemoState>(
    'emits [loading, error] when getDemos fails',
    build: () {
      when(
        () => mockUseCase.call(),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      return DemoCubit(getDemosUseCase: mockUseCase);
    },
    act: (cubit) => cubit.getDemos(),
    expect: () => [
      const DemoState.loading(),
      const DemoState.error(NetworkFailure()),
    ],
  );
}

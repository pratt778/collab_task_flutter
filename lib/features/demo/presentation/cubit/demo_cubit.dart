import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_starter/features/demo/domain/usecases/get_demos_usecase.dart';
import 'package:flutter_clean_starter/features/demo/presentation/cubit/demo_state.dart';

class DemoCubit extends Cubit<DemoState> {
  DemoCubit({required this.getDemosUseCase}) : super(const DemoState.initial());

  final GetDemosUseCase getDemosUseCase;

  Future<void> getDemos() async {
    emit(const DemoState.loading());

    final result = await getDemosUseCase.call();

    result.fold(
      (failure) => emit(DemoState.error(failure)),
      (data) => emit(DemoState.loaded(data)),
    );
  }
}

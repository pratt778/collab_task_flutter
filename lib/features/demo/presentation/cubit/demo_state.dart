import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_clean_starter/core/error/failures.dart';
import 'package:flutter_clean_starter/features/demo/domain/entities/demo_entity.dart';

part 'demo_state.freezed.dart';

@freezed
class DemoState with _$DemoState {
  const factory DemoState.initial() = _DemoInitial;
  const factory DemoState.loading() = _DemoLoading;
  const factory DemoState.loaded(List<DemoEntity> demos) = _DemoLoaded;
  const factory DemoState.error(Failure failure) = _DemoError;
}

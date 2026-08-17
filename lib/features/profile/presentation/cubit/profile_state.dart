import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/profile/domain/entities/profile_entity.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.loaded(ProfileEntity profile) = _Loaded;
  const factory ProfileState.updating(ProfileEntity profile) = _Updating;
  const factory ProfileState.error(
    Failure failure, [
    ProfileEntity? cachedProfile,
  ]) = _Error;
}

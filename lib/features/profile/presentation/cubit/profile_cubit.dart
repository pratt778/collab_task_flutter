import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:collab_task/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:collab_task/features/profile/presentation/cubit/profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileCubit(
    this.getProfileUseCase,
    this.updateProfileUseCase,
  ) : super(const ProfileState.initial());

  Future<void> loadProfile() async {
    emit(const ProfileState.loading());
    final result = await getProfileUseCase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(ProfileState.error(failure)),
      (profile) => emit(ProfileState.loaded(profile)),
    );
  }

  Future<bool> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    final currentProfile = state.maybeWhen(
      loaded: (p) => p,
      updating: (p) => p,
      error: (_, p) => p,
      orElse: () => null,
    );

    if (currentProfile != null) {
      emit(ProfileState.updating(currentProfile));
    } else {
      emit(const ProfileState.loading());
    }

    final result = await updateProfileUseCase(
      displayName: displayName,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
    );

    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(ProfileState.error(failure, currentProfile));
        return false;
      },
      (updatedProfile) {
        emit(ProfileState.loaded(updatedProfile));
        return true;
      },
    );
  }
}

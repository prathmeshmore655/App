import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadProfile);
    on<UpdateUserProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
      LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getUserProfile(event.token);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileUpdating());
    try {
      await repository.updateUserProfile(event.token, event.updatedData);
      emit(ProfileUpdated());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/user_repository.dart';
import 'package:medisync360/screens/User%20Screens/Profile/profile_event.dart';
import 'package:medisync360/screens/User%20Screens/Profile/profile_state.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await userRepository.fetchUserProfile();
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Data/Repositories/user_repository.dart';
import 'package:medisync360/Domain/Entities/User/user_entities.dart';
import 'package:medisync360/UI/User%20Screens/Profile/profile_event.dart';
import 'package:medisync360/UI/User%20Screens/Profile/profile_state.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<UserState> emit) async {
    emit(UserLoading());
    // try {
      final user = await userRepository.fetchUserProfile();
      emit(UserLoaded(user));
    // } catch (e) {
    //   emit(UserError(e.toString()));
    // }
  }
}

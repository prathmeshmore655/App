import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Data/Repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(const LoginState()) {
    on<LoginEmailChanged>((event, emit) {
      final username = event.username;
      final isUsernameValid = username.isNotEmpty;
      final isPasswordValid = state.password.isNotEmpty;
      final isValid = isUsernameValid && isPasswordValid;
      emit(state.copyWith(username: username, isValid: isValid));
    });

    on<LoginPasswordChanged>((event, emit) {
      final password = event.password;
      final isPasswordValid = password.isNotEmpty;
      final isUsernameValid = state.username.isNotEmpty;
      final isValid = isUsernameValid && isPasswordValid;

      print(isValid);
      emit(state.copyWith(password: password, isValid: isValid));
    });

    on<LoginUserTypeChanged>((event, emit) {
      emit(state.copyWith(userType: event.userType));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, errorMessage: null));
      try {
        await authRepository.login(state.username , state.password , state.userType);
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: e.toString(),
        ));
      }
    });
  }
}

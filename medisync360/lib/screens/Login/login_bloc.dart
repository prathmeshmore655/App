import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(const LoginState()) {
    on<LoginEmailChanged>((event, emit) {
      final email = event.email;
      final isValid = email.contains('@') && state.password.length >= 6;
      emit(state.copyWith(email: email, isValid: isValid));
    });

    on<LoginPasswordChanged>((event, emit) {
      final password = event.password;
      final isValid = state.email.contains('@') && password.length >= 6;
      emit(state.copyWith(password: password, isValid: isValid));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, errorMessage: null));
      try {
        await authRepository.login(state.email, state.password);
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

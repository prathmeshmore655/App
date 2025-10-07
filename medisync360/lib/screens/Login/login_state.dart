import 'package:equatable/equatable.dart';


class LoginState extends Equatable {
  final String username;
  final String password;
  final String userType; // 'User', 'Doctor', 'Hospital'
  final bool isValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;


  const LoginState({
    this.username = '',
    this.password = '',
    this.userType = 'User',
    this.isValid = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  LoginState copyWith({
    String? username ,
    String? password,
    String? userType,
    bool? isValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      userType: userType ?? this.userType,
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [username, password, userType, isValid, isSubmitting, isSuccess, errorMessage];
}

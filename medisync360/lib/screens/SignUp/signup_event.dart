import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupUsernameChanged extends SignupEvent {
  final String username;
  SignupUsernameChanged(this.username);

  @override
  List<Object?> get props => [username];
}

class SignupEmailChanged extends SignupEvent {
  final String email;
  SignupEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;
  SignupPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class SignupConfirmPasswordChanged extends SignupEvent {
  final String confirmPassword;
  SignupConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class SignupUserTypeChanged extends SignupEvent {
  final String userType;
  SignupUserTypeChanged(this.userType);

  @override
  List<Object?> get props => [userType];
}

class SignupProfileDataChanged extends SignupEvent {
  final String key;
  final dynamic value;
  SignupProfileDataChanged(this.key, this.value);

  @override
  List<Object?> get props => [key, value];
}

class FetchLocationRequested extends SignupEvent {}

class SignupSubmitted extends SignupEvent {}

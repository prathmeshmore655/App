import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String username;
  LoginEmailChanged(this.username);

  @override
  List<Object?> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}


class LoginUserTypeChanged extends LoginEvent {
  final String userType;
  LoginUserTypeChanged(this.userType);

  @override
  List<Object?> get props => [userType];
}

class LoginSubmitted extends LoginEvent {}

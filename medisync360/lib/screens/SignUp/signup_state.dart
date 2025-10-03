import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String userType;
  final Map<String, dynamic> profileData;
  final double? latitude;
  final double? longitude;

  final bool isValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const SignupState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.userType = 'user',
    this.profileData = const {},
    this.latitude,
    this.longitude,
    this.isValid = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  SignupState copyWith({
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    String? userType,
    Map<String, dynamic>? profileData,
    double? latitude,
    double? longitude,
    bool? isValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SignupState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      userType: userType ?? this.userType,
      profileData: profileData ?? this.profileData,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [username, email, password, confirmPassword, userType, profileData, latitude, longitude, isValid, isSubmitting, isSuccess, errorMessage];
}

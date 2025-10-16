import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/auth_repository.dart';
import 'signup_event.dart';
import 'signup_state.dart';
import 'package:geolocator/geolocator.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;

  SignupBloc({required this.authRepository}) : super(const SignupState()) {
    on<SignupUsernameChanged>((event, emit) {
      emit(state.copyWith(
        username: event.username,
        isValid: _validateForm(event.username, state.email, state.password, state.confirmPassword),
      ));
    });

    on<SignupEmailChanged>((event, emit) {
      emit(state.copyWith(
        email: event.email,
        isValid: _validateForm(state.username, event.email, state.password, state.confirmPassword),
      ));
    });

    on<SignupPasswordChanged>((event, emit) {
      emit(state.copyWith(
        password: event.password,
        isValid: _validateForm(state.username, state.email, event.password, state.confirmPassword),
      ));
    });

    on<SignupConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(
        confirmPassword: event.confirmPassword,
        isValid: _validateForm(state.username, state.email, state.password, event.confirmPassword),
      ));
    });

    on<SignupUserTypeChanged>((event, emit) {
      emit(state.copyWith(userType: event.userType));
    });

    on<SignupProfileDataChanged>((event, emit) {
      final updatedProfile = Map<String, dynamic>.from(state.profileData);
      updatedProfile[event.key] = event.value;
      emit(state.copyWith(profileData: updatedProfile));
    });

    on<FetchLocationRequested>(_onFetchLocation);
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  bool _validateForm(String username, String email, String password, String confirmPassword) {
    return username.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;
  }

  Future<void> _onFetchLocation(FetchLocationRequested event, Emitter<SignupState> emit) async {
    try {
      emit(state.copyWith(isSubmitting: true));

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "Location services are disabled."));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(isSubmitting: false, errorMessage: "Location permission denied."));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "Location permissions are permanently denied."));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Update profile data with location
      final updatedProfile = Map<String, dynamic>.from(state.profileData);
      updatedProfile["latitude"] = position.latitude;
      updatedProfile["longitude"] = position.longitude;

      emit(state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
        profileData: updatedProfile,
        isSubmitting: false,
      ));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: "Failed to fetch location: $e"));
    }
  }

  Future<void> _onSignupSubmitted(SignupSubmitted event, Emitter<SignupState> emit) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      // Call the updated AuthRepository.signup() that now uses structured profile_data
      final response = await authRepository.signup(
        username: state.username,
        email: state.email,
        password: state.password,
        userType: state.userType,
        profileData: state.profileData, // already includes lat/long
      );

      if (response['success'] == true) {
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: response['message'] ?? "Signup failed",
        ));
      }
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}

import 'dart:async';
import 'package:medisync360/models/profile_model.dart';


class ProfileRepository {
  Future<UserProfile> getUserProfile(String token) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulated API response (you can replace this with real API)
    final response = {
      "id": "1",
      "name": "John Doe",
      "email": "john.doe@medisync360.com",
      "phone": "+91 9876543210",
      "age": 28,
      "gender": "Male",
      "address": "Pune, Maharashtra, India",
      "avatarUrl": "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
    };

    return UserProfile.fromJson(response);
  }

  Future<void> updateUserProfile(String token, Map<String, dynamic> data) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulated success response
    print("Profile updated: $data");
  }
}

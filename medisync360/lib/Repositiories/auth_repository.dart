import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medisync360/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String baseUrl = BASE_URL; // Change for production

  /// 🔹 Mock Login (for testing UI)
Future<bool> login(String username, String password, String userType) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/token/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'password': password,
      'user_type': userType.toLowerCase(),
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // ✅ Store tokens and user info locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access', data['access']);
    await prefs.setString('refresh', data['refresh']);
    await prefs.setString('user_type', data['user_type']);
    await prefs.setString('email', data['email']);
    await prefs.setString('username', data['username']);

    print('✅ Login successful, tokens saved locally.');
    return true;
  } else {
    final errorBody = jsonDecode(response.body);
    throw Exception("Invalid credentials: ${errorBody['detail'] ?? response.statusCode}");
  }
}


  /// 🔹 Mock Signup (for testing UI)
  Future<bool> mockSignup({
    required String username,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate API delay
    if (email.contains("@") && password.length >= 6) {
      return true;
    } else {
      throw Exception("Signup failed. Invalid details.");
    }
  }

  /// 🔹 Real Signup API (User / Doctor / Hospital)
  Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
    required String userType,
    Map<String, dynamic>? profileData,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/signup/");

      final Map<String, dynamic> requestBody = {
        "username": username,
        "password": password,
        "email": email,
        "user_type": userType,
      };

      // Add profile_data if doctor or hospital
      if (userType == "doctor" || userType == "hospital") {
        final data = Map<String, dynamic>.from(profileData ?? {});

        // inject lat/long if available
        if (latitude != null && longitude != null) {
          data["latitude"] = latitude;
          data["longitude"] = longitude;
        }

        requestBody["profile_data"] = data;
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);
        return {"success": true, "message": res["message"] ?? "Signup success"};
      } else {
        final res = jsonDecode(response.body);
        return {"success": false, "message": res["message"] ?? "Signup failed"};
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }
}

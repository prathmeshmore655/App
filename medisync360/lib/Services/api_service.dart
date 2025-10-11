import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medisync360/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = BASE_URL; // 🔹 Change to your API

  // ---------------------------
  // ✅ Core API Request Handler
  // ---------------------------
  static Future<http.Response> request(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access');
    String? refreshToken = prefs.getString('refresh');

    // Build headers with access token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    Uri url = Uri.parse('$baseUrl$endpoint');
    http.Response response;

    // ---------------------------
    // 🔹 Send API Request
    // ---------------------------
    if (method == 'POST') {
      response = await http.post(url, headers: headers, body: jsonEncode(body));
    } else if (method == 'PUT') {
      response = await http.put(url, headers: headers, body: jsonEncode(body));
    } else if (method == 'DELETE') {
      response = await http.delete(url, headers: headers);
    } else {
      response = await http.get(url, headers: headers);
    }

    // ---------------------------
    // 🔹 Check Token Expiration
    // ---------------------------
    if (response.statusCode == 401 && refreshToken != null) {
      bool refreshed = await _refreshAccessToken(refreshToken);

      if (refreshed) {
        // Retry original request once with new access token
        final newAccess = prefs.getString('access');
        headers['Authorization'] = 'Bearer $newAccess';

        if (method == 'POST') {
          response = await http.post(url, headers: headers, body: jsonEncode(body));
        } else if (method == 'PUT') {
          response = await http.put(url, headers: headers, body: jsonEncode(body));
        } else if (method == 'DELETE') {
          response = await http.delete(url, headers: headers);
        } else {
          response = await http.get(url, headers: headers);
        }
      } else {
        throw Exception("Session expired. Please login again.");
      }
    }

    return response;
  }

  // ---------------------------
  // ✅ Refresh Access Token
  // ---------------------------
  static Future<bool> _refreshAccessToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access', data['access']);
        print('🔄 Access token refreshed successfully.');
        return true;
      } else {
        print('❌ Failed to refresh token: ${response.body}');
        return false;
      }
    } catch (e) {
      print('⚠️ Error refreshing token: $e');
      return false;
    }
  }
}

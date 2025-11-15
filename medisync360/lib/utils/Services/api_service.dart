import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medisync360/utils/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = BASE_URL;

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

    // ---------------------------
    // 🔹 Headers with no-cache
    // ---------------------------
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cache-Control': 'no-cache, no-store, must-revalidate',
      'Pragma': 'no-cache',
      'Expires': '0',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    // ---------------------------
    // 🔹 Build full URL
    // ---------------------------
    Uri url = Uri.parse('$baseUrl$endpoint');

    // 🧠 Add timestamp param to GET requests to prevent caching
    if (method.toUpperCase() == 'GET') {
      url = url.replace(queryParameters: {
        ...url.queryParameters,
        't': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }

    http.Response response;

    // ---------------------------
    // 🔹 Execute HTTP request
    // ---------------------------
    switch (method.toUpperCase()) {
      case 'POST':
        response = await http.post(url, headers: headers, body: jsonEncode(body));
        break;
      case 'PUT':
        response = await http.put(url, headers: headers, body: jsonEncode(body));
        break;
      case 'DELETE':
        response = await http.delete(url, headers: headers);
        break;
      default:
        response = await http.get(url, headers: headers);
        break;
    }

    // ---------------------------
    // 🔹 Handle 401 (Token Expired)
    // ---------------------------
    if (response.statusCode == 401 && refreshToken != null) {
      bool refreshed = await _refreshAccessToken(refreshToken);

      if (refreshed) {
        final newAccess = prefs.getString('access');
        headers['Authorization'] = 'Bearer $newAccess';

        // Retry once with refreshed token
        switch (method.toUpperCase()) {
          case 'POST':
            response = await http.post(url, headers: headers, body: jsonEncode(body));
            break;
          case 'PUT':
            response = await http.put(url, headers: headers, body: jsonEncode(body));
            break;
          case 'DELETE':
            response = await http.delete(url, headers: headers);
            break;
          default:
            response = await http.get(url, headers: headers);
            break;
        }
      } else {
        throw Exception("Session expired. Please log in again.");
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

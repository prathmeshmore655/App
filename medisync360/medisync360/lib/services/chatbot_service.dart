import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String baseUrl = "http://127.0.0.1:8000/bot-chat/"; // Replace with FastAPI endpoint

  Future<Map<String, dynamic>> getResponse(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": userMessage}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Ensure "response" exists and is a map
        if (data.containsKey("response") && data["response"] is Map<String, dynamic>) {
          return data["response"];
        } else {
          return {"error": "Invalid response format"};
        }
      } else {
        return {"error": "Server responded with status ${response.statusCode}"};
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }
}

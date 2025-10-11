import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chatbot_model.dart';

class ChatbotRepository {
  final String baseUrl = "https://04e785a86807.ngrok-free.app/api/chatbot";

  Future<List<String>> fetchSymptoms() async {
    final response = await http.get(Uri.parse('$baseUrl/symptoms/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['symptoms']);
    } else {
      throw Exception('Failed to load symptoms');
    }
  }

  Future<DiagnosisResult> diagnose(List<String> symptoms, int days) async {
    final response = await http.post(
      Uri.parse('$baseUrl/diagnose/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"symptoms": symptoms, "days": days}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DiagnosisResult.fromJson(data);
    } else {
      throw Exception('Diagnosis failed');
    }
  }
}

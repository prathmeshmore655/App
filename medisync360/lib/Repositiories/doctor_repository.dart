import 'dart:convert';
import 'package:medisync360/Services/api_service.dart';
import 'package:medisync360/base_url.dart';
import 'package:medisync360/models/doctor_models.dart';


class DoctorRepository {
  final String baseUrl = BASE_URL; // ✅ replace this

  Future<List<DoctorModel>> fetchDoctors() async {
    final response = await ApiService.request('/auth/doctor/read/');

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => DoctorModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load doctors: ${response.statusCode}');
    }
  }
}

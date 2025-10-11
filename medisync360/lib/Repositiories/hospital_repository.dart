import 'dart:convert';
import 'package:medisync360/Services/api_service.dart';
import 'package:medisync360/models/hospital_beds_model.dart';
import 'package:medisync360/models/hospital_model.dart';


class HospitalRepository {
  Future<HospitalModel> fetchHospitalProfile() async {
    final response = await ApiService.request('/auth/hospital/info/'); // Adjust endpoint

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HospitalModel.fromJson(data);
    } else {
      throw Exception('Failed to load hospital profile');
    }
  }



   Future<HospitalBedsModel> fetchHospitalBeds() async {
    final response = await ApiService.request('/auth/hospital/beds/');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HospitalBedsModel.fromJson(data);
    } else {
      throw Exception("Failed to load hospital beds data");
    }
  }
}

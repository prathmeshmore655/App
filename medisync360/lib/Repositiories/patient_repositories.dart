import 'dart:convert';
import 'package:medisync360/Services/api_service.dart';
import 'package:medisync360/models/patients_model.dart';

class PatientRepository {
  // ---------------------------
  // ✅ Get All Patients
  // ---------------------------
  Future<List<PatientModel>> getPatients() async {
    final response = await ApiService.request('/auth/patient/read/');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => PatientModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load patients: ${response.statusCode}');
    }
  }

  // ---------------------------
  // ✅ Create Patient
  // ---------------------------
  Future<PatientModel> addPatient(PatientModel patient) async {
    final response = await ApiService.request(
      '/auth/patient/create/',
      method: 'POST',
      body: patient.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return PatientModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add patient: ${response.statusCode}');
    }
  }

  // ---------------------------
  // ✅ Update Patient
  // ---------------------------
  Future<PatientModel> updatePatient(PatientModel patientId) async {


    final response = await ApiService.request(
      '/auth/patient/update/${patientId.id}/',
      method: 'PUT',
      body: patientId.toJson(),
    );

    if (response.statusCode == 200) {
      return PatientModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update patient: ${response.statusCode}');
    }
  }

  // ---------------------------
  // ✅ Delete Patient
  // ---------------------------
  Future<void> deletePatient(int patientId) async {
    final response = await ApiService.request(
      '/auth/patient/delete/$patientId/',
      method: 'DELETE',
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete patient: ${response.statusCode}');
    }
  }
}

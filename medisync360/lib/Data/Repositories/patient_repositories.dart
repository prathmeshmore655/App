import 'dart:convert';
import 'package:medisync360/Domain/Entities/Hospital/patient_entities.dart';
import 'package:medisync360/Domain/Repositories/patient_repositories_domain.dart';
import 'package:medisync360/utils/Services/api_service.dart';
import 'package:medisync360/Data/Models/patients_model.dart';

class PatientRepository implements PatientRepositoriesDomain{
  // ----------------------------------------------------
  // ✅ Get All Patients
  // ----------------------------------------------------
  @override
  Future<List<PatientEntities>> getPatients() async {
    final response = await ApiService.request('/auth/patient/read/');

    if (response.statusCode == 200) {
      final raw = jsonDecode(response.body) as List;

      return raw
          .map((json) => PatientModel.fromJson(json).toDomain())
          .toList();
    } else {
      throw Exception('Failed to load patients: ${response.statusCode}');
    }
  }

  // ----------------------------------------------------
  // ✅ Create Patient
  // ----------------------------------------------------

  @override
  Future<PatientEntities> addPatient(PatientEntities patient) async {
    final response = await ApiService.request(
      '/auth/patient/create/',
      method: 'POST',
      body: {
        "id": patient.id,
        "name": patient.name,
        "age": patient.age,
        "gender": patient.gender.name,
        "room": patient.room,
        "bed_number": patient.bedNumber,
        "contact_number": patient.contactNumber,
        "email": patient.email,
        "emergency_contact": patient.emergencyContact,
        "emergency_contact_name": patient.emergencyContactName,
        "medical_history": patient.medicalHistory,
        "allergies": patient.allergies,
        "current_medications": patient.currentMedications,
        "blood_group": patient.bloodGroup,
        "department": patient.department?.name,
        "admissionDate": patient.admissionDate,
        "dischargeDate": patient.dischargeDate,
        "doctor_notes": patient.doctorNotes,
        "diagnosis": patient.diagnosis,
        "status": patient.status.name,
        "hospital": patient.hospital,
        "doctor": patient.doctor,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return (PatientModel.fromJson(json).toDomain());
    } else {
      throw Exception('Failed to add patient: ${response.statusCode}');
    }
  }

  // ----------------------------------------------------
  // ✅ Update Patient
  // ----------------------------------------------------
  
  @override
  Future<PatientEntities> updatePatient(PatientModel patient) async {
    final response = await ApiService.request(
      '/auth/patient/update/${patient.id}/',
      method: 'PUT',
      body: patient.toJson(), // ✔ Correct JSON payload
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PatientModel.fromJson(json).toDomain();
    } else {
      throw Exception('Failed to update patient: ${response.statusCode}');
    }
  }

  // ----------------------------------------------------
  // ✅ Delete Patient
  // ----------------------------------------------------

  @override
  Future<void> deletePatient(int patientId) async {
    final response = await ApiService.request(
      '/auth/patient/delete/$patientId/',
      method: 'DELETE',
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete patient: ${response.statusCode}');
    }
  }
}

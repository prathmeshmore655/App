import 'package:medisync360/Data/Models/patients_model.dart';
import 'package:medisync360/Domain/Entities/Hospital/patient_entities.dart';

abstract class PatientRepositoriesDomain {

  Future<List<PatientEntities>> getPatients();

  Future<PatientEntities> addPatient(PatientEntities patient);

  Future<PatientEntities> updatePatient(PatientModel patient);

  Future<void> deletePatient(int patientId);

}
import 'package:equatable/equatable.dart';
import 'package:medisync360/Data/Models/doctor_models.dart';
import 'package:medisync360/Domain/Entities/Hospital/patient_entities.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object?> get props => [];
}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientLoaded extends PatientState {
  final List<PatientEntities> patients;
  final List<DoctorModel> doctors;
  const PatientLoaded({required this.patients, required this.doctors});
}

class PatientError extends PatientState {
  final String message;
  const PatientError(this.message);
}

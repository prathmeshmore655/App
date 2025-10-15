import 'package:equatable/equatable.dart';
import 'package:medisync360/models/doctor_models.dart';
import 'package:medisync360/models/patients_model.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object?> get props => [];
}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientLoaded extends PatientState {
  final List<PatientModel> patients;
  final List<DoctorModel> doctors;
  const PatientLoaded({required this.patients, required this.doctors});
}

class PatientError extends PatientState {
  final String message;
  const PatientError(this.message);
}

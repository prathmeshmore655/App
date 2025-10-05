import 'package:equatable/equatable.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();

  @override
  List<Object> get props => [];
}

class LoadPatients extends PatientEvent {}

class AddPatient extends PatientEvent {
  final String name;
  final int age;
  final String gender;
  final String ward;
  final String bed;

  const AddPatient({
    required this.name,
    required this.age,
    required this.gender,
    required this.ward,
    required this.bed,
  });

  @override
  List<Object> get props => [name, age, gender, ward, bed];
}

class DischargePatient extends PatientEvent {
  final int patientId;

  const DischargePatient(this.patientId);

  @override
  List<Object> get props => [patientId];
}

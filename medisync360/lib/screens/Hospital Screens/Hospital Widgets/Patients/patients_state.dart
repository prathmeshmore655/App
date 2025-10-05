import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final int id;
  final String name;
  final int age;
  final String gender;
  final String ward;
  final String bed;
  final String status; // Admitted / Discharged

  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.ward,
    required this.bed,
    required this.status,
  });

  Patient copyWith({String? status}) {
    return Patient(
      id: id,
      name: name,
      age: age,
      gender: gender,
      ward: ward,
      bed: bed,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, name, age, gender, ward, bed, status];
}

class PatientState extends Equatable {
  final bool isLoading;
  final List<Patient> patients;

  const PatientState({this.isLoading = true, this.patients = const []});

  PatientState copyWith({bool? isLoading, List<Patient>? patients}) {
    return PatientState(
      isLoading: isLoading ?? this.isLoading,
      patients: patients ?? this.patients,
    );
  }

  @override
  List<Object?> get props => [isLoading, patients];
}

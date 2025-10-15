import 'package:equatable/equatable.dart';
import 'package:medisync360/models/doctor_models.dart';
import 'package:medisync360/models/patients_model.dart';


abstract class PatientEvent extends Equatable {
  const PatientEvent();

  @override
  List<Object?> get props => [];
}

class LoadPatients extends PatientEvent {}

class AddPatient extends PatientEvent {
  final PatientModel patient;
  const AddPatient(this.patient);
}

class UpdatePatient extends PatientEvent {
  final PatientModel patient;
  const UpdatePatient(this.patient);
}

class DeletePatient extends PatientEvent {
  final int id;
  const DeletePatient(this.id);
}


class LoadDoctores extends PatientEvent {

  final DoctorModel doctorModel;
  const LoadDoctores(this.doctorModel);
}
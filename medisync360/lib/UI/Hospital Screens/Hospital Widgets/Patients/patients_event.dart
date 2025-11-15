import 'package:equatable/equatable.dart';
import 'package:medisync360/Data/Models/doctor_models.dart';
import 'package:medisync360/Domain/Entities/Hospital/patient_entities.dart';


abstract class PatientEvent extends Equatable {
  const PatientEvent();

  @override
  List<Object?> get props => [];
}

class LoadPatients extends PatientEvent {}

class AddPatient extends PatientEvent {
  final PatientEntities patient;
  const AddPatient(this.patient);
}

class UpdatePatient extends PatientEvent {
  final PatientEntities patient;
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
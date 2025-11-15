import 'package:medisync360/Domain/Entities/Hospital/hospital_beds_entities.dart';
import 'package:medisync360/Domain/Entities/Hospital/hospital_entities.dart';


abstract class HospitalState {}

class HospitalInitial extends HospitalState {}

class HospitalLoading extends HospitalState {}

class HospitalLoaded extends HospitalState {
  final HospitalEntities hospital;
  final HospitalBedsEntities beds;

  HospitalLoaded(this.hospital, this.beds);
}

class HospitalError extends HospitalState {
  final String message;
  HospitalError(this.message);
}

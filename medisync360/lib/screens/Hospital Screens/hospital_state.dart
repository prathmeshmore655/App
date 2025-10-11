import '../../models/hospital_model.dart';
import '../../models/hospital_beds_model.dart';

abstract class HospitalState {}

class HospitalInitial extends HospitalState {}

class HospitalLoading extends HospitalState {}

class HospitalLoaded extends HospitalState {
  final HospitalModel hospital;
  final HospitalBedsModel beds;

  HospitalLoaded(this.hospital, this.beds);
}

class HospitalError extends HospitalState {
  final String message;
  HospitalError(this.message);
}

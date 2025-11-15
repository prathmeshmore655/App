import 'package:equatable/equatable.dart';
import 'package:medisync360/Domain/Entities/Hospital/hospital_entities.dart';

abstract class HospitalProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HospitalProfileInitial extends HospitalProfileState {}

class HospitalProfileLoading extends HospitalProfileState {}

class HospitalProfileLoaded extends HospitalProfileState {
  final HospitalEntities hospital;
  HospitalProfileLoaded(this.hospital);

  @override
  List<Object?> get props => [hospital];
}

class HospitalProfileError extends HospitalProfileState {
  final String message;
  HospitalProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

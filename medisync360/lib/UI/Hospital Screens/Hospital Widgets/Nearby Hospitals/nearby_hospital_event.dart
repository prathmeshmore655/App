import 'package:equatable/equatable.dart';

abstract class HospitalMapEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHospitals extends HospitalMapEvent {}

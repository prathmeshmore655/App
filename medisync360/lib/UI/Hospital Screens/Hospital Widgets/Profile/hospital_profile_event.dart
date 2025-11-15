import 'package:equatable/equatable.dart';

abstract class HospitalProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchHospitalProfile extends HospitalProfileEvent {}

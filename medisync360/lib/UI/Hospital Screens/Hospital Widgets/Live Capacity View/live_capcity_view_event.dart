import 'package:equatable/equatable.dart';

abstract class HospitalCapacityEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchHospitals extends HospitalCapacityEvent {}

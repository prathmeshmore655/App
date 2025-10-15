// bloc/appointment_state.dart

import 'package:equatable/equatable.dart';
import 'package:medisync360/models/appointment_model.dart';

abstract class AppointmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}
class AppointmentLoading extends AppointmentState {}

class DoctorsLoaded extends AppointmentState {
  final List<Doctor> doctors;
  DoctorsLoaded(this.doctors);
}

class HospitalsLoaded extends AppointmentState {
  final List<Hospital> hospitals;
  HospitalsLoaded(this.hospitals);
}

class SlotsLoaded extends AppointmentState {
  final List<AppointmentSlot> slots;
  SlotsLoaded(this.slots);
}

class AppointmentBooked extends AppointmentState {
  final bool success;
  AppointmentBooked(this.success);
}

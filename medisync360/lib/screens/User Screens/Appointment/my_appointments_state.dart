// bloc/my_appointments_state.dart
import 'package:equatable/equatable.dart';
import 'package:medisync360/models/appointment_model.dart';

abstract class MyAppointmentsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyAppointmentsInitial extends MyAppointmentsState {}
class MyAppointmentsLoading extends MyAppointmentsState {}
class MyAppointmentsLoaded extends MyAppointmentsState {
  final List<Appointment> appointments;
  MyAppointmentsLoaded(this.appointments);
}
class MyAppointmentsError extends MyAppointmentsState {
  final String message;
  MyAppointmentsError(this.message);
}

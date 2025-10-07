// bloc/my_appointments_event.dart
import 'package:equatable/equatable.dart';

abstract class MyAppointmentsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAppointments extends MyAppointmentsEvent {}

import 'package:equatable/equatable.dart';


abstract class AppointmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDoctors extends AppointmentEvent {}
class LoadHospitals extends AppointmentEvent {}
class LoadSlots extends AppointmentEvent {
  final String doctorId;
  final String hospitalId;
  LoadSlots({required this.doctorId, required this.hospitalId});
}

class BookAppointmentEvent extends AppointmentEvent {
  final String doctorId;
  final String hospitalId;
  final String slotId;
  BookAppointmentEvent({required this.doctorId, required this.hospitalId, required this.slotId});
}

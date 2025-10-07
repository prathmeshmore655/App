// models/appointment.dart
class Appointment {
  final String id;
  final String doctorName;
  final String hospitalName;
  final String time;
  final String status; // upcoming, completed, cancelled

  Appointment({
    required this.id,
    required this.doctorName,
    required this.hospitalName,
    required this.time,
    required this.status,
  });
}

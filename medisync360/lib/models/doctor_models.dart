// models/doctor.dart
class Doctor {
  final String id;
  final String name;
  final String specialization;

  Doctor({required this.id, required this.name, required this.specialization});
}

// models/hospital.dart
class Hospital {
  final String id;
  final String name;
  final String location;

  Hospital({required this.id, required this.name, required this.location});
}

// models/appointment_slot.dart
class AppointmentSlot {
  final String id;
  final String time;
  final bool isAvailable;

  AppointmentSlot({required this.id, required this.time, required this.isAvailable});
}

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

  factory Appointment.fromJson(Map<String , dynamic> json) {

    return Appointment(
      id: json['id'], 
      doctorName: json['doctorName'], 
      hospitalName: json['hospitalName'], 
      time: json['time'], 
      status: json['status']
    );
  }

  
}


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
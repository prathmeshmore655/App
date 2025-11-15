import 'package:medisync360/Data/Models/appointment_model.dart';

class AppointmentRepository {
  Future<List<Doctor>> getDoctors() async {
    await Future.delayed(Duration(seconds: 1)); // simulate network delay
    return [
      Doctor(id: "1", name: "Dr. Smith", specialization: "Cardiologist"),
      Doctor(id: "2", name: "Dr. Jane", specialization: "Dermatologist"),
    ];
  }

  Future<List<Hospital>> getHospitals() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      Hospital(id: "1", name: "City Hospital", location: "Downtown"),
      Hospital(id: "2", name: "Sunrise Clinic", location: "Uptown"),
    ];
  }

  Future<List<AppointmentSlot>> getSlots(String doctorId, String hospitalId) async {
    await Future.delayed(Duration(seconds: 1));
    return [
      AppointmentSlot(id: "1", time: "10:00 AM", isAvailable: true),
      AppointmentSlot(id: "2", time: "11:00 AM", isAvailable: true),
      AppointmentSlot(id: "3", time: "12:00 PM", isAvailable: false),
    ];
  }

  Future<bool> bookAppointment(String doctorId, String hospitalId, String slotId) async {
    await Future.delayed(Duration(seconds: 1));
    return true; // default success
  }
}








class MyAppointmentRepository {
  Future<List<Appointment>> getAppointments() async {
    await Future.delayed(Duration(seconds: 1)); // simulate API
    return [
      Appointment(
          id: "1",
          doctorName: "Dr. Smith",
          hospitalName: "City Hospital",
          time: "2025-10-07 10:00 AM",
          status: "upcoming"),
      Appointment(
          id: "2",
          doctorName: "Dr. Jane",
          hospitalName: "Sunrise Clinic",
          time: "2025-09-30 02:00 PM",
          status: "completed"),
      Appointment(
          id: "3",
          doctorName: "Dr. Raj",
          hospitalName: "Metro Hospital",
          time: "2025-10-05 11:00 AM",
          status: "cancelled"),
    ];
  }
}

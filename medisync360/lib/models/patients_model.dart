class PatientModel {
  final int id;
  final String name;
  final int age;
  final String gender;
  final String room;
  final String bedNumber;
  final String contactNumber;
  final String email;
  final String emergencyContact;
  final String emergencyContactName;
  final String medicalHistory;
  final String allergies;
  final String currentMedications;
  final String bloodGroup;
  final String department;
  final String admissionDate;
  final String dischargeDate;
  final String doctorNotes;
  final String diagnosis;
  final String status;
  final int hospital;
  final int doctor;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.room,
    required this.bedNumber,
    required this.contactNumber,
    required this.email,
    required this.emergencyContact,
    required this.emergencyContactName,
    required this.medicalHistory,
    required this.allergies,
    required this.currentMedications,
    required this.bloodGroup,
    required this.department,
    required this.admissionDate,
    required this.dischargeDate,
    required this.doctorNotes,
    required this.diagnosis,
    required this.status,
    required this.hospital,
    required this.doctor,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      room: json['room'] ?? '',
      bedNumber: json['bed_number'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      email: json['email'] ?? '',
      emergencyContact: json['emergency_contact'] ?? '',
      emergencyContactName: json['emergency_contact_name'] ?? '',
      medicalHistory: json['medical_history'] ?? '',
      allergies: json['allergies'] ?? '',
      currentMedications: json['current_medications'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      department: json['department'] ?? '',
      admissionDate: json['admissionDate'] ?? '',
      dischargeDate: json['dischargeDate'] ?? '',
      doctorNotes: json['doctor_notes'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      status: json['status'] ?? '',
      hospital: json['hospital'] ?? 0,
      doctor: json['doctor'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "age": age,
      "gender": gender,
      "room": room,
      "bed_number": bedNumber,
      "contact_number": contactNumber,
      "email": email,
      "emergency_contact": emergencyContact,
      "emergency_contact_name": emergencyContactName,
      "medical_history": medicalHistory,
      "allergies": allergies,
      "current_medications": currentMedications,
      "blood_group": bloodGroup,
      "department": department,
      "admissionDate": admissionDate,
      "dischargeDate": dischargeDate,
      "doctor_notes": doctorNotes,
      "diagnosis": diagnosis,
      "status": status,
      "hospital": hospital,
      "doctor": doctor,
    };
  }
}

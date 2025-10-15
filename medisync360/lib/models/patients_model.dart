class PatientModel {
  final int id;
  final String name;
  final int age;
  final Gender gender;
  final String? room;
  final String? bedNumber;
  final String? contactNumber;
  final String? email;
  final String? emergencyContact;
  final String? emergencyContactName;
  final String? medicalHistory;
  final String? allergies;
  final String? currentMedications;
  final String? bloodGroup;
  final Department? department;
  final String? admissionDate;
  final String? dischargeDate;
  final String? doctorNotes;
  final String? diagnosis;
  final Status status;
  final int? hospital;
  final int? doctor;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.room,
    this.bedNumber,
    this.contactNumber,
    this.email,
    this.emergencyContact,
    this.emergencyContactName,
    this.medicalHistory,
    this.allergies,
    this.currentMedications,
    this.bloodGroup,
    this.department,
    this.admissionDate,
    this.dischargeDate,
    this.doctorNotes,
    this.diagnosis,
    required this.status,
    this.hospital,
    this.doctor,
  });

  /// ✅ Convert JSON → Model
  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: GenderExtension.fromString(json['gender']),
      room: json['room'],
      bedNumber: json['bed_number'],
      contactNumber: json['contact_number'],
      email: json['email'],
      emergencyContact: json['emergency_contact'],
      emergencyContactName: json['emergency_contact_name'],
      medicalHistory: json['medical_history'],
      allergies: json['allergies'],
      currentMedications: json['current_medications'],
      bloodGroup: json['blood_group'],
      department: DepartmentExtension.fromString(json['department']),
      admissionDate: json['admissionDate'],
      dischargeDate: json['dischargeDate'],
      doctorNotes: json['doctor_notes'],
      diagnosis: json['diagnosis'],
      status: StatusExtension.fromString(json['status']),
      hospital: json['hospital'],
      doctor: json['doctor'],
    );
  }

  /// ✅ Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "age": age,
      "gender": gender.name,
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
      "department": department?.name,
      "admissionDate": admissionDate,
      "dischargeDate": dischargeDate,
      "doctor_notes": doctorNotes,
      "diagnosis": diagnosis,
      "status": status.name,
      "hospital": hospital,
      "doctor": doctor,
    };
  }
}

//
// ✅ Enums for better type safety
//
enum Gender { Male, Female, Other }
enum Status { admitted, discharged }

enum Department {
  Cardiology,
  Neurology,
  Orthopedics,
  Pediatrics,
  Surgery,
  Gynecology,
  Emergency,
  Psychiatry,
  Dermatology,
  Ophthalmology,
  ENT,
  Radiology,
  Pathology,
  Urology,
  Gastroenterology,
  Oncology,
  Nephrology,
  Endocrinology,
  Pulmonology,
  Hematology,
  Rheumatology,
  Geriatrics,
  Anesthesiology,
  PainManagement,
  Other,
}

//
// ✅ Enum Extensions for JSON mapping
//
extension GenderExtension on Gender {
  static Gender fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'male':
        return Gender.Male;
      case 'female':
        return Gender.Female;
      default:
        return Gender.Other;
    }
  }
}

extension StatusExtension on Status {
  static Status fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'admitted':
        return Status.admitted;
      default:
        return Status.discharged;
    }
  }
}

extension DepartmentExtension on Department {
  static Department? fromString(String? value) {
    if (value == null) return null;
    return Department.values.firstWhere(
      (e) => e.name.toLowerCase() == value.replaceAll(' ', '').toLowerCase(),
      orElse: () => Department.Other,
    );
  }
}

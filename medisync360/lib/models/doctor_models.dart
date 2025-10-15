class DoctorModel {
  final int id;
  final String fullName;
  final String specialization;
  final String department;

  DoctorModel({
    required this.id,
    required this.fullName,
    required this.specialization,
    required this.department,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      specialization: json['specialization'] ?? '',
      department: json['department'] ?? '',
    );
  }
}

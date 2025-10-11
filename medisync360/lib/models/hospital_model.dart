// lib/models/hospital_model.dart
class HospitalModel {
  final String id;
  final String name;
  final String type;
  final String establishedYear;
  final double rating;
  final int totalBeds;
  final int occupiedBeds;
  final int totalStaff;
  final int totalDoctors;
  final int totalNurses;
  final String address;
  final String contactNumber;
  final String email;
  final String registrationNumber;
  final int icuBeds;
  final int ventilators;
  final String? website;
  final double latitude;
  final double longitude;

  HospitalModel({
    required this.id,
    required this.name,
    required this.type,
    required this.establishedYear,
    required this.rating,
    required this.totalBeds,
    required this.occupiedBeds,
    required this.totalStaff,
    required this.totalDoctors,
    required this.totalNurses,
    required this.address,
    required this.contactNumber,
    required this.email,
    required this.registrationNumber,
    required this.icuBeds,
    required this.ventilators,
    this.website,
    required this.latitude,
    required this.longitude,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      establishedYear: json['established_year'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalBeds: json['total_beds'],
      occupiedBeds: json['occupied_beds'],
      totalStaff: json['total_staff'],
      totalDoctors: json['total_doctors'],
      totalNurses: json['total_nurses'],
      address: json['address'],
      contactNumber: json['contact_number'],
      email: json['email'],
      registrationNumber: json['registration_number'],
      icuBeds: json['icu_beds'],
      ventilators: json['ventilators'],
      website: json['website'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}

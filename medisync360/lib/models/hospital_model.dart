class HospitalModel {
  final String id;
  final String name;
  final String registrationNumber;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String contactNumber;
  final String? email;
  final String? website;
  final String? establishedYear;
  final String? description;
  final String? type;
  final bool emergencyServices;

  // Location
  final double? latitude;
  final double? longitude;

  // Staff
  final int totalStaff;
  final int totalDoctors;
  final int totalNurses;

  // Ratings
  final double rating;

  // Bed Info
  final int totalBeds;
  final int occupiedBeds;

  // Bed Breakdown
  final int icuBedsTotal;
  final int icuBedsOccupied;
  final int emergencyBedsTotal;
  final int emergencyBedsOccupied;
  final int generalWardTotal;
  final int generalWardOccupied;
  final int cardiologyBedsTotal;
  final int cardiologyBedsOccupied;
  final int pediatricsBedsTotal;
  final int pediatricsBedsOccupied;
  final int surgeryBedsTotal;
  final int surgeryBedsOccupied;
  final int maternityBedsTotal;
  final int maternityBedsOccupied;

  HospitalModel({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.contactNumber,
    this.email,
    this.website,
    this.establishedYear,
    this.description,
    this.type,
    required this.emergencyServices,
    this.latitude,
    this.longitude,
    required this.totalStaff,
    required this.totalDoctors,
    required this.totalNurses,
    required this.rating,
    required this.totalBeds,
    required this.occupiedBeds,
    required this.icuBedsTotal,
    required this.icuBedsOccupied,
    required this.emergencyBedsTotal,
    required this.emergencyBedsOccupied,
    required this.generalWardTotal,
    required this.generalWardOccupied,
    required this.cardiologyBedsTotal,
    required this.cardiologyBedsOccupied,
    required this.pediatricsBedsTotal,
    required this.pediatricsBedsOccupied,
    required this.surgeryBedsTotal,
    required this.surgeryBedsOccupied,
    required this.maternityBedsTotal,
    required this.maternityBedsOccupied,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      registrationNumber: json['registration_number'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      email: json['email'],
      website: json['website'],
      establishedYear: json['established_year'],
      description: json['description'],
      type: json['type'],
      emergencyServices: json['emergency_services'] ?? false,
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      totalStaff: json['total_staff'] ?? 0,
      totalDoctors: json['total_doctors'] ?? 0,
      totalNurses: json['total_nurses'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalBeds: json['total_beds'] ?? 0,
      occupiedBeds: json['occupied_beds'] ?? 0,
      icuBedsTotal: json['icu_beds_total'] ?? 0,
      icuBedsOccupied: json['icu_beds_occupied'] ?? 0,
      emergencyBedsTotal: json['emergency_beds_total'] ?? 0,
      emergencyBedsOccupied: json['emergency_beds_occupied'] ?? 0,
      generalWardTotal: json['general_ward_total'] ?? 0,
      generalWardOccupied: json['general_ward_occupied'] ?? 0,
      cardiologyBedsTotal: json['cardiology_beds_total'] ?? 0,
      cardiologyBedsOccupied: json['cardiology_beds_occupied'] ?? 0,
      pediatricsBedsTotal: json['pediatrics_beds_total'] ?? 0,
      pediatricsBedsOccupied: json['pediatrics_beds_occupied'] ?? 0,
      surgeryBedsTotal: json['surgery_beds_total'] ?? 0,
      surgeryBedsOccupied: json['surgery_beds_occupied'] ?? 0,
      maternityBedsTotal: json['maternity_beds_total'] ?? 0,
      maternityBedsOccupied: json['maternity_beds_occupied'] ?? 0,
    );
  }
}

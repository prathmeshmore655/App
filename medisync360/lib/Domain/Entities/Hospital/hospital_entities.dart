class HospitalEntities {
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

  HospitalEntities({
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

}
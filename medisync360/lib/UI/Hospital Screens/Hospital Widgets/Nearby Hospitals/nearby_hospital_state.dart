import 'package:equatable/equatable.dart';

class HospitalInfo {
  final String name;
  final String? type;
  final double rating;
  final int totalBeds;
  final int occupiedBeds;
  final int totalStaff;
  final int totalDoctors;
  final int totalNurses;
  final String address;
  final String contactNumber;
  final int icuBeds;
  final int ventilators;
  final String website;
  final double latitude;
  final double longitude;

  HospitalInfo({
    required this.name,
    required this.type,
    required this.rating,
    required this.totalBeds,
    required this.occupiedBeds,
    required this.totalStaff,
    required this.totalDoctors,
    required this.totalNurses,
    required this.address,
    required this.contactNumber,
    required this.icuBeds,
    required this.ventilators,
    required this.website,
    required this.latitude,
    required this.longitude,
  });

  factory HospitalInfo.fromJson(Map<String, dynamic> json) {
    return HospitalInfo(
      name: json['name'],
      type: json['type'],
      rating: (json['rating'] ?? 0).toDouble(),
      totalBeds: json['total_beds'] ?? 0,
      occupiedBeds: json['occupied_beds'] ?? 0,
      totalStaff: json['total_staff'] ?? 0,
      totalDoctors: json['total_doctors'] ?? 0,
      totalNurses: json['total_nurses'] ?? 0,
      address: json['address'] ?? "",
      contactNumber: json['contact_number'] ?? "",
      icuBeds: json['icu_beds'] ?? 0,
      ventilators: json['ventilators'] ?? 0,
      website: json['website'] ?? "",
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}

class HospitalMapState extends Equatable {
  final bool isLoading;
  final List<HospitalInfo> hospitals;
  final HospitalInfo? selectedHospital;

  const HospitalMapState({
    this.isLoading = false,
    this.hospitals = const [],
    this.selectedHospital,
  });

  HospitalMapState copyWith({
    bool? isLoading,
    List<HospitalInfo>? hospitals,
    HospitalInfo? selectedHospital,
  }) {
    return HospitalMapState(
      isLoading: isLoading ?? this.isLoading,
      hospitals: hospitals ?? this.hospitals,
      selectedHospital: selectedHospital,
    );
  }

  @override
  List<Object?> get props => [isLoading, hospitals, selectedHospital];
}

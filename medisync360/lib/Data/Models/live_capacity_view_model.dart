import 'package:medisync360/Domain/Entities/Hospital/live_caapcity_view_entities.dart';

class LiveCapacityViewModel {
  final int id;
  final String name;
  final String city;
  final String state;
  final bool emergencyServices;
  final int totalBeds;
  final int occupiedBeds;
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
  final String establishedYear;
  final double rating;

  LiveCapacityViewModel({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.emergencyServices,
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
    required this.establishedYear,
    required this.rating,
  });

  factory LiveCapacityViewModel.fromJson(Map<String, dynamic> json) {
    return LiveCapacityViewModel(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      state: json['state'],
      emergencyServices: json['emergency_services'],
      totalBeds: json['total_beds'],
      occupiedBeds: json['occupied_beds'],
      icuBedsTotal: json['icu_beds_total'],
      icuBedsOccupied: json['icu_beds_occupied'],
      emergencyBedsTotal: json['emergency_beds_total'],
      emergencyBedsOccupied: json['emergency_beds_occupied'],
      generalWardTotal: json['general_ward_total'],
      generalWardOccupied: json['general_ward_occupied'],
      cardiologyBedsTotal: json['cardiology_beds_total'],
      cardiologyBedsOccupied: json['cardiology_beds_occupied'],
      pediatricsBedsTotal: json['pediatrics_beds_total'],
      pediatricsBedsOccupied: json['pediatrics_beds_occupied'],
      surgeryBedsTotal: json['surgery_beds_total'],
      surgeryBedsOccupied: json['surgery_beds_occupied'],
      maternityBedsTotal: json['maternity_beds_total'],
      maternityBedsOccupied: json['maternity_beds_occupied'],
      establishedYear: json['established_year'],
      rating: (json['rating'] as num).toDouble(),
    );
  }


  LiveCaapcityViewEntities toDomain () {

    return LiveCaapcityViewEntities(
      id: id, 
      name: name, 
      city: city, 
      state: state, 
      emergencyServices: emergencyServices, 
      totalBeds: totalBeds, 
      occupiedBeds: occupiedBeds, 
      icuBedsTotal: icuBedsTotal, 
      icuBedsOccupied: icuBedsOccupied, 
      emergencyBedsTotal: emergencyBedsTotal, 
      emergencyBedsOccupied: emergencyBedsOccupied, 
      generalWardTotal: generalWardTotal, 
      generalWardOccupied: generalWardOccupied, 
      cardiologyBedsTotal: cardiologyBedsTotal, 
      cardiologyBedsOccupied: cardiologyBedsOccupied, 
      pediatricsBedsTotal: pediatricsBedsTotal, 
      pediatricsBedsOccupied: pediatricsBedsOccupied, 
      surgeryBedsTotal: surgeryBedsTotal, 
      surgeryBedsOccupied: surgeryBedsOccupied, 
      maternityBedsTotal: maternityBedsTotal, 
      maternityBedsOccupied: maternityBedsOccupied, 
      establishedYear: establishedYear, 
      rating: rating
    );
  }
}

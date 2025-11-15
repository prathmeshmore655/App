import 'package:medisync360/Domain/Entities/Hospital/hospital_beds_entities.dart';

class HospitalBedsModel {
  final int generalWard;
  final int icuBeds;
  final int emergencyBeds;
  final int cardiologyBeds;
  final int pediatricsBeds;
  final int surgeryBeds;
  final int maternityBeds;

  HospitalBedsModel({
    required this.generalWard,
    required this.icuBeds,
    required this.emergencyBeds,
    required this.cardiologyBeds,
    required this.pediatricsBeds,
    required this.surgeryBeds,
    required this.maternityBeds,
  });

  factory HospitalBedsModel.fromJson(Map<String, dynamic> json) {
    return HospitalBedsModel(
      generalWard: json['general_ward'] ?? 0,
      icuBeds: json['icu_beds'] ?? 0,
      emergencyBeds: json['emergency_beds'] ?? 0,
      cardiologyBeds: json['cardiology_beds'] ?? 0,
      pediatricsBeds: json['pediatrics_beds'] ?? 0,
      surgeryBeds: json['surgery_beds'] ?? 0,
      maternityBeds: json['maternity_beds'] ?? 0,
    );
  }

  HospitalBedsEntities toDomain () {

    return HospitalBedsEntities(
      generalWard: generalWard, 
      icuBeds: icuBeds, 
      emergencyBeds: emergencyBeds, 
      cardiologyBeds: cardiologyBeds, 
      pediatricsBeds: pediatricsBeds, 
      surgeryBeds: surgeryBeds, 
      maternityBeds: maternityBeds
    );
  }
  
}

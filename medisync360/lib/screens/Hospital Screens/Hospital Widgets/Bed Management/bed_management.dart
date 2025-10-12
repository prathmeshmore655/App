import 'package:flutter/material.dart';
import 'package:medisync360/models/hospital_model.dart';

class BedManagementSection extends StatelessWidget {
  final HospitalModel hospital;

  const BedManagementSection({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Total Beds: ${hospital.totalBeds}"),
        Text("Occupied Beds: ${hospital.occupiedBeds}"),
        Text("ICU Beds: ${hospital.icuBeds}"),
        Text("Ventilators: ${hospital.ventilators}"),
      ],
    );
  }
}

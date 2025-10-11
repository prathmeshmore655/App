import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:medisync360/models/hospital_model.dart';
import 'package:medisync360/models/hospital_beds_model.dart';

class HospitalOverviewSection extends StatelessWidget {
  final HospitalModel hospital;
  final HospitalBedsModel beds;

  const HospitalOverviewSection({
    Key? key,
    required this.hospital,
    required this.beds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hospital.name, style: Theme.of(context).textTheme.headlineSmall),
          Text("${hospital.type} | Established: ${hospital.establishedYear}"),
          const SizedBox(height: 10),
          Text("📍 ${hospital.address}"),
          Text("📞 ${hospital.contactNumber}"),
          Text("📧 ${hospital.email}"),
          Text("Reg. No: ${hospital.registrationNumber}"),
          const SizedBox(height: 20),

          // 🗺 Map
          SizedBox(
            height: 250,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(hospital.latitude, hospital.longitude),
                initialZoom: 14,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: [
                  Marker(
                    point: LatLng(hospital.latitude, hospital.longitude),
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                  ),
                ]),
              ],
            ),
          ),

          const SizedBox(height: 25),
          Text("🏥 Bed Availability", style: Theme.of(context).textTheme.titleLarge),
          const Divider(),

          _buildBedRow("General Ward", beds.generalWard),
          _buildBedRow("ICU Beds", beds.icuBeds),
          _buildBedRow("Emergency Beds", beds.emergencyBeds),
          _buildBedRow("Cardiology Beds", beds.cardiologyBeds),
          _buildBedRow("Pediatrics Beds", beds.pediatricsBeds),
          _buildBedRow("Surgery Beds", beds.surgeryBeds),
          _buildBedRow("Maternity Beds", beds.maternityBeds),
        ],
      ),
    );
  }

  Widget _buildBedRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(count.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

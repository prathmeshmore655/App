import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Nearby%20Hospitals/nearby_hospital_bloc.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Nearby%20Hospitals/nearby_hospital_event.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Nearby%20Hospitals/nearby_hospital_state.dart';



class HospitalMapPage extends StatelessWidget {
  const HospitalMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HospitalMapBloc()..add(LoadHospitals()),
      child: BlocBuilder<HospitalMapBloc, HospitalMapState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.hospitals.isEmpty) {
            return const Scaffold(
              body: Center(child: Text("No hospitals found.")),
            );
          }

          final firstHospital = state.hospitals.first;
          final mapController = MapController();

          return Scaffold(
            appBar: AppBar(
              title: const Text("Hospital Map"),
              backgroundColor: Colors.blue,
            ),
            body: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter:
                    LatLng(firstHospital.latitude, firstHospital.longitude),
                initialZoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: state.hospitals.map((hospital) {
                    return Marker(
                      point: LatLng(hospital.latitude, hospital.longitude),
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (_) => _HospitalInfoSheet(hospital),
                          );
                        },
                        child: const Icon(Icons.location_pin,
                            color: Colors.red, size: 40),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HospitalInfoSheet extends StatelessWidget {
  final HospitalInfo hospital;

  const _HospitalInfoSheet(this.hospital);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hospital.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Address: ${hospital.address}"),
            Text("Contact: ${hospital.contactNumber}"),
            Text("Type: ${hospital.type ?? "N/A"}"),
            Text("Rating: ${hospital.rating.toStringAsFixed(1)}"),
            const Divider(height: 20),
            Text("Total Beds: ${hospital.totalBeds}"),
            Text("Occupied Beds: ${hospital.occupiedBeds}"),
            Text("ICU Beds: ${hospital.icuBeds}"),
            Text("Ventilators: ${hospital.ventilators}"),
            Text("Doctors: ${hospital.totalDoctors}"),
            Text("Nurses: ${hospital.totalNurses}"),
            const SizedBox(height: 10),
            if (hospital.website.isNotEmpty)
              TextButton(
                onPressed: () {},
                child: Text(
                  hospital.website,
                  style: const TextStyle(color: Colors.teal),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

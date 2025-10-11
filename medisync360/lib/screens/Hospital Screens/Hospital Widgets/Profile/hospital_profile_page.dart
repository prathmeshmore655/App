import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/hospital_repository.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Profile/hospital_profile_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Profile/hospital_profile_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Profile/hospital_profile_state.dart';


class HospitalProfileScreen extends StatelessWidget {
  const HospitalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HospitalProfileBloc(HospitalRepository())..add(FetchHospitalProfile()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Hospital Profile')),
        body: BlocBuilder<HospitalProfileBloc, HospitalProfileState>(
          builder: (context, state) {
            if (state is HospitalProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HospitalProfileLoaded) {
              final h = state.hospital;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        Text(h.type, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            Text(h.rating.toStringAsFixed(1)),
                            const SizedBox(width: 10),
                            Text("Established: ${h.establishedYear}"),
                          ],
                        ),
                        const Divider(height: 30),
                        Text("📍 Address: ${h.address}"),
                        Text("📞 Contact: ${h.contactNumber}"),
                        Text("✉️ Email: ${h.email}"),
                        Text("🏥 Reg. No: ${h.registrationNumber}"),
                        const Divider(height: 30),
                        Text("Total Beds: ${h.totalBeds} (Occupied: ${h.occupiedBeds})"),
                        Text("ICU Beds: ${h.icuBeds}"),
                        Text("Ventilators: ${h.ventilators}"),
                        Text("Doctors: ${h.totalDoctors} | Nurses: ${h.totalNurses} | Staff: ${h.totalStaff}"),
                        const Divider(height: 30),
                        if (h.website != null)
                          Text("🌐 Website: ${h.website}"),
                        const SizedBox(height: 10),
                        Text("📍 Location: (${h.latitude}, ${h.longitude})"),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is HospitalProfileError) {
              return Center(child: Text("❌ ${state.message}"));
            } else {
              return const Center(child: Text("No data found."));
            }
          },
        ),
      ),
    );
  }
}

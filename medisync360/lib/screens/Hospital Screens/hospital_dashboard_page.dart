import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/doctor_repository.dart';
import 'package:medisync360/Repositiories/patient_repositories.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Bed%20Management/bed_management.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Overview/hospital_overview_page.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/hospital_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/hospital_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/hospital_state.dart';


class HospitalDashboardScreen extends StatefulWidget {
  const HospitalDashboardScreen({super.key});

  @override
  State<HospitalDashboardScreen> createState() => _HospitalDashboardScreenState();
}

class _HospitalDashboardScreenState extends State<HospitalDashboardScreen> {
  int _selectedIndex = 0;
  final List<String> _sections = ['Overview', 'Bed Management', 'Patients', 'Analytics'];

  @override
  void initState() {
    super.initState();
    context.read<HospitalBloc>().add(FetchHospitalEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hospital Dashboard")),
      body: BlocBuilder<HospitalBloc, HospitalState>(
        builder: (context, state) {
          if (state is HospitalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HospitalLoaded) {
            final hospital = state.hospital;
            final beds = state.beds;
            Widget content;
            switch (_selectedIndex) {
              case 0:
                content = HospitalOverviewSection(hospital: hospital, beds: beds);
                break;
              case 1:
                content = BedManagementSection(hospital: hospital);
                break;
              case 2:
                content = BlocProvider(
                create: (context) => PatientBloc(PatientRepository() , DoctorRepository())..add(LoadPatients()),
                child: const PatientListScreen(),
                );
                break;
              case 3:
                content = const Center(child: Text("📊 Analytics Section Coming Soon"));
                break;
              default:
                content = const SizedBox();
            }

            return Column(
              children: [
                _buildTabBar(),
                Expanded(child: Padding(padding: const EdgeInsets.all(16), child: content)),
              ],
            );
          } else if (state is HospitalError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(_sections.length, (index) {
        final isSelected = _selectedIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedIndex = index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blueAccent : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _sections[index],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }


}

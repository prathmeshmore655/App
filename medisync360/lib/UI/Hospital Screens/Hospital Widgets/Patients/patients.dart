import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Patients/patients_bloc.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Patients/patients_event.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Patients/patients_state.dart';
import 'patient_form_screen.dart';

class PatientListScreen extends StatelessWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PatientBloc>().add(LoadPatients()),
          ),
        ],
      ),
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          if (state is PatientLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PatientLoaded) {
            final patients = state.patients;
            final doctors = state.doctors;

            if (patients.isEmpty) {
              return const Center(child: Text('No patients found'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<PatientBloc>().add(LoadPatients());
              },
              child: ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final p = patients[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(p.name,
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${p.department} • ${p.status}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<PatientBloc>(),
                                    child: PatientFormScreen(
                                        patient: p, doctors: doctors),
                                  ),
                                ),
                              );
                              context.read<PatientBloc>().add(LoadPatients());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<PatientBloc>().add(DeletePatient(p.id));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is PatientError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Press refresh to load data'));
          }
        },
      ),
      floatingActionButton: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          // Only show FAB when doctors are loaded
          if (state is PatientLoaded) {
            final doctors = state.doctors;
            return FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<PatientBloc>(),
                      child: PatientFormScreen(
                        doctors: doctors,
                      ),
                    ),
                  ),
                );
                context.read<PatientBloc>().add(LoadPatients());
              },
              child: const Icon(Icons.add),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

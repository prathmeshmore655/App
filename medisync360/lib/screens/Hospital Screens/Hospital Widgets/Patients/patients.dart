import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_state.dart';


class PatientComponent extends StatelessWidget {
  const PatientComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientBloc()..add(LoadPatients()),
      child: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildPatientTable(context, state.patients)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Patients List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ElevatedButton.icon(
            icon: const Icon(Icons.person_add),
            label: const Text("Add Patient"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              _showAddPatientDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPatientTable(BuildContext context, List<Patient> patients) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.teal.shade50),
        border: TableBorder.all(color: Colors.grey.shade300),
        columns: const [
          DataColumn(label: Text("ID")),
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Age")),
          DataColumn(label: Text("Gender")),
          DataColumn(label: Text("Ward")),
          DataColumn(label: Text("Bed")),
          DataColumn(label: Text("Status")),
          DataColumn(label: Text("Action")),
        ],
        rows: patients.map((patient) {
          final isDischarged = patient.status == "Discharged";
          return DataRow(cells: [
            DataCell(Text(patient.id.toString())),
            DataCell(Text(patient.name)),
            DataCell(Text(patient.age.toString())),
            DataCell(Text(patient.gender)),
            DataCell(Text(patient.ward)),
            DataCell(Text(patient.bed)),
            DataCell(
              Text(
                patient.status,
                style: TextStyle(
                    color: isDischarged ? Colors.grey : Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
            DataCell(
              isDischarged
                  ? const Text("—")
                  : IconButton(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      tooltip: "Discharge Patient",
                      onPressed: () {
                        context
                            .read<PatientBloc>()
                            .add(DischargePatient(patient.id));
                      },
                    ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    String gender = "Male";
    String ward = "General";
    String bed = "B-01";

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add New Patient"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: "Patient Name"),
                ),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: const InputDecoration(labelText: "Gender"),
                  items: const [
                    DropdownMenuItem(value: "Male", child: Text("Male")),
                    DropdownMenuItem(value: "Female", child: Text("Female")),
                  ],
                  onChanged: (val) => gender = val!,
                ),
                DropdownButtonFormField<String>(
                  value: ward,
                  decoration: const InputDecoration(labelText: "Ward"),
                  items: const [
                    DropdownMenuItem(value: "General", child: Text("General")),
                    DropdownMenuItem(value: "ICU", child: Text("ICU")),
                    DropdownMenuItem(
                        value: "Emergency", child: Text("Emergency")),
                  ],
                  onChanged: (val) => ward = val!,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: "Bed No."),
                  onChanged: (val) => bed = val,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final age = int.tryParse(ageController.text) ?? 0;
                if (name.isEmpty || age <= 0) return;
                context.read<PatientBloc>().add(AddPatient(
                      name: name,
                      age: age,
                      gender: gender,
                      ward: ward,
                      bed: bed,
                    ));
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text("Add"),
            )
          ],
        );
      },
    );
  }
}

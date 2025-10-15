import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/models/doctor_models.dart';
import 'package:medisync360/models/patients_model.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_event.dart';

class PatientFormScreen extends StatefulWidget {
  final PatientModel? patient;
  final List<DoctorModel> doctors;

  const PatientFormScreen({super.key, this.patient, required this.doctors});

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  late String name;
  late int age;
  Gender? gender;
  Department? department;
  Status? status;
  late String diagnosis;
  int? selectedDoctorId;

  @override
  void initState() {
    super.initState();
    final p = widget.patient;
    name = p?.name ?? '';
    age = p?.age ?? 0;
    gender = p?.gender ?? Gender.Male;
    department = p?.department ?? Department.Cardiology;
    status = p?.status ?? Status.admitted;
    diagnosis = p?.diagnosis ?? '';
    selectedDoctorId = p?.doctor ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.patient == null ? 'Add Patient' : 'Edit Patient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter patient name' : null,
                onSaved: (val) => name = val!,
              ),

              // Age
              TextFormField(
                initialValue: age.toString(),
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter age' : null,
                onSaved: (val) => age = int.tryParse(val ?? '0') ?? 0,
              ),

              // Gender Dropdown
              DropdownButtonFormField<Gender>(
                value: gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: Gender.values
                    .map((g) => DropdownMenuItem(value: g, child: Text(g.name)))
                    .toList(),
                onChanged: (val) => setState(() => gender = val),
              ),

              // Department Dropdown
              DropdownButtonFormField<Department>(
                value: department,
                decoration: const InputDecoration(labelText: 'Department'),
                items: Department.values
                    .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
                    .toList(),
                onChanged: (val) => setState(() => department = val),
              ),

              // Doctor Dropdown
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: selectedDoctorId != 0 ? selectedDoctorId : null,
                decoration: const InputDecoration(labelText: 'Select Doctor'),
                items: widget.doctors.map((doctor) {
                  return DropdownMenuItem<int>(
                    value: doctor.id,
                    child: Text('${doctor.fullName} (${doctor.specialization})'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedDoctorId = val),
                validator: (val) =>
                    val == null ? 'Please select a doctor' : null,
              ),

              // Diagnosis
              TextFormField(
                initialValue: diagnosis,
                decoration: const InputDecoration(labelText: 'Diagnosis'),
                onSaved: (val) => diagnosis = val ?? '',
              ),

              // Status Dropdown
              DropdownButtonFormField<Status>(
                value: status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: Status.values
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                    .toList(),
                onChanged: (val) => setState(() => status = val),
              ),

              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newPatient = PatientModel(
                      id: widget.patient?.id ?? 0,
                      name: name,
                      age: age,
                      gender: gender!,
                      room: widget.patient?.room ?? '',
                      bedNumber: widget.patient?.bedNumber ?? '',
                      contactNumber: widget.patient?.contactNumber ?? '',
                      email: widget.patient?.email ?? '',
                      emergencyContact: widget.patient?.emergencyContact ?? '',
                      emergencyContactName:
                          widget.patient?.emergencyContactName ?? '',
                      medicalHistory: widget.patient?.medicalHistory ?? '',
                      allergies: widget.patient?.allergies ?? '',
                      currentMedications:
                          widget.patient?.currentMedications ?? '',
                      bloodGroup: widget.patient?.bloodGroup ?? '',
                      department: department,
                      doctorNotes: widget.patient?.doctorNotes ?? '',
                      diagnosis: diagnosis,
                      status: status!,
                      doctor: selectedDoctorId,
                    );

                    final patientBloc = context.read<PatientBloc>();

                    if (widget.patient == null) {
                      patientBloc.add(AddPatient(newPatient));
                    } else {
                      patientBloc.add(UpdatePatient(newPatient));
                    }

                    // 🔹 Reload patient list after success
                    patientBloc.add(LoadPatients());

                    Navigator.pop(context);
                  }
                },
                child: Text(
                    widget.patient == null ? 'Add Patient' : 'Update Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/models/patients_model.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_event.dart';

class PatientFormScreen extends StatefulWidget {
  final PatientModel? patient;
  const PatientFormScreen({super.key, this.patient});

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, gender, department, status, diagnosis;
  late int age;

  @override
  void initState() {
    super.initState();
    name = widget.patient?.name ?? '';
    gender = widget.patient?.gender ?? '';
    department = widget.patient?.department ?? '';
    status = widget.patient?.status ?? '';
    diagnosis = widget.patient?.diagnosis ?? '';
    age = widget.patient?.age ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.patient == null ? 'Add Patient' : 'Edit Patient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) => val == null || val.isEmpty ? 'Enter patient name' : null,
                onSaved: (val) => name = val!,
              ),
              TextFormField(
                initialValue: age.toString(),
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? 'Enter age' : null,
                onSaved: (val) => age = int.tryParse(val ?? '0') ?? 0,
              ),
              TextFormField(
                initialValue: gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                onSaved: (val) => gender = val ?? '',
              ),
              TextFormField(
                initialValue: department,
                decoration: const InputDecoration(labelText: 'Department'),
                onSaved: (val) => department = val ?? '',
              ),
              TextFormField(
                initialValue: diagnosis,
                decoration: const InputDecoration(labelText: 'Diagnosis'),
                onSaved: (val) => diagnosis = val ?? '',
              ),
              TextFormField(
                initialValue: status,
                decoration: const InputDecoration(labelText: 'Status'),
                onSaved: (val) => status = val ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newPatient = PatientModel(
                      id: widget.patient?.id ?? 0,
                      name: name,
                      age: age,
                      gender: gender,
                      room: widget.patient?.room ?? '',
                      bedNumber: widget.patient?.bedNumber ?? '',
                      contactNumber: widget.patient?.contactNumber ?? '',
                      email: widget.patient?.email ?? '',
                      emergencyContact: widget.patient?.emergencyContact ?? '',
                      emergencyContactName: widget.patient?.emergencyContactName ?? '',
                      medicalHistory: widget.patient?.medicalHistory ?? '',
                      allergies: widget.patient?.allergies ?? '',
                      currentMedications: widget.patient?.currentMedications ?? '',
                      bloodGroup: widget.patient?.bloodGroup ?? '',
                      department: department,
                      admissionDate: widget.patient?.admissionDate ?? '',
                      dischargeDate: widget.patient?.dischargeDate ?? '',
                      doctorNotes: widget.patient?.doctorNotes ?? '',
                      diagnosis: diagnosis,
                      status: status,
                      hospital: widget.patient?.hospital ?? 0,
                      doctor: widget.patient?.doctor ?? 0,
                    );

                    if (widget.patient == null) {
                      context.read<PatientBloc>().add(AddPatient(newPatient));
                    } else {
                      context.read<PatientBloc>().add(UpdatePatient(newPatient));
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(widget.patient == null ? 'Add Patient' : 'Update Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

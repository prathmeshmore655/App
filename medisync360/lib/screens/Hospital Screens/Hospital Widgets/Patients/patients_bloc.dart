import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_state.dart';


class PatientBloc extends Bloc<PatientEvent, PatientState> {
  PatientBloc() : super(const PatientState()) {
    on<LoadPatients>(_onLoadPatients);
    on<AddPatient>(_onAddPatient);
    on<DischargePatient>(_onDischargePatient);
  }

  Future<void> _onLoadPatients(
      LoadPatients event, Emitter<PatientState> emit) async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 1)); // simulate API

    final demoPatients = [
      const Patient(
          id: 1,
          name: "Ravi Kumar",
          age: 45,
          gender: "Male",
          ward: "ICU",
          bed: "B-05",
          status: "Admitted"),
      const Patient(
          id: 2,
          name: "Anita Desai",
          age: 30,
          gender: "Female",
          ward: "General",
          bed: "G-12",
          status: "Admitted"),
      const Patient(
          id: 3,
          name: "John Mathew",
          age: 52,
          gender: "Male",
          ward: "Emergency",
          bed: "E-03",
          status: "Discharged"),
    ];

    emit(state.copyWith(isLoading: false, patients: demoPatients));
  }

  void _onAddPatient(AddPatient event, Emitter<PatientState> emit) {
    final newPatient = Patient(
      id: state.patients.length + 1,
      name: event.name,
      age: event.age,
      gender: event.gender,
      ward: event.ward,
      bed: event.bed,
      status: "Admitted",
    );

    emit(state.copyWith(patients: [...state.patients, newPatient]));
  }

  void _onDischargePatient(
      DischargePatient event, Emitter<PatientState> emit) {
    final updated = state.patients.map((p) {
      if (p.id == event.patientId) {
        return p.copyWith(status: "Discharged");
      }
      return p;
    }).toList();

    emit(state.copyWith(patients: updated));
  }
}

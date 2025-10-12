import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/patient_repositories.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_state.dart';


class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository repository;

  PatientBloc(this.repository) : super(PatientInitial()) {
    on<LoadPatients>((event, emit) async {
      emit(PatientLoading());
      try {
        final patients = await repository.getPatients();
        emit(PatientLoaded(patients));
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });

    on<AddPatient>((event, emit) async {
      try {
        await repository.addPatient(event.patient);
        add(LoadPatients());
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });

    on<UpdatePatient>((event, emit) async {
      try {
        await repository.updatePatient(event.patient);
        add(LoadPatients());
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });

    on<DeletePatient>((event, emit) async {
      try {
        await repository.deletePatient(event.id);
        add(LoadPatients());
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/doctor_repository.dart';
import 'package:medisync360/Repositiories/patient_repositories.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_state.dart';


class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository patientRepository;
  final DoctorRepository doctorRepository;

  PatientBloc(this.patientRepository, this.doctorRepository) : super(PatientInitial()) {


    // Future<void> _loadPatients(Emitter<PatientState> emit) async {
    //   emit(PatientLoading());
    //   try {
    //     final patients = await patientRepository.getPatients();
    //     final doctors = await doctorRepository.fetchDoctors();
    //     emit(PatientLoaded(patients: patients, doctors: doctors));
    //   } catch (e) {
    //     emit(PatientError(e.toString()));
    //   }
    // }


    on<LoadPatients>((event, emit) async {
      emit(PatientLoading());
      try {
        final patients = await patientRepository.getPatients();
        final doctors = await doctorRepository.fetchDoctors();

        emit(PatientLoaded(patients: patients, doctors: doctors));
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });

    on<AddPatient>((event, emit) async {
      try {
        await patientRepository.addPatient(event.patient);
        
        add(LoadPatients());
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });

    on<UpdatePatient>((event, emit) async {
      try {
        await patientRepository.updatePatient(event.patient);
        add(LoadPatients());
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });

    on<DeletePatient>((event, emit) async {
      try {
        await patientRepository.deletePatient(event.id);
        add(LoadPatients());
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });

   
  }
}

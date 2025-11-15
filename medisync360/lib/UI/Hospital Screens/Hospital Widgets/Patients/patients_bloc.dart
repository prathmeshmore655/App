import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Data/Repositories/doctor_repository.dart';
import 'package:medisync360/Data/Repositories/patient_repositories.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Patients/patients_event.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Patients/patients_state.dart';
import 'package:medisync360/Data/Models/patients_model.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository patientRepository;
  final DoctorRepository doctorRepository;

  PatientBloc(this.patientRepository, this.doctorRepository)
      : super(PatientInitial()) {

    // ----------------------------------------------------
    // ✅ Load Patients
    // ----------------------------------------------------
    on<LoadPatients>((event, emit) async {
      emit(PatientLoading());
      try {
        final patients = await patientRepository.getPatients();
        final doctors = await doctorRepository.fetchDoctors();

        emit(PatientLoaded(patients: patients, doctors: doctors));
      } catch (e) {
        emit(PatientError("Failed to load patients: $e"));
      }
    });

    // ----------------------------------------------------
    // ✅ Add Patient
    // ----------------------------------------------------
    on<AddPatient>((event, emit) async {
      try {
        await patientRepository.addPatient(event.patient);
        add(LoadPatients());
      } catch (e) {
        emit(PatientError("Failed to add patient: $e"));
      }
    });

    // ----------------------------------------------------
    // ✅ Update Patient
    // ----------------------------------------------------
    on<UpdatePatient>((event, emit) async {
      try {
        // Convert PatientEntities → PatientModel for update
        final patientModel = PatientModel(
          id: event.patient.id,
          name: event.patient.name,
          age: event.patient.age,
          gender: event.patient.gender,
          room: event.patient.room,
          bedNumber: event.patient.bedNumber,
          contactNumber: event.patient.contactNumber,
          email: event.patient.email,
          emergencyContact: event.patient.emergencyContact,
          emergencyContactName: event.patient.emergencyContactName,
          medicalHistory: event.patient.medicalHistory,
          allergies: event.patient.allergies,
          currentMedications: event.patient.currentMedications,
          bloodGroup: event.patient.bloodGroup,
          department: event.patient.department,
          admissionDate: event.patient.admissionDate,
          dischargeDate: event.patient.dischargeDate,
          doctorNotes: event.patient.doctorNotes,
          diagnosis: event.patient.diagnosis,
          status: event.patient.status,
          hospital: event.patient.hospital,
          doctor: event.patient.doctor,
        );

        await patientRepository.updatePatient(patientModel);

        add(LoadPatients());
      } catch (e) {
        emit(PatientError("Failed to update patient: $e"));
      }
    });

    // ----------------------------------------------------
    // ✅ Delete Patient
    // ----------------------------------------------------
    on<DeletePatient>((event, emit) async {
      try {
        await patientRepository.deletePatient(event.id);
        add(LoadPatients());
      } catch (e) {
        emit(PatientError("Failed to delete patient: $e"));
      }
    });
  }
}

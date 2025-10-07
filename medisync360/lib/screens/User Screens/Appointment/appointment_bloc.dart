// bloc/appointment_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medisync360/Repositiories/appointment_repository.dart';
import 'package:medisync360/screens/User%20Screens/Appointment/appointment_event.dart';
import 'package:medisync360/screens/User%20Screens/Appointment/appointment_state.dart';


class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository repository;

  AppointmentBloc({required this.repository}) : super(AppointmentInitial()) {
    on<LoadDoctors>((event, emit) async {
      emit(AppointmentLoading());
      final doctors = await repository.getDoctors();
      emit(DoctorsLoaded(doctors));
    });

    on<LoadHospitals>((event, emit) async {
      emit(AppointmentLoading());
      final hospitals = await repository.getHospitals();
      emit(HospitalsLoaded(hospitals));
    });

    on<LoadSlots>((event, emit) async {
      emit(AppointmentLoading());
      final slots = await repository.getSlots(event.doctorId, event.hospitalId);
      emit(SlotsLoaded(slots));
    });

    on<BookAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());
      final success = await repository.bookAppointment(event.doctorId, event.hospitalId, event.slotId);
      emit(AppointmentBooked(success));
    });
  }
}

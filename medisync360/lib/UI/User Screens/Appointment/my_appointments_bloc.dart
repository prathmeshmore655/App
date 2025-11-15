// bloc/my_appointments_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Data/Repositories/appointment_repository.dart';
import 'my_appointments_event.dart';
import 'my_appointments_state.dart';


class MyAppointmentsBloc extends Bloc<MyAppointmentsEvent, MyAppointmentsState> {
  final MyAppointmentRepository repository;

  MyAppointmentsBloc({required this.repository}) : super(MyAppointmentsInitial()) {
    on<LoadAppointments>((event, emit) async {
      emit(MyAppointmentsLoading());
      try {
        final data = await repository.getAppointments();
        emit(MyAppointmentsLoaded(data));
      } catch (e) {
        emit(MyAppointmentsError("Failed to load appointments"));
      }
    });
  }
}

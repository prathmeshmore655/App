import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/hospital_repository.dart';
import 'hospital_event.dart';
import 'hospital_state.dart';

class HospitalBloc extends Bloc<HospitalEvent, HospitalState> {
  final HospitalRepository repository;

  HospitalBloc({required this.repository}) : super(HospitalInitial()) {
    on<FetchHospitalEvent>(_onFetchHospital);
  }

  Future<void> _onFetchHospital(
      FetchHospitalEvent event, Emitter<HospitalState> emit) async {
    emit(HospitalLoading());
    try {
      final hospital = await repository.fetchHospitalProfile();
      final beds = await repository.fetchHospitalBeds();
      emit(HospitalLoaded(hospital, beds));
    } catch (e) {
      emit(HospitalError("Error: $e"));
    }
  }
}

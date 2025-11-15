import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Data/Repositories/hospital_repository.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Live%20Capacity%20View/live_capacity_view_state.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Live%20Capacity%20View/live_capcity_view_event.dart';

class HospitalCapacityBloc extends Bloc<HospitalCapacityEvent, HospitalCapacityState> {
  final HospitalRepository repository;

  HospitalCapacityBloc(this.repository) : super(HospitalInitial()) {
    on<FetchHospitals>((event, emit) async {
      emit(HospitalLoading());
      try {
        final hospitals = await repository.fetchHospitalsLiveCapacity();
        emit(HospitalLoaded(hospitals));
      } catch (e) {
        emit(HospitalError(e.toString()));
      }
    });
  }
}

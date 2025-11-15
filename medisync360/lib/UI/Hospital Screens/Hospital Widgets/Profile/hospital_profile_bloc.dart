import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Data/Repositories/hospital_repository.dart';
import 'hospital_profile_event.dart';
import 'hospital_profile_state.dart';



class HospitalProfileBloc extends Bloc<HospitalProfileEvent, HospitalProfileState> {
  final HospitalRepository hospitalRepository;

  HospitalProfileBloc(this.hospitalRepository) : super(HospitalProfileInitial()) {
    on<FetchHospitalProfile>(_onFetchHospitalProfile);
  }

  Future<void> _onFetchHospitalProfile(
      FetchHospitalProfile event, Emitter<HospitalProfileState> emit) async {
    emit(HospitalProfileLoading());
    try {
      final hospital = await hospitalRepository.fetchHospitalProfile();
      emit(HospitalProfileLoaded(hospital));
    } catch (e) {
      emit(HospitalProfileError(e.toString()));
    }
  }
}

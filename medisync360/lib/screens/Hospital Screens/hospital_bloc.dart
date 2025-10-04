import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/hospital_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/hospital_state.dart';

class HospitalDashboardBloc
    extends Bloc<HospitalDashboardEvent, HospitalDashboardState> {
  HospitalDashboardBloc() : super(const HospitalDashboardState()) {
    on<LoadHospitalData>(_onLoadHospitalData);
    on<ChangeDashboardTab>(_onChangeDashboardTab);
  }

  Future<void> _onLoadHospitalData(
      LoadHospitalData event, Emitter<HospitalDashboardState> emit) async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 1)); // simulate API

    emit(state.copyWith(
      isLoading: false,
      hospitalName: "CityCare Hospital",
      regId: "HSP-0923",
      established: "2010",
      location: "Pune, Maharashtra",
      totalBeds: 120,
      occupiedBeds: 85,
      totalPatients: 3400,
      doctorsCount: 56,
    ));
  }

  void _onChangeDashboardTab(
      ChangeDashboardTab event, Emitter<HospitalDashboardState> emit) {
    emit(state.copyWith(selectedTabIndex: event.tabIndex));
  }
}

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:medisync360/Services/api_service.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Nearby%20Hospitals/nearby_hospital_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Nearby%20Hospitals/nearby_hospital_state.dart';


class HospitalMapBloc extends Bloc<HospitalMapEvent, HospitalMapState> {
  HospitalMapBloc() : super(const HospitalMapState()) {
    on<LoadHospitals>(_onLoadHospitals);
  }

  Future<void> _onLoadHospitals(
      LoadHospitals event, Emitter<HospitalMapState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await ApiService.request(  
        '/auth/hospital/all-hospitals-info/',
        method: 'GET',
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final hospitals = data.map((e) => HospitalInfo.fromJson(e)).toList();

        emit(state.copyWith(isLoading: false, hospitals: hospitals));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print("Error loading hospitals: $e");
      emit(state.copyWith(isLoading: false));
    }
  }
}

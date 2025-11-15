import 'dart:convert';
import 'package:medisync360/utils/Services/api_service.dart';
import 'package:medisync360/Data/Models/hospital_beds_model.dart';
import 'package:medisync360/Data/Models/hospital_model.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Live%20Capacity%20View/live_capacity_view_model.dart';


class HospitalRepository {
  Future<HospitalModel> fetchHospitalProfile() async {
    final response = await ApiService.request('/auth/hospital/info/'); // Adjust endpoint

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HospitalModel.fromJson(data);
    } else {
      throw Exception('Failed to load hospital profile');
    }
  }



   Future<HospitalBedsModel> fetchHospitalBeds() async {
    final response = await ApiService.request('/auth/hospital/beds/');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HospitalBedsModel.fromJson(data);
    } else {
      throw Exception("Failed to load hospital beds data");
    }
  }



    Future<List<HospitalLiveCapacity>> fetchHospitalsLiveCapacity() async {
    final response = await ApiService.request('/auth/hospital/live-capacity-view/');

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => HospitalLiveCapacity.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load hospitals');
    }

  }

}
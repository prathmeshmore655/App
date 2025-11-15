import 'dart:convert';
import 'package:medisync360/Domain/Entities/Hospital/hospital_beds_entities.dart';
import 'package:medisync360/Domain/Entities/Hospital/hospital_entities.dart';
import 'package:medisync360/Domain/Entities/Hospital/live_caapcity_view_entities.dart';
import 'package:medisync360/utils/Services/api_service.dart';
import 'package:medisync360/Data/Models/hospital_beds_model.dart';
import 'package:medisync360/Data/Models/hospital_model.dart';
import 'package:medisync360/Data/Models/live_capacity_view_model.dart';


class HospitalRepository {
  Future<HospitalEntities> fetchHospitalProfile() async {
    final response = await ApiService.request('/auth/hospital/info/'); // Adjust endpoint

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HospitalModel.fromJson(data).toDomain();
    } else {
      throw Exception('Failed to load hospital profile');
    }
  }



   Future<HospitalBedsEntities> fetchHospitalBeds() async {
    final response = await ApiService.request('/auth/hospital/beds/');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HospitalBedsModel.fromJson(data).toDomain();
    } else {
      throw Exception("Failed to load hospital beds data");
    }
  }



    Future<List<LiveCaapcityViewEntities>> fetchHospitalsLiveCapacity() async {
    final response = await ApiService.request('/auth/hospital/live-capacity-view/');

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return (data.map((e) => LiveCapacityViewModel.fromJson(e).toDomain())).toList();
    } else {
      throw Exception('Failed to load hospitals');
    }

  }

}
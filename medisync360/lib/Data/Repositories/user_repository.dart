import 'dart:convert';
import 'package:medisync360/Domain/Entities/User/user_entities.dart';
import 'package:medisync360/utils/Services/api_service.dart';

import '../Models/user_model.dart';

class UserRepository {
  Future<UserEntities> fetchUserProfile() async {
    final response = await ApiService.request('/auth/me'); // your endpoint

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) ;
      final user = UserModel.fromJson(data).toDomain();

      return user;
    } else {
      throw Exception('Failed to fetch user data: ${response.statusCode}');
    }
  }
}

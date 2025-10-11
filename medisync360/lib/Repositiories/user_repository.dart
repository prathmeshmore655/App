import 'dart:convert';
import 'package:medisync360/Services/api_service.dart';

import '../models/user_model.dart';

class UserRepository {
  Future<UserModel> fetchUserProfile() async {
    final response = await ApiService.request('/auth/me'); // your endpoint

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch user data: ${response.statusCode}');
    }
  }
}

import 'package:medisync360/Domain/Entities/User/user_entities.dart';

abstract class UserRepositoryDomain {

  Future<UserEntities> fetchUserProfile();
 
}
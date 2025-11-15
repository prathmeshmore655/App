import 'package:medisync360/Domain/Entities/User/user_entities.dart';

class UserModel {
  final int id;
  final String username;
  final String email;
  final bool isStaff;
  final bool isSuperuser;
  final String userType;
  final String dateJoined;
  final String? name;
  final String? phone;
  final String? address;
  final String? profilePicture;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.isStaff,
    required this.isSuperuser,
    required this.userType,
    required this.dateJoined,
    this.name,
    this.phone,
    this.address,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      isStaff: json['is_staff'],
      isSuperuser: json['is_superuser'],
      userType: json['user_type'],
      dateJoined: json['date_joined'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      profilePicture: json['profile_picture'],
    );
  }

  UserEntities toDomain(){

    return UserEntities(
      id: id, 
      username: username, 
      email: email, 
      isStaff: isStaff, 
      isSuperuser: isSuperuser, 
      userType: userType, 
      dateJoined: dateJoined , 
      name : name ,
      phone: phone ,
      address: address ,
      profilePicture: profilePicture
      );
  }

}

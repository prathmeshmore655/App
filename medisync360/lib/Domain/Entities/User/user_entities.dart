class UserEntities {
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

  UserEntities({
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
}
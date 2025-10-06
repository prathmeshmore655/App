abstract class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {
  final String token;
  LoadUserProfile(this.token);
}

class UpdateUserProfile extends ProfileEvent {
  final String token;
  final Map<String, dynamic> updatedData;
  UpdateUserProfile(this.token, this.updatedData);
}

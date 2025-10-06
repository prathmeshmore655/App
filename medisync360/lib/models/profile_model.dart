class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String gender;
  final String address;
  final String avatarUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    required this.address,
    required this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '1',
      name: json['name'] ?? 'John Doe',
      email: json['email'] ?? 'john@example.com',
      phone: json['phone'] ?? '+91 9876543210',
      age: json['age'] ?? 30,
      gender: json['gender'] ?? 'Male',
      address: json['address'] ?? 'Pune, India',
      avatarUrl: json['avatarUrl'] ??
          'https://avatars.githubusercontent.com/u/9919?s=200&v=4',
    );
  }
}

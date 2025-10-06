import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/screens/User%20Screens/Profile/profile_bloc.dart';
import 'package:medisync360/screens/User%20Screens/Profile/profile_event.dart';
import 'package:medisync360/screens/User%20Screens/Profile/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String token = "dummy_jwt_token";

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadUserProfile(token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final user = state.profile;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  const SizedBox(height: 12),
                  Text(user.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(user.email, style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 32),

                  _buildInfoTile("Phone", user.phone),
                  _buildInfoTile("Age", user.age.toString()),
                  _buildInfoTile("Gender", user.gender),
                  _buildInfoTile("Address", user.address),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: () {
                      final updated = {
                        "name": "John Updated",
                        "address": "Mumbai, India"
                      };
                      context
                          .read<ProfileBloc>()
                          .add(UpdateUserProfile(token, updated));
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Simulate Update"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProfileUpdated) {
            return const Center(child: Text("Profile updated successfully ✅"));
          } else if (state is ProfileError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value.isEmpty ? 'Not provided' : value),
    );
  }
}

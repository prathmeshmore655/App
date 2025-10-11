import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/user_repository.dart';
import 'package:medisync360/screens/User%20Screens/Profile/profile_bloc.dart';
import 'package:medisync360/screens/User%20Screens/Profile/profile_event.dart';
import 'package:medisync360/screens/User%20Screens/Profile/profile_state.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc(UserRepository())..add(FetchUserProfile()),
      child: Scaffold(
        appBar: AppBar(title: const Text('User Profile')),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final user = state.user;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user.profilePicture != null
                          ? NetworkImage(user.profilePicture!)
                          : null,
                      child: user.profilePicture == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text("Username: ${user.username}",
                        style: const TextStyle(fontSize: 18)),
                    Text("Email: ${user.email}",
                        style: const TextStyle(fontSize: 16)),
                    Text("User Type: ${user.userType}",
                        style: const TextStyle(fontSize: 16)),
                    const Divider(),
                    Text("Joined: ${user.dateJoined}",
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              );
            } else if (state is UserError) {
              return Center(child: Text("❌ ${state.message}"));
            } else {
              return const Center(child: Text("No user data available."));
            }
          },
        ),
      ),
    );
  }
}

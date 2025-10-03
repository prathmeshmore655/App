import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/auth_repository.dart';
import 'package:medisync360/screens/SignUp/signup_bloc.dart';
import 'package:medisync360/screens/SignUp/signup_event.dart';
import 'package:medisync360/screens/SignUp/signup_state.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(authRepository: AuthRepository()),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600), // responsive
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_add, size: 80, color: Colors.blue),
                    const SizedBox(height: 15),
                    const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25),
                    BlocConsumer<SignupBloc, SignupState>(
                      listener: (context, state) {
                        if (state.isSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Signup Successful 🎉")),
                          );
                          Navigator.pushReplacementNamed(context, '/home');
                        } else if (state.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage!)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            // username
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Username",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                context.read<SignupBloc>().add(SignupUsernameChanged(value));
                              },
                            ),
                            const SizedBox(height: 15),

                            // email
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                context.read<SignupBloc>().add(SignupEmailChanged(value));
                              },
                            ),
                            const SizedBox(height: 15),

                            // password
                            TextField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                context.read<SignupBloc>().add(SignupPasswordChanged(value));
                              },
                            ),
                            const SizedBox(height: 15),

                            // confirm password
                            TextField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Confirm Password",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                context.read<SignupBloc>().add(SignupConfirmPasswordChanged(value));
                              },
                            ),
                            const SizedBox(height: 15),

                            // dropdown for user type
                            DropdownButtonFormField<String>(
                              value: state.userType,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Account Type",
                              ),
                              items: const [
                                DropdownMenuItem(value: "user", child: Text("User")),
                                DropdownMenuItem(value: "doctor", child: Text("Doctor")),
                                DropdownMenuItem(value: "hospital", child: Text("Hospital")),
                              ],
                              onChanged: (value) {
                                context.read<SignupBloc>().add(SignupUserTypeChanged(value!));
                              },
                            ),
                            const SizedBox(height: 15),

                            // Additional fields for Doctor
                            if (state.userType == "doctor") ...[
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Full Name",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("full_name", v)),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Specialization",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("specialization", v)),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Degrees",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("degrees", v)),
                              ),
                              const SizedBox(height: 12),

                              // Fetch Location Button
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<SignupBloc>().add(FetchLocationRequested());
                                },
                                icon: const Icon(Icons.location_on),
                                label: const Text("Fetch Location"),
                              ),
                              if (state.latitude != null && state.longitude != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    "📍 Location fetched: ${state.latitude}, ${state.longitude}",
                                    style: const TextStyle(fontSize: 14, color: Colors.green),
                                  ),
                                ),
                              const SizedBox(height: 15),
                            ],

                            // Additional fields for Hospital
                            if (state.userType == "hospital") ...[
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Hospital Name",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("name", v)),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Registration Number",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("registration_number", v)),
                              ),
                              const SizedBox(height: 12),

                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<SignupBloc>().add(FetchLocationRequested());
                                },
                                icon: const Icon(Icons.location_on),
                                label: const Text("Fetch Location"),
                              ),
                              if (state.latitude != null && state.longitude != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    "📍 Location fetched: ${state.latitude}, ${state.longitude}",
                                    style: const TextStyle(fontSize: 14, color: Colors.green),
                                  ),
                                ),
                              const SizedBox(height: 15),
                            ],

                            const SizedBox(height: 20),

                            state.isSubmitting
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(double.infinity, 50),
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: state.isValid
                                        ? () {
                                            context.read<SignupBloc>().add(SignupSubmitted());
                                          }
                                        : null,
                                    child: const Text("Sign Up", style: TextStyle(fontSize: 18)),
                                  ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Already have an account? Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

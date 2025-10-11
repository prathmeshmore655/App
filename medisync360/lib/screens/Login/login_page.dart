import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/auth_repository.dart';
import 'package:medisync360/Repositiories/hospital_repository.dart';
import 'package:medisync360/screens/Hospital%20Screens/hospital_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/hospital_dashboard_page.dart';
import 'package:medisync360/screens/Hospital%20Screens/hospital_event.dart';
import 'package:medisync360/screens/Login/login_bloc.dart';
import 'package:medisync360/screens/Login/login_event.dart';
import 'package:medisync360/screens/Login/login_state.dart';
import 'package:medisync360/screens/SignUp/signup_page.dart';
import 'package:medisync360/screens/User%20Screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) => LoginBloc(authRepository: AuthRepository()),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 900) {
                return _buildMobileLayout(context);
              } else {
                return _buildDesktopLayout(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildLeftContent(isMobile: true),
            const SizedBox(height: 40),
            _buildLoginForm(context, isMobile: true),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left Side - Branding & Content
        Expanded(
          flex: 5,
          child: _buildLeftContent(isMobile: false),
        ),
        const SizedBox(width: 60),
        // Right Side - Login Form
        Expanded(
          flex: 4,
          child: _buildLoginForm(context, isMobile: false),
        ),
      ],
    );
  }

  Widget _buildLeftContent({required bool isMobile}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 24 : 32,
        horizontal: isMobile ? 16 : 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo with enhanced design
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color(0xFFE3F2FD)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.medical_services,
                size: 80,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Main Heading
          Text(
            "Welcome to MediSync360",
            style: TextStyle(
              fontSize: isMobile ? 32 : 42,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              height: 1.2,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
          const SizedBox(height: 16),
          // Subtitle
          Text(
            "Your Comprehensive Healthcare Companion",
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
          const SizedBox(height: 24),
          // Features List
          _buildFeatureItem(Icons.health_and_safety, "Health Monitoring", isMobile),
          _buildFeatureItem(Icons.calendar_today, "Appointment Scheduling", isMobile),
          _buildFeatureItem(Icons.analytics, "Health Analytics", isMobile),
          const SizedBox(height: 32),
          // Additional Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.security, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Your health data is securely encrypted and protected",
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, {required bool isMobile}) {
    return SingleChildScrollView(
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Login Successful ✅"),
                backgroundColor: Colors.green,
              ),
            );
            // Role-based navigation
            if (state.userType == 'User') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            } else if (state.userType == 'Hospital') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => HospitalBloc(repository: HospitalRepository())..add(FetchHospitalEvent()),
                    child: const HospitalDashboardScreen(),
                  ),
                ),
              );
            } else if (state.userType == 'Doctor') {
              // TODO: Replace with actual Doctor screen when available
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Doctor screen not implemented yet."),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.all(isMobile ? 24 : 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign in to continue your health journey",
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // User Type Dropdown
                _buildUserTypeDropdown(state, context),
                const SizedBox(height: 20),
                // Username Field
                _buildEmailField(state, context),
                const SizedBox(height: 20),
                // Password Field
                _buildPasswordField(state, context),
                const SizedBox(height: 24),
                // Login Button
                _buildLoginButton(state, context),
                // Create Account
                _buildSignUpSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserTypeDropdown(LoginState state, BuildContext context) {
    final userTypes = ['User', 'Doctor', 'Hospital'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "User Type",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: state.userType,
          items: userTypes
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<LoginBloc>().add(LoginUserTypeChanged(value));
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(LoginState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Username",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "Enter your Username ",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            prefixIcon: const Icon(Icons.people, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            errorText: null,
          ),
          onChanged: (value) {
            print("Changing");
            context.read<LoginBloc>().add(LoginEmailChanged(value));
          },
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildPasswordField(LoginState state, BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPasswordVisible = false;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Password",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                hintText: "Enter your password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                errorText: null,
              ),
              onChanged: (value) {
                context.read<LoginBloc>().add(LoginPasswordChanged(value));
              },
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                if (state.isValid && !state.isSubmitting) {
                  context.read<LoginBloc>().add(LoginSubmitted());
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoginButton(LoginState state, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: state.isSubmitting
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Colors.blue.withOpacity(0.4),
              ),
              onPressed: state.isValid && !state.isSubmitting
                  ? () {
                      // Hide keyboard when login is pressed
                      FocusScope.of(context).unfocus();
                      context.read<LoginBloc>().add(LoginSubmitted());
                    }
                  : null,
              child: const Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  Widget _buildSignUpSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
          },
          child: RichText(
            text: const TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(color: Colors.grey),
              children: [
                TextSpan(
                  text: "Sign up",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Forgot Password"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Enter your email address and we'll send you a password reset link."),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle password reset
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Password reset link sent!"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Send Link"),
          ),
        ],
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    // Implement social login functionality
    print('Social login with $provider');
  }
}
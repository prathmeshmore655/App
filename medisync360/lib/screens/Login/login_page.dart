import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/auth_repository.dart';
import 'package:medisync360/screens/Login/login_bloc.dart';
import 'package:medisync360/screens/Login/login_event.dart';
import 'package:medisync360/screens/Login/login_state.dart';
import 'package:medisync360/screens/SignUp/signup_page.dart';
import 'package:medisync360/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(authRepository: AuthRepository()),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE3F2FD),
                    Color(0xFFBBDEFB),
                    Color(0xFF90CAF9),
                  ],
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isMobile = constraints.maxWidth < 800;
                  return Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? 500 : 1200,
                      ),
                      margin: EdgeInsets.all(
                        isMobile ? 16 : 24,
                      ),
                      child: isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLeftContent(isMobile: true),
        const SizedBox(height: 32),
        _buildLoginForm(context, isMobile: true),
      ],
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
          // _buildFeatureItem(Icons.medication, "Medication Management", isMobile),
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
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Successful ✅"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
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

              // Email Field
              _buildEmailField(state, context),
              const SizedBox(height: 20),
              
              // Password Field
              _buildPasswordField(state, context),
              const SizedBox(height: 24),

              // Remember Me & Forgot Password
              // _buildRememberForgotSection(context, isMobile),
              // const SizedBox(height: 24),

              // Login Button
              _buildLoginButton(state, context),
              
              // Divider
              // const SizedBox(height: 32),
              // _buildDivider(),
              // const SizedBox(height: 24),

              // Social Login Buttons
              // _buildSocialLoginButtons(isMobile),

              // Create Account
              // const SizedBox(height: 32),
              _buildSignUpSection(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmailField(LoginState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email Address",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "Enter your email",
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
            prefixIcon: const Icon(Icons.email, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            // errorText: state.email.isEmpty ? null : state.emailError,
            errorText: null,
          ),
          onChanged: (value) {
            context.read<LoginBloc>().add(LoginEmailChanged(value));
          },
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildPasswordField(LoginState state, BuildContext context) {
    bool isPasswordVisible = false;
    
    return StatefulBuilder(
      builder: (context, setState) {
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
                // errorText: state.password.isEmpty ? null : state.passwordError,
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

  // Widget _buildRememberForgotSection(BuildContext context, bool isMobile) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Row(
  //         children: [
  //           Container(
  //             width: 20,
  //             height: 20,
  //             decoration: BoxDecoration(
  //               border: Border.all(color: Colors.grey),
  //               borderRadius: BorderRadius.circular(4),
  //             ),
  //             child: const Icon(Icons.check, size: 16, color: Colors.blue),
  //           ),
  //           const SizedBox(width: 8),
  //           Text(
  //             "Remember me",
  //             style: TextStyle(
  //               fontSize: isMobile ? 13 : 14,
  //               color: Colors.grey,
  //             ),
  //           ),
  //         ],
  //       ),
  //       TextButton(
  //           onPressed: () {
  //             _showForgotPasswordDialog(context);
  //           },
  //         child: Text(
  //           "Forgot Password?",
  //           style: TextStyle(
  //             color: Colors.blue,
  //             fontWeight: FontWeight.w500,
  //             fontSize: isMobile ? 13 : 14,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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



  // Widget _buildDivider() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Divider(color: Colors.grey.withOpacity(0.3)),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16),
  //         child: Text(
  //           "or continue with",
  //           style: TextStyle(
  //             fontSize: 12,
  //             color: Colors.grey.withOpacity(0.7),
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: Divider(color: Colors.grey.withOpacity(0.3)),
  //       ),
  //     ],
  //   );
  // }



  // Widget _buildSocialLoginButtons(bool isMobile) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: OutlinedButton.icon(
  //           style: OutlinedButton.styleFrom(
  //             foregroundColor: Colors.blueGrey,
  //             side: BorderSide(color: Colors.grey.withOpacity(0.3)),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             padding: const EdgeInsets.symmetric(vertical: 12),
  //           ),
  //           onPressed: () {
  //             _handleSocialLogin('google');
  //           },
  //           icon: const Icon(Icons.g_mobiledata, size: 24),
  //           label: const Text("Google"),
  //         ),
  //       ),
  //       SizedBox(width: isMobile ? 12 : 16),
  //       Expanded(
  //         child: OutlinedButton.icon(
  //           style: OutlinedButton.styleFrom(
  //             foregroundColor: Colors.blueGrey,
  //             side: BorderSide(color: Colors.grey.withOpacity(0.3)),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             padding: const EdgeInsets.symmetric(vertical: 12),
  //           ),
  //           onPressed: () {
  //             _handleSocialLogin('apple');
  //           },
  //           icon: const Icon(Icons.apple, size: 24),
  //           label: const Text("Apple"),
  //         ),
  //       ),
  //     ],
  //   );
  // }


  Widget _buildSignUpSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: TextButton(
              onPressed: () {
                
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
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
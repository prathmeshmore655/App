import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Repositiories/auth_repository.dart';
import 'package:medisync360/screens/Hospital%20Screens/hospital_dashboard_page.dart';
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
                      maxWidth: isMobile ? 500 : 800,
                    ),
                    margin: EdgeInsets.all(isMobile ? 16 : 24),
                    child: isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildHeaderSection(isMobile: true),
        const SizedBox(height: 32),
        // Make only the form scrollable with a max height
        Expanded(
          child: SingleChildScrollView(
            child: _buildSignupForm(context, isMobile: true),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left Side - Branding
        Expanded(
          flex: 4,
          child: _buildBrandingSection(),
        ),
        const SizedBox(width: 40),
        // Right Side - Form (scrollable)
        Expanded(
          flex: 6,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight,
                child: SingleChildScrollView(
                  child: _buildSignupForm(context, isMobile: false),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBrandingSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(20),
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
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.medical_services,
              size: 60,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 32),
          
          // Main Heading
          const Text(
            "Join MediSync360",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          
          // Subtitle
          const Text(
            "Create your account and start your journey towards better healthcare management",
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          
          // Features List
          _buildFeatureItem(Icons.verified_user, "Secure & Private"),
          _buildFeatureItem(Icons.health_and_safety, "Health Tracking"),
          _buildFeatureItem(Icons.medical_services, "Expert Care"),
          _buildFeatureItem(Icons.schedule, "24/7 Support"),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection({required bool isMobile}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
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
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add_alt_1,
            size: 50,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Create Account",
          style: TextStyle(
            fontSize: isMobile ? 28 : 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Join thousands of healthcare professionals and users",
          style: TextStyle(
            fontSize: 14,
            color: Colors.blueGrey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSignupForm(BuildContext context, {required bool isMobile}) {
    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account created successfully! 🎉"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, MaterialPageRoute(builder:(context) => HospitalDashboardScreen()) as String);
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(isMobile ? 24 : 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMobile) ...[
                _buildHeaderSection(isMobile: true),
                const SizedBox(height: 32),
              ],
              
              // Basic Information Section
              _buildSectionHeader("Basic Information"),
              const SizedBox(height: 20),
              
              // Username Field
              _buildTextField(
                context: context,
                label: "Username",
                icon: Icons.person_outline,
                onChanged: (value) => context.read<SignupBloc>().add(SignupUsernameChanged(value)),
                
              ),
              const SizedBox(height: 16),
              
              // Email Field
              _buildTextField(
                context: context,
                label: "Email Address",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => context.read<SignupBloc>().add(SignupEmailChanged(value)),
                
              ),
              const SizedBox(height: 16),
              
              // Password Field
              _buildPasswordField(
                context: context,
                label: "Password",
                onChanged: (value) => context.read<SignupBloc>().add(SignupPasswordChanged(value)),
                
              ),
              const SizedBox(height: 16),
              
              // Confirm Password Field
              _buildPasswordField(
                context: context,
                label: "Confirm Password",
                onChanged: (value) => context.read<SignupBloc>().add(SignupConfirmPasswordChanged(value)),

              ),
              const SizedBox(height: 20),
              
              // Account Type
              _buildSectionHeader("Account Type"),
              const SizedBox(height: 12),
              _buildAccountTypeDropdown(state, context),
              const SizedBox(height: 24),
              
              // Dynamic Fields based on Account Type
              if (state.userType == "doctor" || state.userType == "hospital") 
                _buildProfessionalFields(state, context),
              
              const SizedBox(height: 8),
              
              // Terms and Conditions
              // _buildTermsAgreement(state, context),
              // const SizedBox(height: 24),
              
              // Sign Up Button
              _buildSignupButton(state, context),
              const SizedBox(height: 20),
              
              // Login Redirect
              _buildLoginRedirect(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: "Enter your $label",
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
            prefixIcon: Icon(icon, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            errorText: errorText,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required String label,
    required Function(String) onChanged,
    String? errorText,
  }) {
    bool isPasswordVisible = false;
    
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                hintText: "Enter your $label",
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
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                errorText: errorText,
              ),
              onChanged: onChanged,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccountTypeDropdown(SignupState state, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: state.userType,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
          items: const [
            DropdownMenuItem(
              value: "user",
              child: Row(
                children: [
                  Icon(Icons.person, size: 20, color: Colors.blue),
                  SizedBox(width: 12),
                  Text("User"),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "doctor",
              child: Row(
                children: [
                  Icon(Icons.medical_services, size: 20, color: Colors.green),
                  SizedBox(width: 12),
                  Text("Doctor"),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "hospital",
              child: Row(
                children: [
                  Icon(Icons.local_hospital, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text("Hospital"),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              context.read<SignupBloc>().add(SignupUserTypeChanged(value));
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfessionalFields(SignupState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          state.userType == "doctor" ? "Professional Information" : "Hospital Information"
        ),
        const SizedBox(height: 16),

        if (state.userType == "doctor") ...[
          _buildTextField(
            context: context,
            label: "Full Name",
            icon: Icons.badge_outlined,
            onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("full_name", v)),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            context: context,
            label: "Specialization",
            icon: Icons.work_outline,
            onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("specialization", v)),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            context: context,
            label: "Degrees & Qualifications",
            icon: Icons.school_outlined,
            onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("degrees", v)),
          ),
        ] else if (state.userType == "hospital") ...[
          _buildTextField(
            context: context,
            label: "Hospital Name",
            icon: Icons.business_outlined,
            onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("name", v)),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            context: context,
            label: "Registration Number",
            icon: Icons.numbers_outlined,
            onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("registration_number", v)),
          ),

          const SizedBox(height: 12),
          // Address block
          _buildTextField(
            context: context,
            label: "Address",
            icon: Icons.location_city_outlined,
            onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("address", v)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "City",
                  icon: Icons.location_on_outlined,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("city", v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "State",
                  icon: Icons.map_outlined,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("state", v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Pincode",
                  icon: Icons.pin_drop_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("pincode", v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Contact Number",
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("contact_number", v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Contact / online info
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Hospital Email (optional)",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("email", v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Website (optional)",
                  icon: Icons.link_outlined,
                  keyboardType: TextInputType.url,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("website", v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Established Year",
                  icon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("established_year", v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Hospital Type (e.g., Cardiology)",
                  icon: Icons.medical_services_outlined,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("type", v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Emergency services toggle
          StatefulBuilder(
            builder: (context, setStateSB) {
              bool emergency = false;
              // try to infer initial value from state.profile if available
              try {
                final val = ((state as dynamic).profile ?? {})['emergency_services'];
                if (val is bool) emergency = val;
                if (val is String) emergency = val.toLowerCase() == 'true';
              } catch (_) {}
              return SwitchListTile(
                title: const Text("Emergency Services"),
                value: emergency,
                onChanged: (v) {
                  setStateSB(() {
                    emergency = v;
                  });
                  context.read<SignupBloc>().add(SignupProfileDataChanged("emergency_services", v.toString()));
                },
              );
            },
          ),

          const SizedBox(height: 12),
          // Description / notes
          const Text(
            "Description",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: "Short description about the hospital",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              prefixIcon: const Icon(Icons.description_outlined, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("description", v)),
          ),

          const SizedBox(height: 16),
          _buildSectionHeader("Staff & Capacity"),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Total Staff",
                  icon: Icons.group_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("total_staff", v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Total Doctors",
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("total_doctors", v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Total Nurses",
                  icon: Icons.healing_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("total_nurses", v)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          _buildSectionHeader("Bed & Facility Details"),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Total Beds",
                  icon: Icons.bed_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("total_beds", v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Occupied Beds",
                  icon: Icons.event_seat_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("occupied_beds", v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "ICU Beds",
                  icon: Icons.local_hospital_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("icu_beds", v)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Ventilators",
                  icon: Icons.airline_seat_flat_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("ventilators", v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "General Ward Beds",
                  icon: Icons.bedroom_parent_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("general_ward", v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Emergency Beds",
                  icon: Icons.local_hospital,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("emergency_beds", v)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Cardiology Beds",
                  icon: Icons.favorite_outline,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("cardiology_beds", v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Pediatrics Beds",
                  icon: Icons.child_care_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("pediatrics_beds", v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  label: "Surgery Beds",
                  icon: Icons.local_hospital_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("surgery_beds", v)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          _buildTextField(
            context: context,
            label: "Maternity Beds",
            icon: Icons.pregnant_woman_outlined,
            keyboardType: TextInputType.number,
            onChanged: (v) => context.read<SignupBloc>().add(SignupProfileDataChanged("maternity_beds", v)),
          ),
        ],

        const SizedBox(height: 16),
        _buildLocationSection(state, context),
      ],
    );
  }

  Widget _buildLocationSection(SignupState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Location",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.withOpacity(0.1),
            foregroundColor: Colors.blue,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.blue.withOpacity(0.3)),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            context.read<SignupBloc>().add(FetchLocationRequested());
          },
          icon: const Icon(Icons.location_on_outlined, size: 20),
          label: const Text("Fetch Current Location"),
        ),


        if (state.latitude != null && state.longitude != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Location fetched: ${state.latitude!.toStringAsFixed(4)}, ${state.longitude!.toStringAsFixed(4)}",
                    style: const TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSignupButton(SignupState state, BuildContext context) {
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
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Colors.blue.withOpacity(0.3),
              ),
              onPressed: state.isValid  && !state.isSubmitting
                  ? () {
                      FocusScope.of(context).unfocus();
                      context.read<SignupBloc>().add(SignupSubmitted());
                    }
                  : null,
              child: const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: RichText(
          text: const TextSpan(
            text: "Already have an account? ",
            style: TextStyle(color: Colors.grey),
            children: [
              TextSpan(
                text: "Sign In",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
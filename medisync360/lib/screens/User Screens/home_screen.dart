import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medisync360/Repositiories/profile_repository.dart';
import 'package:medisync360/Repositiories/user_repository.dart';
import 'package:medisync360/screens/Login/login_page.dart';
import 'package:medisync360/screens/User%20Screens/Appointment/my_appointments.dart';
import 'package:medisync360/screens/User%20Screens/Chatbot/chatbot_bloc.dart';
import 'package:medisync360/screens/User%20Screens/Chatbot/chatbot_screen.dart';
import 'package:medisync360/screens/User%20Screens/Profile/profile_bloc.dart';
import 'package:medisync360/screens/User%20Screens/Appointment/appointment.dart';
import 'package:medisync360/screens/User%20Screens/ml_analyzers.dart';
import 'package:medisync360/screens/User%20Screens/my_vault.dart';
import 'package:medisync360/screens/User%20Screens/sos_screen.dart';
import 'package:medisync360/widgets/mapwidget.dart';
import "Profile/profile_page.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLocationPermission();
    });
  }

  Future<void> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enable location services to show your location on the map.'),
        ));
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permission denied. Map will show default location.'),
        ));
      }
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location permission'),
            content: const Text(
                'Location permissions are permanently denied. Please enable them from app settings.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Geolocator.openAppSettings();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MediSync 360',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 2,
        shadowColor: Colors.black26,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Logout Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      _showLogoutDialog();
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 18, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            "Log Out",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Profile Section
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (_) => UserBloc(ProfileRepository as UserRepository),
                          child: const UserProfileScreen(),
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.blue, size: 18),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "username",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),

      // Enhanced Drawer
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.lightBlueAccent],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer Header
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medical_services, size: 70, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'MediSync 360 +',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your Health Companion',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Menu Items
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDrawerItem(
                      icon: Icons.home,
                      title: 'Home',
                      onTap: () => Navigator.pop(context),
                      isSelected: true,
                    ),
                    _buildDrawerItem(
                      icon: Icons.chat,
                      title: 'Chatbot',
                      onTap: () => Navigator.push(context,  MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<ChatbotBloc>(),
                                child: const ChatbotScreen(),
                              ),
                    ),
                      ),
                    ),
                    _buildDrawerItem(
                      icon: Icons.psychology,
                      title: 'ML Analyzers',
                      onTap: () => _navigateTo(context, const MlAnalyzers()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.schedule,
                      title: 'Book Appointment',
                      onTap: () => _navigateTo(context,  BookAppointmentScreen()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.medical_information,
                      title: 'My Appointments',
                      onTap: () => _navigateTo(context, MyAppointmentsScreen()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.security,
                      title: 'My Vault',
                      onTap: () => _navigateTo(context, const MyVault()),
                    ),
                  ],
                ),
              ),
              
              // Footer
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Divider(color: Colors.white30),
                    SizedBox(height: 10),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Main Content
      body: Column(
        children: [
          // Welcome Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.lightBlue.shade50],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'How can we help you today?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          
          // Map Section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: const MapWidget(),
              ),
            ),
          ),
        ],
      ),

      // Enhanced SOS Button
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 4,
          icon: const Icon(Icons.warning, size: 24),
          label: const Text(
            'SOS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SOS_Screen(),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Helper method for drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Colors.white.withOpacity(0.9) : Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.white,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue)
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Navigation helper
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Logout confirmation dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Log Out",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Logged Out Successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                "Log Out",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
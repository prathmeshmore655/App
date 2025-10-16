  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:medisync360/Repositiories/doctor_repository.dart';
  import 'package:medisync360/Repositiories/patient_repositories.dart';
  import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Analytics/analytics.dart';
  import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Analytics/analytics_bloc.dart';
  import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Analytics/analytics_event.dart';
  import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Bed%20Management/bed_management.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Live%20Capacity%20View/live_capacity_view.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Nearby%20Hospitals/nearby_hospitals.dart';
  import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Overview/hospital_overview_page.dart';
  import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients.dart';
  import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_bloc.dart';
  import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Patients/patients_event.dart';
  import 'package:medisync360/screens/Hospital%20Screens/hospital_bloc.dart';
  import 'package:medisync360/screens/Hospital%20Screens/hospital_event.dart';
  import 'package:medisync360/screens/Hospital%20Screens/hospital_state.dart';
  import 'package:medisync360/screens/Login/login_page.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class HospitalDashboardScreen extends StatefulWidget {
    const HospitalDashboardScreen({super.key});

    @override
    State<HospitalDashboardScreen> createState() => _HospitalDashboardScreenState();
  }

  class _HospitalDashboardScreenState extends State<HospitalDashboardScreen> {
    int _selectedIndex = 0;
    final List<String> _sections = ['Overview', 'Bed Management', 'Patients', 'Analytics'];
    String username = '';
    String email = '';

    @override
    void initState() {
      super.initState();
      context.read<HospitalBloc>().add(FetchHospitalEvent());
      _loadUserData();
    }

    Future<void> _loadUserData() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        username = pref.getString('username') ?? '';
        email = pref.getString('email') ?? '';
      });
    }

    void _showNotifications() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 16),
            // Add your notification items here
            _buildNotificationItem('New patient registration', '2 min ago'),
            _buildNotificationItem('Bed availability updated', '10 min ago'),
            _buildNotificationItem('Emergency alert', '1 hour ago'),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String time) {
    return ListTile(
      leading: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(title, style: TextStyle(fontSize: 14)),
      subtitle: Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: Icon(Icons.chevron_right, size: 16),
      contentPadding: EdgeInsets.zero,
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'profile':
        // Navigate to profile
        break;
      case 'settings':
        // Navigate to settings
        break;
      case 'logout':
        _showLogoutDialog();
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout', style: TextStyle(color: Colors.red)),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hospital Dashboard",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.blueGrey[800],
                ),
              ),
              Text(
                "Manage hospital operations",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.blueGrey[400],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.blueAccent.withOpacity(0.1),
          centerTitle: false,
          iconTheme: IconThemeData(
            color: Colors.blueAccent,
            size: 24,
          ),
          actions: [
            // Search Icon
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
                radius: 18,
                child: IconButton(
                  icon: Icon(Icons.search, color: Colors.blueAccent, size: 20),
                  onPressed: () {
                    // Add search functionality
                  },
                ),
              ),
            ),
            
            // Notifications with Badge
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Badge(
                label: Text('3', style: TextStyle(fontSize: 10, color: Colors.white)),
                backgroundColor: Colors.red,
                smallSize: 18,
                child: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  radius: 18,
                  child: IconButton(
                    icon: Icon(Icons.notifications_outlined, color: Colors.blueAccent, size: 20),
                    onPressed: _showNotifications,
                  ),
                ),
              ),
            ),
            
            // User Profile Menu
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 8),
              child: PopupMenuButton<String>(
                icon: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: 18,
                  child: Text(
                    username[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onSelected: (value) => _handleMenuSelection(value),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.blueAccent, size: 20),
                        SizedBox(width: 8),
                        Text('My Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings, color: Colors.blueAccent, size: 20),
                        SizedBox(width: 8),
                        Text('Settings'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Logout', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.blueAccent.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.blueAccent.withOpacity(0.03),
                ],
              ),
            ),
          ),
        ),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        username[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              ListTile(
                leading: Icon(Icons.near_me, color: Colors.blue),
                title: Text("NearBy Hospitals"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HospitalMapPage()));
                  // Handle logout
                },
              ),

              ListTile(
                leading: Icon(Icons.reduce_capacity, color: Colors.blue),
                title: Text("Live Capacity View"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LiveCapacityView()));
                  // Handle logout
                },
              ),

              ListTile(
                leading: Icon(Icons.settings, color: Colors.blueAccent),
                title: Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings page
                },
              ),
            ],
          ),
        ),

        body: BlocBuilder<HospitalBloc, HospitalState>(
          builder: (context, state) {
            if (state is HospitalLoading) {
              return _buildLoadingState();
            } else if (state is HospitalLoaded) {
              final hospital = state.hospital;
              final beds = state.beds;
              Widget content;
              switch (_selectedIndex) {
                case 0:
                  content = HospitalOverviewSection(hospital: hospital, beds: beds);
                  break;
                case 1:
                  content = BedManagementSection(hospital: hospital);
                  break;
                case 2:
                  content = BlocProvider(
                    create: (context) => PatientBloc(PatientRepository(), DoctorRepository())..add(LoadPatients()),
                    child: const PatientListScreen(),
                  );
                  break;
                case 3:
                  content = BlocProvider(
                    create: (context) => AnalyticsBloc()..add(LoadAnalytics()),
                    child: const AnalyticsComponent(),
                  );
                  break;
                default:
                  content = const SizedBox();
              }

              return Column(
                children: [
                  _buildEnhancedTabBar(),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF8F9FF),
                            Color(0xFFF0F4FF),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: content,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is HospitalError) {
              return _buildErrorState(state);
            } else {
              return const SizedBox();
            }
          },
        ),
      );
    }

    Widget _buildEnhancedTabBar() {
      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.blueAccent.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_sections.length, (index) {
            final isSelected = _selectedIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getTabIcon(index),
                        size: 20,
                        color: isSelected ? Colors.white : Colors.blueAccent.withOpacity(0.6),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _sections[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }

    Widget _buildLoadingState() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Loading Hospital Data...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildErrorState(HospitalError state) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Something went wrong",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<HospitalBloc>().add(FetchHospitalEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Try Again",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildAnalyticsPlaceholder() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  size: 60,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Analytics Dashboard",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Comprehensive analytics and insights\ncoming soon",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Get Notified",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    IconData _getTabIcon(int index) {
      switch (index) {
        case 0:
          return Icons.dashboard_outlined;
        case 1:
          return Icons.hotel_outlined;
        case 2:
          return Icons.people_outline;
        case 3:
          return Icons.analytics_outlined;
        default:
          return Icons.circle_outlined;
      }
    }
  }
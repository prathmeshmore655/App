import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:medisync360/screens/Hospital%20Screens/hospital_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/hospital_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/hospital_state.dart';
import 'package:google_fonts/google_fonts.dart';

class HospitalDashboardPage extends StatelessWidget {
  const HospitalDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HospitalDashboardBloc()..add(LoadHospitalData()),
      child: BlocBuilder<HospitalDashboardBloc, HospitalDashboardState>(
        builder: (context, state) {
          final bloc = context.read<HospitalDashboardBloc>();

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: _buildAppBar(state, context),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.isLoading
                  ? _buildLoadingState()
                  : Column(
                      children: [
                        _buildTabBar(context, bloc, state),
                        Expanded(child: _buildTabContent(state, context)),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

AppBar _buildAppBar(HospitalDashboardState state, BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).primaryColor,
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.3),
    foregroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    title: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showHospitalDetails(context, state),
        child: Row(
          children: [
            // Animated Hospital Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.local_hospital_rounded,
                size: 26,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            
            // Hospital Info with Advanced Typography
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hospital Name with Gradient Text
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.8),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      _truncateHospitalName(state.hospitalName),
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Info Chips Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildAnimatedInfoChip(
                        icon: Icons.fingerprint_rounded,
                        text: "Reg: ${state.regId}",
                      ),
                      _buildAnimatedInfoChip(
                        icon: Icons.calendar_month_rounded,
                        text: "Estd: ${state.established}",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      // Notification Button with Advanced Badge
      _buildNotificationButton(),
      
      // Refresh Button with Rotation Animation
      _buildRefreshButton(context),
      
      // Profile/More Options
      _buildProfileMenu(context),
      
      const SizedBox(width: 12),
    ],
  );
}

// Enhanced Notification Button with Ripple Animation
Widget _buildNotificationButton() {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 500),
    curve: Curves.elasticOut,
    builder: (context, value, child) {
      return Transform.scale(
        scale: 0.9 + (value * 0.1),
        child: Stack(
          children: [
            // Ripple Effect Background
            ...List.generate(3, (index) {
              return Positioned.fill(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 1500 + (index * 300)),
                  curve: Curves.easeOut,
                  margin: EdgeInsets.all(8.0 * (1 - value)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3 * (1 - value)),
                      width: 1.5,
                    ),
                  ),
                ),
              );
            }),
            
            // Notification Icon
            IconButton(
              icon: Icon(
                Icons.notifications_active_rounded,
                size: 24,
                color: Colors.white.withOpacity(0.95),
              ),
              onPressed: _showNotifications,
              tooltip: 'Notifications',
              splashColor: Colors.white.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.1),
            ),
            
            // Animated Badge
            Positioned(
              right: 10,
              top: 10,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  '3',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Enhanced Refresh Button with Rotation Animation
Widget _buildRefreshButton(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      bool isRefreshing = false;
      
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: isRefreshing ? 1.0 : 0.0),
        builder: (context, value, child) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isRefreshing 
                  ? LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3 * value),
                        Colors.white.withOpacity(0.1 * value),
                      ],
                    )
                  : null,
            ),
            child: IconButton(
              icon: Transform.rotate(
                angle: value * 2 * 3.14159, // Full rotation
                child: Icon(
                  Icons.refresh_rounded,
                  size: 24,
                  color: Colors.white.withOpacity(0.95 - (value * 0.25)),
                ),
              ),
              onPressed: isRefreshing 
                  ? null 
                  : () {
                      setState(() => isRefreshing = true);
                      context.read<HospitalDashboardBloc>().add(LoadHospitalData());
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() => isRefreshing = false);
                      });
                    },
              tooltip: isRefreshing ? 'Refreshing...' : 'Refresh Data',
            ),
          );
        },
      );
    },
  );
}

// Profile Menu with Hover Effects
Widget _buildProfileMenu(BuildContext context) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.person_rounded,
          size: 22,
          color: Colors.white,
        ),
        onPressed: _showProfileMenu,
        tooltip: 'Profile & Settings',
      ),
    ),
  );
}

// Enhanced Info Chip with Hover Effects
Widget _buildAnimatedInfoChip({required IconData icon, required String text}) {
  return MouseRegion(
    cursor: SystemMouseCursors.basic,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.1,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    ),
  );
}

// Enhanced Hospital Name Truncation with Smart Logic
String _truncateHospitalName(String name) {
  if (name.length > 28) {
    final words = name.split(' ');
    if (words.length > 2) {
      // Keep first two words and add ellipsis
      return '${words.take(2).join(' ')}...';
    } else {
      return '${name.substring(0, 25)}...';
    }
  }
  return name;
}

// Show Hospital Details Bottom Sheet
void _showHospitalDetails(BuildContext context, HospitalDashboardState state) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _buildHospitalDetailsSheet(context, state),
  );
}

Widget _buildHospitalDetailsSheet(BuildContext context, HospitalDashboardState state) {
  return Container(
    margin: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Sheet header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.info_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Hospital Details',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Content would go here...
      ],
    ),
  );
}

void _showNotifications() {
  // Advanced notification handling
}

void _showProfileMenu() {
  // Profile menu handling
}

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading Hospital Data...",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, HospitalDashboardBloc bloc,
      HospitalDashboardState state) {
    final tabs = ["Overview", "Bed Management", "Patients", "Analytics"];
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Expanded(
            child: _buildTabItem(tabs[index], index, state, bloc, context),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index, HospitalDashboardState state,
      HospitalDashboardBloc bloc, BuildContext context) {
    final isSelected = state.selectedTabIndex == index;
    
    return InkWell(
      onTap: () => bloc.add(ChangeDashboardTab(index)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getTabIcon(index),
              color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTabIcon(int index) {
    switch (index) {
      case 0: return Icons.dashboard_outlined;
      case 1: return Icons.bed_outlined;
      case 2: return Icons.people_outline;
      case 3: return Icons.analytics_outlined;
      default: return Icons.dashboard_outlined;
    }
  }

  Widget _buildTabContent(HospitalDashboardState state, BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _getTabWidget(state, context),
    );
  }

  Widget _getTabWidget(HospitalDashboardState state, BuildContext context) {
    switch (state.selectedTabIndex) {
      case 0:
        return _buildOverviewTab(state, context);
      case 1:
        return _buildBedManagementTab(state, context);
      case 2:
        return _buildPatientsTab(state, context);
      case 3:
        return _buildAnalyticsTab(state, context);
      default:
        return const SizedBox();
    }
  }

  Widget _buildOverviewTab(HospitalDashboardState state, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Hospital Location Map
          _buildHospitalMap(context),
          const SizedBox(height: 24),

          // Hospital Info Card
          _buildHospitalInfoCard(state, context),
          const SizedBox(height: 24),

          // Quick Stats Section
          _buildStatsGrid(state, context),
          const SizedBox(height: 24),

          // Emergency Contacts
          _buildEmergencyContacts(context),
        ],
      ),
    );
  }

  Widget _buildHospitalMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: const LatLng(18.5204, 73.8567),
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.medisync360.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: const LatLng(18.5204, 73.8567),
                  width: 60,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalInfoCard(HospitalDashboardState state, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_hospital,
                color: Theme.of(context).primaryColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.hospitalName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on, "Location: ${state.location}"),
                  _buildInfoRow(Icons.fingerprint, "Reg ID: ${state.regId}"),
                  _buildInfoRow(Icons.calendar_today, "Established: ${state.established}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(HospitalDashboardState state, BuildContext context) {
    final stats = [
      _StatItem("Total Beds", state.totalBeds.toString(), Icons.bed, Colors.blue, Colors.blue.shade50),
      _StatItem("Occupied", state.occupiedBeds.toString(), Icons.bedtime, Colors.redAccent, Colors.red.shade50),
      _StatItem("Available", (state.totalBeds - state.occupiedBeds).toString(), Icons.bed_outlined, Colors.green, Colors.green.shade50),
      _StatItem("Patients", state.totalPatients.toString(), Icons.people, Colors.orange, Colors.orange.shade50),
      _StatItem("Doctors", state.doctorsCount.toString(), Icons.medical_services, Colors.purple, Colors.purple.shade50),
      _StatItem("Nurses", "24", Icons.health_and_safety, Colors.teal, Colors.teal.shade50),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildStatCard(stats[index], context),
    );
  }

  Widget _buildStatCard(_StatItem stat, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: stat.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(stat.icon, color: stat.color, size: 20),
                ),
                Text(
                  stat.value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              stat.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContacts(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emergency, color: Colors.red.shade600),
                const SizedBox(width: 8),
                Text(
                  "Emergency Contacts",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildContactItem("Emergency Ward", "+91-XXXX-XXXX"),
            _buildContactItem("Ambulance", "+91-XXXX-XXXX"),
            _buildContactItem("ICU", "+91-XXXX-XXXX"),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(String title, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            number,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder tabs with enhanced UI
  Widget _buildBedManagementTab(HospitalDashboardState state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bed_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "Bed Management",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Advanced bed allocation and management",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsTab(HospitalDashboardState state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "Patient Management",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Comprehensive patient care system",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab(HospitalDashboardState state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "Hospital Analytics",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Data-driven insights and reports",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  _StatItem(this.title, this.value, this.icon, this.color, this.backgroundColor);
}
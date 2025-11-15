import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:medisync360/Domain/Entities/Hospital/hospital_beds_entities.dart';
import 'package:medisync360/Domain/Entities/Hospital/hospital_entities.dart';

class HospitalOverviewSection extends StatefulWidget {
  final HospitalEntities hospital;
  final HospitalBedsEntities beds;

  const HospitalOverviewSection({
    Key? key,
    required this.hospital,
    required this.beds,
  }) : super(key: key);

  @override
  State<HospitalOverviewSection> createState() => _HospitalOverviewSectionState();
}

class _HospitalOverviewSectionState extends State<HospitalOverviewSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final isLargeScreen = screenWidth > 1200;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Card
          _buildHospitalHeader(isSmallScreen, isLargeScreen),
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          
          // Tab-like Navigation
          _buildSectionNavigation(isSmallScreen),
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          
          // Content Area
          SizedBox(
            height: screenHeight * 0.6, // Fixed height for PageView
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildOverviewTab(isSmallScreen, isLargeScreen),
                _buildBedAvailabilityTab(isSmallScreen, isLargeScreen),
                _buildLocationTab(isSmallScreen, isLargeScreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalHeader(bool isSmallScreen, bool isLargeScreen) {
    return Card(
      margin: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isSmallScreen 
                ? _buildSmallHeaderLayout()
                : _buildLargeHeaderLayout(isLargeScreen),
            
            SizedBox(height: isSmallScreen ? 12.0 : 16.0),
            const Divider(),
            SizedBox(height: isSmallScreen ? 8.0 : 12.0),
            
            // Quick Stats
            _buildQuickStats(isSmallScreen, isLargeScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallHeaderLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Hospital Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.local_hospital,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hospital.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.hospital.type.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Est. ${widget.hospital.establishedYear}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildLargeHeaderLayout(bool isLargeScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hospital Icon
        Container(
          width: isLargeScreen ? 80 : 60,
          height: isLargeScreen ? 80 : 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(isLargeScreen ? 16 : 12),
          ),
          child: Icon(
            Icons.local_hospital,
            color: Colors.white,
            size: isLargeScreen ? 40 : 32,
          ),
        ),
        SizedBox(width: isLargeScreen ? 20 : 16),
        
        // Hospital Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.hospital.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: isLargeScreen ? 28 : 24,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.hospital.type.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: isLargeScreen ? 18 : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Est. ${widget.hospital.establishedYear}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: isLargeScreen ? 16 : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(bool isSmallScreen, bool isLargeScreen) {
    final totalBeds = _calculateTotalBeds();
    final availableBeds = _calculateAvailableBeds();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(Icons.bed, 'Total Beds', totalBeds.toString(), isSmallScreen, isLargeScreen),
        _buildStatItem(Icons.bedroom_child, 'Available', availableBeds.toString(), isSmallScreen, isLargeScreen),
        _buildStatItem(Icons.emergency, 'ICU', widget.beds.icuBeds.toString(), isSmallScreen, isLargeScreen),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, bool isSmallScreen, bool isLargeScreen) {
    final iconSize = isSmallScreen ? 20.0 : (isLargeScreen ? 28.0 : 24.0);
    final containerSize = isSmallScreen ? 40.0 : (isLargeScreen ? 60.0 : 50.0);
    final valueFontSize = isSmallScreen ? 14.0 : (isLargeScreen ? 20.0 : 16.0);
    final labelFontSize = isSmallScreen ? 10.0 : (isLargeScreen ? 14.0 : 12.0);

    return Column(
      children: [
        Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(containerSize / 2),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: iconSize,
          ),
        ),
        SizedBox(height: isSmallScreen ? 2.0 : 4.0),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: valueFontSize,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: labelFontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSectionNavigation(bool isSmallScreen) {
    final tabs = ['Overview', 'Beds', 'Location'];
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12.0 : 16.0),
      padding: EdgeInsets.all(isSmallScreen ? 3.0 : 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(isSmallScreen ? 10.0 : 12.0),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _currentPage == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 10.0 : 12.0,
                  horizontal: isSmallScreen ? 4.0 : 8.0,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 6.0 : 8.0),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: isSmallScreen ? 12.0 : null,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOverviewTab(bool isSmallScreen, bool isLargeScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(
            'Contact Information',
            Icons.contact_phone,
            [
              _buildContactItem(Icons.location_on, 'Address', widget.hospital.address, isSmallScreen),
              _buildContactItem(Icons.phone, 'Phone', widget.hospital.contactNumber, isSmallScreen),
              _buildContactItem(Icons.email, 'Email', widget.hospital.email.toString(), isSmallScreen),
              _buildContactItem(Icons.badge, 'Registration', widget.hospital.registrationNumber, isSmallScreen),
            ],
            isSmallScreen,
            isLargeScreen,
          ),
          
          SizedBox(height: isSmallScreen ? 16.0 : 24.0),
          
          _buildInfoSection(
            'Hospital Details',
            Icons.info,
            [
              _buildDetailItem('Hospital Type', widget.hospital.type.toString(), isSmallScreen),
              _buildDetailItem('Established', widget.hospital.establishedYear.toString(), isSmallScreen),
              _buildDetailItem('Registration', widget.hospital.registrationNumber, isSmallScreen),
            ],
            isSmallScreen,
            isLargeScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildBedAvailabilityTab(bool isSmallScreen, bool isLargeScreen) {
    final bedCategories = [
      {'label': 'General Ward', 'count': widget.beds.generalWard, 'icon': Icons.king_bed},
      {'label': 'ICU Beds', 'count': widget.beds.icuBeds, 'icon': Icons.local_hospital},
      {'label': 'Emergency', 'count': widget.beds.emergencyBeds, 'icon': Icons.emergency},
      {'label': 'Cardiology', 'count': widget.beds.cardiologyBeds, 'icon': Icons.heart_broken},
      {'label': 'Pediatrics', 'count': widget.beds.pediatricsBeds, 'icon': Icons.child_friendly},
      {'label': 'Surgery', 'count': widget.beds.surgeryBeds, 'icon': Icons.medical_services},
      {'label': 'Maternity', 'count': widget.beds.maternityBeds, 'icon': Icons.family_restroom},
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      child: Column(
        children: [
          // Summary Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
              child: isSmallScreen 
                  ? _buildSmallBedSummary()
                  : _buildLargeBedSummary(isLargeScreen),
            ),
          ),
          
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          
          // Bed List
          ...bedCategories.map((category) => 
            _buildBedCategoryCard(
              category['label'] as String,
              category['count'] as int,
              category['icon'] as IconData,
              isSmallScreen,
              isLargeScreen,
            )
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildSmallBedSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBedSummary('Total', _calculateTotalBeds().toString(), Icons.inventory, true, false),
            _buildBedSummary('Available', _calculateAvailableBeds().toString(), Icons.event_available, true, false),
          ],
        ),
        SizedBox(height: 12),
        _buildBedSummary('Occupancy', '${_calculateOccupancyRate()}%', Icons.pie_chart, true, false),
      ],
    );
  }

  Widget _buildLargeBedSummary(bool isLargeScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildBedSummary('Total Capacity', _calculateTotalBeds().toString(), Icons.inventory, false, isLargeScreen),
        _buildBedSummary('Available Now', _calculateAvailableBeds().toString(), Icons.event_available, false, isLargeScreen),
        _buildBedSummary('Occupancy Rate', '${_calculateOccupancyRate()}%', Icons.pie_chart, false, isLargeScreen),
      ],
    );
  }

  Widget _buildLocationTab(bool isSmallScreen, bool isLargeScreen) {
    final mapHeight = isSmallScreen ? 200.0 : (isLargeScreen ? 350.0 : 300.0);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Map
          Container(
            height: mapHeight,
            margin: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSmallScreen ? 8.0 : 12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isSmallScreen ? 8.0 : 12.0),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                    (widget.hospital.latitude ?? 0.0).toDouble(),
                    (widget.hospital.longitude ?? 0.0).toDouble(),
                  ),
                  initialZoom: isSmallScreen ? 14 : 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          (widget.hospital.latitude ?? 0.0).toDouble(),
                          (widget.hospital.longitude ?? 0.0).toDouble(),
                        ),
                        width: isSmallScreen ? 40 : 60,
                        height: isSmallScreen ? 40 : 60,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: isSmallScreen ? 30 : 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        
          // Address Card
          Card(
            margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8.0 : 16.0),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).colorScheme.primary,
                    size: isSmallScreen ? 18 : 24,
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        'Hospital Location',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: isSmallScreen ? 14 : null,
                        ),
                      ),
                      Text(
                        widget.hospital.address,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: isSmallScreen ? 12 : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    );
  }

  // Helper Methods
  Widget _buildInfoSection(String title, IconData icon, List<Widget> children, bool isSmallScreen, bool isLargeScreen) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon, 
                  color: Theme.of(context).colorScheme.primary,
                  size: isSmallScreen ? 18 : 24,
                ),
                SizedBox(width: isSmallScreen ? 6 : 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 16 : (isLargeScreen ? 20 : null),
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon, 
            size: isSmallScreen ? 16 : 20, 
            color: Theme.of(context).colorScheme.primary
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: isSmallScreen ? 12 : null,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isSmallScreen ? 14 : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: isSmallScreen ? 14 : null,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: isSmallScreen ? 14 : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBedSummary(String label, String value, IconData icon, bool isSmallScreen, bool isLargeScreen) {
    final iconSize = isSmallScreen ? 18.0 : (isLargeScreen ? 28.0 : 24.0);
    final valueFontSize = isSmallScreen ? 14.0 : (isLargeScreen ? 20.0 : 16.0);
    final labelFontSize = isSmallScreen ? 10.0 : (isLargeScreen ? 14.0 : 12.0);

    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: iconSize),
        SizedBox(height: isSmallScreen ? 2 : 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: valueFontSize,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: labelFontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBedCategoryCard(String label, int count, IconData icon, bool isSmallScreen, bool isLargeScreen) {
    final isAvailable = count > 0;
    final iconSize = isSmallScreen ? 16 : (isLargeScreen ? 24 : 20);
    final containerSize = isSmallScreen ? 32 : (isLargeScreen ? 48 : 40);
    final fontSize = isSmallScreen ? 12 : (isLargeScreen ? 16 : 14);
    
    return Card(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 6 : 8),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
        child: Row(
          children: [
            Container(
              width: containerSize.toDouble(),
              height: containerSize.toDouble(),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
              ),
              child: Icon(
                icon, 
                color: Theme.of(context).colorScheme.primary,
                size: iconSize.toDouble(),
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: fontSize.toDouble(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 8 : 12,
                vertical: isSmallScreen ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: isAvailable ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                border: Border.all(
                  color: isAvailable ? Colors.green : Colors.red,
                ),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isAvailable ? Colors.green : Colors.red,
                  fontSize: fontSize.toDouble(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Calculation Methods
  int _calculateTotalBeds() {
    return widget.beds.generalWard +
        widget.beds.icuBeds +
        widget.beds.emergencyBeds +
        widget.beds.cardiologyBeds +
        widget.beds.pediatricsBeds +
        widget.beds.surgeryBeds +
        widget.beds.maternityBeds;
  }

  int _calculateAvailableBeds() {
    return _calculateTotalBeds();
  }

  int _calculateOccupancyRate() {
    final total = _calculateTotalBeds();
    final available = _calculateAvailableBeds();
    return total > 0 ? ((total - available) * 100 ~/ total) : 0;
  }
}
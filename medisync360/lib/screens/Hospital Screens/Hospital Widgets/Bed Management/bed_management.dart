import 'package:flutter/material.dart';
import 'package:medisync360/models/hospital_model.dart';

class BedManagementSection extends StatelessWidget {
  final HospitalModel hospital;

  const BedManagementSection({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    final availableBeds = hospital.totalBeds - hospital.occupiedBeds;
    final occupancyRate = hospital.totalBeds > 0 
        ? (hospital.occupiedBeds / hospital.totalBeds) * 100 
        : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title and Status
          _buildHeaderSection(occupancyRate.toDouble()),
          const SizedBox(height: 20),
          
          // Bed Capacity Overview
          _buildCapacityOverview(availableBeds, occupancyRate.toDouble()),
          const SizedBox(height: 24),
          
          // Bed Type Breakdown
          _buildBedTypeBreakdown(),
          const SizedBox(height: 20),
          
          // Quick Actions
          // _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(double occupancyRate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bed Management",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Real-time bed availability status",
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey[500],
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(occupancyRate).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getStatusColor(occupancyRate).withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getStatusColor(occupancyRate),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _getStatusText(occupancyRate),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(occupancyRate),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCapacityOverview(int availableBeds, double occupancyRate) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Occupancy Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bed Occupancy",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                    Text(
                      "${occupancyRate.toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _getOccupancyColor(occupancyRate),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: occupancyRate / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getOccupancyColor(occupancyRate),
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Available",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Occupied",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            
            // Bed Statistics Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  "Total Beds",
                  hospital.totalBeds.toString(),
                  Icons.king_bed,
                  Colors.blueAccent,
                ),
                _buildStatCard(
                  "Available",
                  availableBeds.toString(),
                  Icons.event_available,
                  Colors.green,
                ),
                _buildStatCard(
                  "Occupied",
                  hospital.occupiedBeds.toString(),
                  Icons.person,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBedTypeBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bed Type Breakdown",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey[800],
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3.5,
          children: [
            _buildBedTypeItem(
              "ICU Beds",
              hospital.icuBeds.toString(),
              Icons.local_hospital,
              Colors.red,
            ),
            _buildBedTypeItem(
              "Ventilators",
              hospital.ventilators.toString(),
              Icons.air,
              Colors.purple,
            ),
            _buildBedTypeItem(
              "General Ward",
              (hospital.totalBeds - hospital.icuBeds).toString(),
              Icons.king_bed,
              Colors.blue,
            ),
            _buildBedTypeItem(
              "Emergency",
              "0", // You can add this field to your model
              Icons.emergency,
              Colors.orange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey[800],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                "Update Beds",
                Icons.edit,
                Colors.blueAccent,
                () {
                  // Handle update beds action
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                "Add Emergency",
                Icons.add_alert,
                Colors.red,
                () {
                  // Handle emergency action
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.blueGrey[800],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blueGrey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildBedTypeItem(String type, String count, IconData icon, Color color) {
    return SingleChildScrollView(
      child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
  );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(text, style: const TextStyle(fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
      ),
    );
  }

  Color _getStatusColor(double occupancyRate) {
    if (occupancyRate < 60) return Colors.green;
    if (occupancyRate < 85) return Colors.orange;
    return Colors.red;
  }

  Color _getOccupancyColor(double occupancyRate) {
    if (occupancyRate < 60) return Colors.green;
    if (occupancyRate < 85) return Colors.orange;
    return Colors.red;
  }

  String _getStatusText(double occupancyRate) {
    if (occupancyRate < 60) return "Good";
    if (occupancyRate < 85) return "Busy";
    return "Critical";
  }
}
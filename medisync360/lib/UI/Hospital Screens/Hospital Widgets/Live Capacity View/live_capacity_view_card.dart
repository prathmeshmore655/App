import 'package:flutter/material.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Live%20Capacity%20View/live_capacity_view_model.dart';

class LiveCapacityViewScreen extends StatelessWidget {
  final List<HospitalLiveCapacity> hospitals;

  const LiveCapacityViewScreen({super.key, required this.hospitals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Capacity View"),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: ListView.builder(
        itemCount: hospitals.length,
        itemBuilder: (context, index) {
          return HospitalCard(hospital: hospitals[index]);
        },
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  final HospitalLiveCapacity hospital;
  const HospitalCard({super.key, required this.hospital});

  double _calculateCapacity(int occupied, int total) {
    if (total == 0) return 0;
    return (occupied / total) * 100;
  }

  Widget _buildCapacityBar(String label, int occupied, int total) {
    double percentage = _calculateCapacity(occupied, total);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: $occupied / $total (${percentage.toStringAsFixed(1)}%)",
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 3),
          LinearProgressIndicator(
            value: total == 0 ? 0 : occupied / total,
            color: percentage > 80 ? Colors.red : Colors.green,
            backgroundColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double overallCapacity =
        _calculateCapacity(hospital.occupiedBeds, hospital.totalBeds);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hospital Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    hospital.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(
                  hospital.emergencyServices
                      ? Icons.emergency
                      : Icons.local_hospital,
                  color:
                      hospital.emergencyServices ? Colors.red : Colors.blueAccent,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "${hospital.city}, ${hospital.state}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // Overall Capacity
            Text(
              "Overall Capacity: ${hospital.occupiedBeds}/${hospital.totalBeds} (${overallCapacity.toStringAsFixed(1)}%)",
              style: TextStyle(
                  color: overallCapacity > 80 ? Colors.red : Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: hospital.totalBeds == 0
                  ? 0
                  : hospital.occupiedBeds / hospital.totalBeds,
              color: overallCapacity > 80 ? Colors.red : Colors.green,
              backgroundColor: Colors.grey[300],
            ),

            const Divider(height: 16, thickness: 1),

            // Detailed Ward Capacities
            _buildCapacityBar("ICU Beds", hospital.icuBedsOccupied,
                hospital.icuBedsTotal),
            _buildCapacityBar("Emergency Beds", hospital.emergencyBedsOccupied,
                hospital.emergencyBedsTotal),
            _buildCapacityBar("General Ward", hospital.generalWardOccupied,
                hospital.generalWardTotal),
            _buildCapacityBar("Cardiology", hospital.cardiologyBedsOccupied,
                hospital.cardiologyBedsTotal),
            _buildCapacityBar("Pediatrics", hospital.pediatricsBedsOccupied,
                hospital.pediatricsBedsTotal),
            _buildCapacityBar("Surgery", hospital.surgeryBedsOccupied,
                hospital.surgeryBedsTotal),
            _buildCapacityBar("Maternity", hospital.maternityBedsOccupied,
                hospital.maternityBedsTotal),

            const SizedBox(height: 8),

            // Footer Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Established: ${hospital.establishedYear}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text("Rating: ${hospital.rating.toStringAsFixed(1)} ⭐",
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

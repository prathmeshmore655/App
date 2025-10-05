import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Bed%20Management/bed_management_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Bed%20Management/bed_management_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Bed%20Management/bed_management_state.dart';


class BedComponent extends StatelessWidget {
  const BedComponent({super.key});

  Color _getStatusColor(String status) {
    switch (status) {
      case "Available":
        return Colors.green;
      case "Occupied":
        return Colors.red;
      case "Cleaning":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Available":
        return Icons.check_circle;
      case "Occupied":
        return Icons.person;
      case "Cleaning":
        return Icons.cleaning_services;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BedManagementBloc()..add(LoadBeds()),
      child: BlocBuilder<BedManagementBloc, BedManagementState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final beds = state.beds;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: beds.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // adjust for screen size
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final bed = beds[index];
                return GestureDetector(
                  onTap: () {
                    if (bed.status == "Available") {
                      context
                          .read<BedManagementBloc>()
                          .add(UpdateBedStatus(bed.id, "Occupied"));
                    } else if (bed.status == "Occupied") {
                      context
                          .read<BedManagementBloc>()
                          .add(UpdateBedStatus(bed.id, "Cleaning"));
                    } else {
                      context
                          .read<BedManagementBloc>()
                          .add(UpdateBedStatus(bed.id, "Available"));
                    }
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: _getStatusColor(bed.status).withOpacity(0.15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getStatusIcon(bed.status),
                          color: _getStatusColor(bed.status),
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Bed ${bed.id}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(bed.ward,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(
                          bed.status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(bed.status),
                          ),
                        ),
                        if (bed.patientName != null)
                          Text(
                            bed.patientName!,
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

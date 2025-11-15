// screens/my_appointments_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Data/Repositories/appointment_repository.dart';
import 'package:medisync360/UI/User%20Screens/Appointment/my_appointments_bloc.dart';
import 'package:medisync360/UI/User%20Screens/Appointment/my_appointments_event.dart';
import 'package:medisync360/UI/User%20Screens/Appointment/my_appointments_state.dart';

class MyAppointmentsScreen extends StatelessWidget {
  final MyAppointmentRepository repository = MyAppointmentRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyAppointmentsBloc(repository: repository)..add(LoadAppointments()),
      child: Scaffold(
        appBar: AppBar(title: Text("My Appointments")),
        body: BlocBuilder<MyAppointmentsBloc, MyAppointmentsState>(
          builder: (context, state) {
            if (state is MyAppointmentsLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is MyAppointmentsLoaded) {
              if (state.appointments.isEmpty) {
                return Center(child: Text("No appointments found"));
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: state.appointments.length,
                itemBuilder: (context, index) {
                  final appointment = state.appointments[index];
                  Color statusColor;

                  switch (appointment.status.toLowerCase()) {
                    case "upcoming":
                      statusColor = Colors.blue;
                      break;
                    case "completed":
                      statusColor = Colors.green;
                      break;
                    case "cancelled":
                      statusColor = Colors.red;
                      break;
                    default:
                      statusColor = Colors.grey;
                  }

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text("${appointment.doctorName} - ${appointment.hospitalName}"),
                      subtitle: Text("Time: ${appointment.time}"),
                      trailing: Text(
                        appointment.status.toUpperCase(),
                        style: TextStyle(
                            color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              );
            }

            if (state is MyAppointmentsError) {
              return Center(child: Text(state.message));
            }

            return Container();
          },
        ),
      ),
    );
  }
}

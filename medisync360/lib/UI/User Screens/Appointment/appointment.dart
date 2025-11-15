import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Data/Repositories/appointment_repository.dart';
import 'package:medisync360/Data/Models/appointment_model.dart';
import 'package:medisync360/UI/User%20Screens/Appointment/appointment_bloc.dart';
import 'package:medisync360/UI/User%20Screens/Appointment/appointment_event.dart';
import 'package:medisync360/UI/User%20Screens/Appointment/appointment_popup.dart';
import 'package:medisync360/UI/User%20Screens/Appointment/appointment_state.dart';

class BookAppointmentScreen extends StatefulWidget {
  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final AppointmentRepository repository = AppointmentRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AppointmentBloc(repository: repository)..add(LoadDoctors())..add(LoadHospitals()),
      child: Scaffold(
        appBar: AppBar(title: Text("Book Appointment")),
        body: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            List<Doctor> doctors = [];
            List<Hospital> hospitals = [];

            if (state is DoctorsLoaded) doctors = state.doctors;
            if (state is HospitalsLoaded) hospitals = state.hospitals;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Book by Doctor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          final doc = doctors[index];
                          return GestureDetector(
                            onTap: () {
                              _showAppointmentPopup(context, isDoctor: true, doctor: doc);
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: EdgeInsets.only(right: 12),
                              child: Container(
                                width: 150,
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(doc.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 8),
                                    Text(doc.specialization),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 24),
                    Text("Book by Hospital", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hospitals.length,
                        itemBuilder: (context, index) {
                          final hosp = hospitals[index];
                          return GestureDetector(
                            onTap: () {
                              _showAppointmentPopup(context, isDoctor: false, hospital: hosp);
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: EdgeInsets.only(right: 12),
                              child: Container(
                                width: 150,
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(hosp.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 8),
                                    Text(hosp.location),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAppointmentPopup(BuildContext context,
      {bool isDoctor = true, Doctor? doctor, Hospital? hospital}) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
      value: AppointmentBloc(repository: repository), // provide the same bloc to popup
      child: AppointmentPopup(
        isDoctor: isDoctor,
        doctor: doctor,
        hospital: hospital,
      ),
    ),
    );
  }
}

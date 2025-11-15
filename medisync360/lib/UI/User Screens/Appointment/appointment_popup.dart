import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Data/Models/appointment_model.dart';
import 'package:medisync360/UI/User%20Screens/Appointment/appointment_bloc.dart';
import 'package:medisync360/UI/User%20Screens/Appointment/appointment_event.dart';
import 'package:medisync360/UI/User%20Screens/Appointment/appointment_state.dart';

class AppointmentPopup extends StatefulWidget {
  final bool isDoctor;
  final Doctor? doctor;
  final Hospital? hospital;

  const AppointmentPopup({Key? key, this.isDoctor = true, this.doctor, this.hospital})
      : super(key: key);

  @override
  State<AppointmentPopup> createState() => _AppointmentPopupState();
}

class _AppointmentPopupState extends State<AppointmentPopup> {
  AppointmentSlot? selectedSlot;

  @override
  void initState() {
    super.initState();
    // Load slots when popup opens
    final bloc = context.read<AppointmentBloc>();
    if (widget.isDoctor && widget.doctor != null) {
      bloc.add(LoadSlots(doctorId: widget.doctor!.id, hospitalId: "1")); // default hospital
    } else if (!widget.isDoctor && widget.hospital != null) {
      bloc.add(LoadSlots(doctorId: "1", hospitalId: widget.hospital!.id)); // default doctor
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Select Slot", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<AppointmentBloc, AppointmentState>(
                builder: (context, state) {
                  List<AppointmentSlot> slots = [];
                  if (state is SlotsLoaded) slots = state.slots;

                  if (slots.isEmpty) return Center(child: Text("No slots available"));

                  return ListView.builder(
                    itemCount: slots.length,
                    itemBuilder: (_, index) {
                      final slot = slots[index];
                      return ListTile(
                        title: Text(slot.time),
                        trailing: slot.isAvailable ? null : Icon(Icons.block, color: Colors.red),
                        selected: selectedSlot == slot,
                        onTap: slot.isAvailable
                            ? () {
                                setState(() {
                                  selectedSlot = slot;
                                });
                              }
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: selectedSlot != null
                  ? () {
                      final bloc = context.read<AppointmentBloc>();
                      bloc.add(BookAppointmentEvent(
                        doctorId: widget.doctor?.id ?? "1",
                        hospitalId: widget.hospital?.id ?? "1",
                        slotId: selectedSlot!.id,
                      ));
                      Navigator.pop(context);
                    }
                  : null,
              child: Text("Confirm Appointment"),
            )
          ],
        ),
      ),
    );
  }
}

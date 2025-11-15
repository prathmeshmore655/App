import 'package:flutter_bloc/flutter_bloc.dart';
import 'bed_management_event.dart';
import 'bed_management_state.dart';

class BedManagementBloc
    extends Bloc<BedManagementEvent, BedManagementState> {
  BedManagementBloc() : super(const BedManagementState()) {
    on<LoadBeds>(_onLoadBeds);
    on<UpdateBedStatus>(_onUpdateBedStatus);
  }

  Future<void> _onLoadBeds(
      LoadBeds event, Emitter<BedManagementState> emit) async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 1)); // simulate API

    final sampleBeds = List.generate(12, (i) {
      if (i < 5) {
        return Bed(id: i + 1, ward: "General", status: "Available");
      } else if (i < 9) {
        return Bed(
          id: i + 1,
          ward: "ICU",
          status: "Occupied",
          patientName: "Patient ${i - 4}",
        );
      } else {
        return Bed(id: i + 1, ward: "Emergency", status: "Cleaning");
      }
    });

    emit(state.copyWith(isLoading: false, beds: sampleBeds));
  }

  void _onUpdateBedStatus(
      UpdateBedStatus event, Emitter<BedManagementState> emit) {
    final updatedBeds = state.beds.map((bed) {
      if (bed.id == event.bedId) {
        return bed.copyWith(status: event.newStatus);
      }
      return bed;
    }).toList();

    emit(state.copyWith(beds: updatedBeds));
  }
}

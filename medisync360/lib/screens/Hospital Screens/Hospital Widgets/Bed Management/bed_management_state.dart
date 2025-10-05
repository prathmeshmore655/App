import 'package:equatable/equatable.dart';

class Bed {
  final int id;
  final String ward;
  final String status; // Available, Occupied, Cleaning
  final String? patientName;

  const Bed({
    required this.id,
    required this.ward,
    required this.status,
    this.patientName,
  });

  Bed copyWith({String? status, String? patientName}) {
    return Bed(
      id: id,
      ward: ward,
      status: status ?? this.status,
      patientName: patientName ?? this.patientName,
    );
  }
}

class BedManagementState extends Equatable {
  final bool isLoading;
  final List<Bed> beds;

  const BedManagementState({this.isLoading = true, this.beds = const []});

  BedManagementState copyWith({bool? isLoading, List<Bed>? beds}) {
    return BedManagementState(
      isLoading: isLoading ?? this.isLoading,
      beds: beds ?? this.beds,
    );
  }

  @override
  List<Object> get props => [isLoading, beds];
}

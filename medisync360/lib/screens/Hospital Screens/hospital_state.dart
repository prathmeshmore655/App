import 'package:equatable/equatable.dart';

class HospitalDashboardState extends Equatable {
  final bool isLoading;
  final String hospitalName;
  final String regId;
  final String established;
  final String location;
  final int totalBeds;
  final int occupiedBeds;
  final int totalPatients;
  final int doctorsCount;
  final int selectedTabIndex;

  const HospitalDashboardState({
    this.isLoading = true,
    this.hospitalName = '',
    this.regId = '',
    this.established = '',
    this.location = '',
    this.totalBeds = 0,
    this.occupiedBeds = 0,
    this.totalPatients = 0,
    this.doctorsCount = 0,
    this.selectedTabIndex = 0,
  });

  HospitalDashboardState copyWith({
    bool? isLoading,
    String? hospitalName,
    String? regId,
    String? established,
    String? location,
    int? totalBeds,
    int? occupiedBeds,
    int? totalPatients,
    int? doctorsCount,
    int? selectedTabIndex,
  }) {
    return HospitalDashboardState(
      isLoading: isLoading ?? this.isLoading,
      hospitalName: hospitalName ?? this.hospitalName,
      regId: regId ?? this.regId,
      established: established ?? this.established,
      location: location ?? this.location,
      totalBeds: totalBeds ?? this.totalBeds,
      occupiedBeds: occupiedBeds ?? this.occupiedBeds,
      totalPatients: totalPatients ?? this.totalPatients,
      doctorsCount: doctorsCount ?? this.doctorsCount,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object> get props => [
        isLoading,
        hospitalName,
        regId,
        established,
        location,
        totalBeds,
        occupiedBeds,
        totalPatients,
        doctorsCount,
        selectedTabIndex,
      ];
}

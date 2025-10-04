import 'package:equatable/equatable.dart';

abstract class HospitalDashboardEvent extends Equatable {
  const HospitalDashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadHospitalData extends HospitalDashboardEvent {}

class ChangeDashboardTab extends HospitalDashboardEvent {
  final int tabIndex;

  const ChangeDashboardTab(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

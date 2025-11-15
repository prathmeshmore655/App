import 'package:equatable/equatable.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Live%20Capacity%20View/live_capacity_view_model.dart';

abstract class HospitalCapacityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HospitalInitial extends HospitalCapacityState {}

class HospitalLoading extends HospitalCapacityState {}

class HospitalLoaded extends HospitalCapacityState {
  final List<HospitalLiveCapacity> hospitals;
  HospitalLoaded(this.hospitals);

  @override
  List<Object?> get props => [hospitals];
}

class HospitalError extends HospitalCapacityState {
  final String message;
  HospitalError(this.message);

  @override
  List<Object?> get props => [message];
}

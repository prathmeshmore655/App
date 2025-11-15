import 'package:equatable/equatable.dart';
import 'package:medisync360/Domain/Entities/Hospital/live_caapcity_view_entities.dart';

abstract class HospitalCapacityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HospitalInitial extends HospitalCapacityState {}

class HospitalLoading extends HospitalCapacityState {}

class HospitalLoaded extends HospitalCapacityState {
  final List<LiveCaapcityViewEntities> hospitals;
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

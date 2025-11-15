import 'package:equatable/equatable.dart';

abstract class BedManagementEvent extends Equatable {
  const BedManagementEvent();

  @override
  List<Object> get props => [];
}

class LoadBeds extends BedManagementEvent {}

class UpdateBedStatus extends BedManagementEvent {
  final int bedId;
  final String newStatus;

  const UpdateBedStatus(this.bedId, this.newStatus);

  @override
  List<Object> get props => [bedId, newStatus];
}

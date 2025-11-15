import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAnalytics extends AnalyticsEvent {}

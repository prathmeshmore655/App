import 'package:equatable/equatable.dart';

class AnalyticsState extends Equatable {
  final bool isLoading;
  final double bedOccupancy;
  final List<int> monthlyAdmissions;
  final List<int> monthlyDischarges;
  final Map<String, int> departmentDistribution;

  const AnalyticsState({
    this.isLoading = false,
    this.bedOccupancy = 0,
    this.monthlyAdmissions = const [],
    this.monthlyDischarges = const [],
    this.departmentDistribution = const {},
  });

  AnalyticsState copyWith({
    bool? isLoading,
    double? bedOccupancy,
    List<int>? monthlyAdmissions,
    List<int>? monthlyDischarges,
    Map<String, int>? departmentDistribution,
  }) {
    return AnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      bedOccupancy: bedOccupancy ?? this.bedOccupancy,
      monthlyAdmissions: monthlyAdmissions ?? this.monthlyAdmissions,
      monthlyDischarges: monthlyDischarges ?? this.monthlyDischarges,
      departmentDistribution:
          departmentDistribution ?? this.departmentDistribution,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        bedOccupancy,
        monthlyAdmissions,
        monthlyDischarges,
        departmentDistribution
      ];
}

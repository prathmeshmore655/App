import 'package:equatable/equatable.dart';

class AnalyticsState extends Equatable {
  final bool isLoading;
  final double bedOccupancy; // %
  final List<int> monthlyAdmissions; // 12 months
  final List<int> monthlyDischarges; // 12 months
  final Map<String, int> departmentDistribution; // ward -> count

  const AnalyticsState({
    this.isLoading = true,
    this.bedOccupancy = 0.0,
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
  List<Object?> get props =>
      [isLoading, bedOccupancy, monthlyAdmissions, monthlyDischarges, departmentDistribution];
}

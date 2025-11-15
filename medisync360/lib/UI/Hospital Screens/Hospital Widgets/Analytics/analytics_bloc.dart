import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/utils/Services/api_service.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc() : super(const AnalyticsState()) {
    on<LoadAnalytics>(_onLoadAnalytics);
  }

  Future<void> _onLoadAnalytics(
      LoadAnalytics event, Emitter<AnalyticsState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await ApiService.request(
        '/auth/department-analytics/hospital/',
        method: 'GET',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Parse department-wise patient distribution
        final departmentDistribution = {
          for (var d in data) d['name']: d['patients'] as int
        };

        // Calculate bed occupancy (average of all departments)
        double totalOccupancy = 0;
        for (var d in data) {
          totalOccupancy += (d['occupancy'] as num).toDouble();
        }
        final avgOccupancy =
            data.isEmpty ? 0 : (totalOccupancy / data.length) * 100;

        // Example dummy data for monthly admissions/discharges
        final monthlyAdmissions = List.generate(12, (i) => (i + 3) * 2);
        final monthlyDischarges = List.generate(12, (i) => (i + 2) * 2);

        emit(state.copyWith(
          isLoading: false,
          bedOccupancy: avgOccupancy.toDouble(),
          departmentDistribution: departmentDistribution.map((key, value) => MapEntry(key, value)),
          monthlyAdmissions: monthlyAdmissions,
          monthlyDischarges: monthlyDischarges,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print("Error loading analytics: $e");
      emit(state.copyWith(isLoading: false));
    }
  }
}

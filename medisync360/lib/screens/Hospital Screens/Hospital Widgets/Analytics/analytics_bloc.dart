import 'package:flutter_bloc/flutter_bloc.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc() : super(const AnalyticsState()) {
    on<LoadAnalytics>(_onLoadAnalytics);
  }

  Future<void> _onLoadAnalytics(
      LoadAnalytics event, Emitter<AnalyticsState> emit) async {
    emit(state.copyWith(isLoading: true));

    // simulate data fetching delay
    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(
      isLoading: false,
      bedOccupancy: 78.5,
      monthlyAdmissions: [40, 45, 50, 60, 55, 65, 70, 60, 50, 58, 62, 66],
      monthlyDischarges: [30, 38, 45, 48, 42, 55, 60, 58, 49, 54, 57, 61],
      departmentDistribution: {
        "ICU": 12,
        "General": 35,
        "Emergency": 15,
        "Maternity": 10,
        "Surgery": 20,
      },
    ));
  }
}

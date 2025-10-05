import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Analytics/analytics_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Analytics/analytics_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Analytics/analytics_state.dart';

class AnalyticsComponent extends StatelessWidget {
  const AnalyticsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsBloc()..add(LoadAnalytics()),
      child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hospital Analytics",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                _buildBedOccupancyCard(state.bedOccupancy),
                const SizedBox(height: 25),

                _buildLineChart(
                    state.monthlyAdmissions, state.monthlyDischarges),
                const SizedBox(height: 25),

                _buildDepartmentPieChart(state.departmentDistribution),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBedOccupancyCard(double bedOccupancy) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.local_hotel, color: Colors.teal, size: 36),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Bed Occupancy Rate",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text("${bedOccupancy.toStringAsFixed(1)}%",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal)),
              ],
            ),
            const Spacer(),
            CircularProgressIndicator(
              value: bedOccupancy / 100,
              backgroundColor: Colors.grey.shade300,
              color: Colors.teal,
              strokeWidth: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(
      List<int> admissions, List<int> discharges) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Monthly Admissions vs Discharges",
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          const months = [
                            "Jan",
                            "Feb",
                            "Mar",
                            "Apr",
                            "May",
                            "Jun",
                            "Jul",
                            "Aug",
                            "Sep",
                            "Oct",
                            "Nov",
                            "Dec"
                          ];
                          if (value < 0 || value >= 12) return const SizedBox();
                          return Text(months[value.toInt()],
                              style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.teal,
                      barWidth: 3,
                      spots: List.generate(admissions.length,
                          (i) => FlSpot(i.toDouble(), admissions[i].toDouble())),
                    ),
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 3,
                      spots: List.generate(discharges.length,
                          (i) => FlSpot(i.toDouble(), discharges[i].toDouble())),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentPieChart(Map<String, int> data) {
    final total = data.values.fold(0, (sum, v) => sum + v);
    final sections = data.entries
        .map((e) => PieChartSectionData(
              value: e.value.toDouble(),
              title:
                  "${e.key}\n${((e.value / total) * 100).toStringAsFixed(1)}%",
              radius: 80,
              titleStyle: const TextStyle(fontSize: 12),
            ))
        .toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Department-wise Patient Distribution",
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: PieChart(PieChartData(
                centerSpaceRadius: 40,
                sections: sections,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

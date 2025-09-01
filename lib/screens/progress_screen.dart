import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habits_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitsProvider>().habits;

    // Build last 7 days completion counts
    final today = DateTime.now();
    List<DateTime> days = List.generate(7, (i)=>DateTime(today.year, today.month, today.day).subtract(Duration(days: 6-i)));
    List<BarChartGroupData> bars = [];
    for (int i=0; i<days.length; i++) {
      final d = days[i];
      int count = habits.where((h)=> h.completionHistory.any((x)=>x.year==d.year && x.month==d.month && x.day==d.day)).length;
      bars.add(BarChartGroupData(x: i, barRods: [BarChartRodData(toY: count.toDouble())]));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Last 7 days', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Expanded(
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, meta) {
                      final d = days[v.toInt()];
                      return Text('${d.month}/${d.day}');
                    },
                  )),
                ),
                barGroups: bars,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

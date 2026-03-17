import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, _) {
            final byCat = provider.spendingByCategory;
            final total = provider.totalExpenses;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ─────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analytics',
                          style: TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrim,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Spending breakdown this month',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSec,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Donut chart ────────────────────────────
                  _DonutChart(
                    byCat: byCat,
                    total: total,
                    touchedIndex: _touchedIndex,
                    onTouch: (i) => setState(() => _touchedIndex = i),
                  ),

                  const SizedBox(height: 24),

                  // ── Legend / category breakdown ────────────
                  if (byCat.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'No expenses recorded yet',
                          style: TextStyle(
                            color: AppTheme.textTert,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: byCat.entries.map((entry) {
                          final pct = total > 0
                              ? (entry.value / total * 100).toStringAsFixed(1)
                              : '0';
                          final color =
                              AppTheme.catColors[entry.key] ?? AppTheme.textSec;
                          return _LegendItem(
                            label: AppTheme.catLabels[entry.key] ?? entry.key,
                            icon: AppTheme.catIcons[entry.key] ?? '✨',
                            color: color,
                            percent: pct,
                            amount: entry.value,
                          );
                        }).toList(),
                      ),
                    ),

                  const SizedBox(height: 28),

                  // ── Monthly bar chart ──────────────────────
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
                    child: Text(
                      'Monthly trend',
                      style: TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrim,
                      ),
                    ),
                  ),
                  _MonthlyBarChart(currentMonthTotal: total),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Donut chart widget ──────────────────────────────────────

class _DonutChart extends StatelessWidget {
  final Map<String, double> byCat;
  final double total;
  final int touchedIndex;
  final ValueChanged<int> onTouch;

  const _DonutChart({
    required this.byCat,
    required this.total,
    required this.touchedIndex,
    required this.onTouch,
  });

  @override
  Widget build(BuildContext context) {
    final sections = byCat.isEmpty
        ? [
            PieChartSectionData(
              color: AppTheme.bg4,
              value: 1,
              title: '',
              radius: 52,
            )
          ]
        : byCat.entries.toList().asMap().entries.map((entry) {
            final i = entry.key;
            final cat = entry.value.key;
            final val = entry.value.value;
            final isTouched = i == touchedIndex;
            return PieChartSectionData(
              color: AppTheme.catColors[cat] ?? AppTheme.textSec,
              value: val,
              title: '',
              radius: isTouched ? 62 : 52,
            );
          }).toList();

    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 60,
              sectionsSpace: 3,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.touchedSection == null) {
                    onTouch(-1);
                    return;
                  }
                  onTouch(response.touchedSection!.touchedSectionIndex);
                },
              ),
            ),
          ),
          // Centre label
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'TOTAL',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 9,
                  letterSpacing: 1.2,
                  color: AppTheme.textSec,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                Fmt.currency(total),
                style: const TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Legend item ─────────────────────────────────────────────

class _LegendItem extends StatelessWidget {
  final String label, icon, percent;
  final Color color;
  final double amount;

  const _LegendItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.percent,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.bg3,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrim,
              ),
            ),
          ),
          Text(
            '$percent%',
            style: const TextStyle(fontSize: 12, color: AppTheme.textSec),
          ),
          const SizedBox(width: 12),
          Text(
            Fmt.currency(amount),
            style: const TextStyle(
              fontFamily: 'Syne',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.gold,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Monthly bar chart ───────────────────────────────────────

class _MonthlyBarChart extends StatelessWidget {
  final double currentMonthTotal;

  const _MonthlyBarChart({required this.currentMonthTotal});

  @override
  Widget build(BuildContext context) {
    // Mock data for prior months — in a real app read from Hive
    final values = [82000.0, 145000, 98000, 203000, 175000, 130000, 95000,
      currentMonthTotal > 0 ? currentMonthTotal : 68000];
    final labels = ['Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar'];
    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.bg3,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: SizedBox(
          height: 160,
          child: BarChart(
            BarChartData(
              maxY: maxVal * 1.15,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final i = value.toInt();
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          labels[i],
                          style: const TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 9,
                            color: AppTheme.textTert,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(values.length, (i) {
  final isCurrent = i == values.length - 1;
  return BarChartGroupData(
    x: i,
    barRods: [
      BarChartRodData(
        toY: values[i].toDouble(),
                      width: 22,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                      color: isCurrent ? AppTheme.gold : AppTheme.bg4,
                      gradient: isCurrent
                          ? const LinearGradient(
                              colors: [AppTheme.goldLight, AppTheme.gold],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

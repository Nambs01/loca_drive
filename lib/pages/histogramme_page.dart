import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loca_vam/stores/location_store.dart';
import 'package:provider/provider.dart';

import '../utils/format_currency.dart';

class LocationHistogram extends StatelessWidget {
  const LocationHistogram({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<LocationStore>(
      builder: (context, store, child) {
        if (store.locations.isEmpty) {
          return Center(
            child: const Text("Aucune donnée disponible"),
          );
        }

        final montants = store.locations.map((loc) => loc.montant).toList();
        final primaryColor = Theme.of(context).primaryColor;

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Statistiques des montants",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatsRow(context, montants.cast<double>()),
                const SizedBox(height: 24),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceBetween,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final loc = store.locations[groupIndex];
                            return BarTooltipItem(
                              "${loc.nomLocation}\n${loc.montant.toStringAsFixed(2)} Ar",
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Loc ${value.toInt() + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: store.locations.asMap().entries.map((entry) {
                        final index = entry.key;
                        final location = entry.value;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: location.montant,
                              color: primaryColor.withOpacity(0.7),
                              width: 16,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },

    );
  }

  Widget _buildStatsRow(BuildContext context, List<double> montants) {
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;

    final max = montants.reduce((a, b) => a > b ? a : b);
    final min = montants.reduce((a, b) => a < b ? a : b);
    final total = montants.fold(0.0, (sum, item) => sum + item);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard(
          "Total",
          formatCurrency(total),
          primaryColor,
          textTheme,
        ),
        _buildStatCard(
          "Max",
          formatCurrency(max),
          Colors.redAccent,
          textTheme,
        ),
        _buildStatCard(
          "Min",
          formatCurrency(min),
          Colors.green,
          textTheme,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      Color color,
      TextTheme textTheme,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              text: value,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            )
          ),
        ],
      ),
    );
  }
}
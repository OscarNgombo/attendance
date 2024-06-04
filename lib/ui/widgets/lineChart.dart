import 'package:attendance/models/chart.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series<DataPoint, DateTime>> seriesList; // Updated type for seriesList
  final bool animate;

  const SimpleLineChart(this.seriesList, {super.key, required this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SimpleLineChart.withData(List<DataPoint> dataPoints) {
    return SimpleLineChart(
      _createSeriesData(dataPoints),
      animate: false, // Removed the comment to avoid syntax error
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(seriesList, animate: animate);
  }

  // Map the data points to series for the chart
  static List<charts.Series<DataPoint, DateTime>> _createSeriesData(List<DataPoint> dataPoints) {
    return [
      charts.Series<DataPoint, DateTime>(
        id: 'TimeData',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DataPoint dataPoint, _) => dataPoint.date,
        measureFn: (DataPoint dataPoint, _) => dataPoint.time,
        data: dataPoints,
      )
    ];
  }
}

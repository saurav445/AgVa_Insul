import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:insul_app/utils/Colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartDataInfo {
  ChartDataInfo(this.time, this.value, [this.color]);

  final String time;
  final double value;
  final Color? color;
}

final List<ChartDataInfo> data24Hours = List.generate(
  24,
  (index) => ChartDataInfo(
      index.toString(), (index + 1) * 5.0, AppColor.insulinChartColor),
);

final List<ChartDataInfo> dataMonth = [
  ChartDataInfo('1', 100, AppColor.insulinChartColor),
  ChartDataInfo('7', 200, AppColor.insulinChartColor),
  ChartDataInfo('14', 300, AppColor.insulinChartColor),
  ChartDataInfo('21', 400, AppColor.insulinChartColor),
  ChartDataInfo('28', 500, AppColor.insulinChartColor),
];

final List<ChartDataInfo> dataYear = [
  ChartDataInfo('Jan', 100, AppColor.insulinChartColor),
  ChartDataInfo('Feb', 200, AppColor.insulinChartColor),
  ChartDataInfo('Mar', 300, AppColor.insulinChartColor),
  ChartDataInfo('Apr', 400, AppColor.insulinChartColor),
  ChartDataInfo('May', 500, AppColor.insulinChartColor),
  ChartDataInfo('Jun', 600, AppColor.insulinChartColor),
  ChartDataInfo('Jul', 700, AppColor.insulinChartColor),
  ChartDataInfo('Aug', 800, AppColor.insulinChartColor),
  ChartDataInfo('Sep', 900, AppColor.insulinChartColor),
  ChartDataInfo('Oct', 1000, AppColor.insulinChartColor),
  ChartDataInfo('Nov', 1100, AppColor.insulinChartColor),
  ChartDataInfo('Dec', 1200, AppColor.insulinChartColor),
];

class Insulinchart extends StatefulWidget {
  const Insulinchart({Key? key}) : super(key: key);

  @override
  _InsulinchartState createState() => _InsulinchartState();
}

class _InsulinchartState extends State<Insulinchart> {
  final List<String> periods = ['24 Hours', 'Month', 'Year'];
  int currentIndex = 0;
  List<ChartDataInfo> chartData = data24Hours;
  bool refreshActive = false;

  void _updateChartData() {
    setState(() {
      currentIndex = (currentIndex + 1) % periods.length;
      if (periods[currentIndex] == '24 Hours') {
        chartData = data24Hours;
      } else if (periods[currentIndex] == 'Month') {
        chartData = dataMonth;
      } else if (periods[currentIndex] == 'Year') {
        chartData = dataYear;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'INSULIN',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        fontSize: height * 0.015,
                        fontWeight: AppColor.weight600),
                  ),
                  GestureDetector(
                    onTap: _updateChartData,
                    child: Text(
                      periods[currentIndex],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        fontSize: height * 0.015,
                        fontWeight: AppColor.weight600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    refreshActive ? 'Refreshing..' : 'Tap to Refresh',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      fontSize: height * 0.014,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  AnimateIcon(
                    onTap: () {
                      setState(() {
                        refreshActive = true;
                      });
                      Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          refreshActive = false;
                        });
                      });
                    },
                    iconType: IconType.animatedOnTap,
                    height: height * 0.02,
                    width: width * 0.04,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    animateIcon: AnimateIcons.refresh,
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.01),
            Container(
              height: height * 0.23,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SfCartesianChart(
                tooltipBehavior: TooltipBehavior(color: Colors.red),
                plotAreaBorderWidth: 0.1,
                primaryXAxis: CategoryAxis(
                  axisLine: AxisLine(color: Colors.grey),
                  majorTickLines: MajorTickLines(color: Colors.grey),
                  labelRotation: 0,
                  interval: periods[currentIndex] == 'Month' ? 1 : 1,
                  minimum: 0,
                  majorGridLines: MajorGridLines(width: 0),
                  labelStyle: TextStyle(
                    fontSize: 8,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  axisLine: AxisLine(color: Colors.grey),
                  majorTickLines: MajorTickLines(color: Colors.grey),
                  interval: periods[currentIndex] == '24 Hours' ? 20 : 100,
                  majorGridLines: MajorGridLines(width: 0),
                  labelStyle: TextStyle(
                    fontSize: 8,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                series: <CartesianSeries<dynamic, dynamic>>[
                  ColumnSeries<ChartDataInfo, String>(
                    width: 0.3,
                    spacing: 0,
                    dataSource: chartData,
                    pointColorMapper: (ChartDataInfo data, _) => data.color,
                    xValueMapper: (ChartDataInfo data, _) => data.time,
                    yValueMapper: (ChartDataInfo data, _) => data.value,
                    enableTooltip: true,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: false,
                      angle: 0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

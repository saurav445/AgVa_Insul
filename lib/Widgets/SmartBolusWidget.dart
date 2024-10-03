import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:insul_app/Middleware/SharedPrefsHelper.dart';
import 'package:insul_app/Widgets/ShimmerEffect.dart';
import 'package:insul_app/utils/Colors.dart';
import 'package:insul_app/utils/config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartDataInfo {
  ChartDataInfo(this.time, this.value, [this.color]);

  final String time;
  final double value;
  final Color? color;
}

class SmartBolusWidget extends StatefulWidget {
  @override
  State<SmartBolusWidget> createState() => _SmartBolusWidgetState();
}

class _SmartBolusWidgetState extends State<SmartBolusWidget> {
  Future<void>? _smartBolusChart;
  List<ChartDataInfo> chartData = [];

  @override
  void initState() {
    super.initState();
    _smartBolusChart = _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    final dio = Dio();

    final _sharedPreference = SharedPrefsHelper();
    final String? userId = await _sharedPreference.getString('userId');

    try {
      final response = await dio.get(
        '$smartBolasData/$userId',
        queryParameters: {'filter': '24hour-data'},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;

        setState(() {
          chartData = data.map<ChartDataInfo>((item) {
            return ChartDataInfo(
              item['time'],
              double.parse(item['unit']),
              AppColor.smartbolusChartColor,
            );
          }).toList();
        });
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error fetching chart data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SMART',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: height * 0.023,
                  ),
                ),
                Text(
                  'BOLUS',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: height * 0.023,
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: _smartBolusChart,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SmartBolusOuterShimmereffect();
                } else if (snapshot.hasError || chartData.isEmpty) {
                  return Center(
                    child: Text(
                      'No Data found',
                      style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
                    ),
                  );
                } else {
                  return Container(
                    width: width * 0.65,
                    height: height * 0.09,
                    child: SfCartesianChart(
                      plotAreaBorderWidth: 0.0,
                      primaryXAxis: CategoryAxis(
                        majorTickLines: MajorTickLines(width: 0.0),
                        axisLine: AxisLine(width: 0),
                        labelRotation: 0,
                        majorGridLines: MajorGridLines(width: 0.0),
                        labelStyle: TextStyle(fontSize: 10),
                      ),
                      primaryYAxis: NumericAxis(
                        majorTickLines: MajorTickLines(width: 0.0),
                        axisLine: AxisLine(width: 0),
                        labelRotation: 0,
                        majorGridLines: MajorGridLines(width: 0.0),
                        labelStyle: TextStyle(fontSize: 10),
                      ),
                      series: <CartesianSeries<dynamic, dynamic>>[
                        ColumnSeries<ChartDataInfo, String>(
                          borderRadius: BorderRadius.circular(50),
                          width: 0.6,
                          dataSource: chartData,
                          pointColorMapper: (ChartDataInfo data, _) => data.color,
                          xValueMapper: (ChartDataInfo data, _) => data.time,
                          yValueMapper: (ChartDataInfo data, _) => data.value,
                          enableTooltip: false,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            angle: 0,
                            builder: (
                              data,
                              point,
                              series,
                              pointIndex,
                              seriesIndex,
                            ) {
                              if (chartData[pointIndex].value == 0) {
                                return Icon(
                                  Icons.circle,
                                  color: Color.fromARGB(255, 207, 207, 207),
                                  size: 8,
                                );
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}



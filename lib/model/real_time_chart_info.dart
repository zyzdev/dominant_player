import 'dart:math';

import 'package:dominant_player/model/chart_data.dart';
import 'package:dominant_player/model/chart_info.dart';

class RealTimeChartInfo with ChartUtil {
  RealTimeChartInfo(this.xPeriod, this.allTicks) {
    _updateAllChartInfo();
    _updateCurrentChartValues();
  }

  final int xPeriod;
  final List<List<String>> allTicks;

  final List<ChartInfo> allChartInfo = [];

  int curOpen = 0;
  int curClose = 0;
  int curHigh = 0;

  double curMiddle = 0;
  int curLow = 0;
  int curVolume = 0;
  int curDistance = 0;
  int closeToOpenDis = 0;

  void _updateAllChartInfo() {
    ChartInfo getChartInfo(List<List<String>> considerTicks) {
      int open = double.parse(tickOpen(considerTicks.first)).toInt();
      int close = double.parse(tickClose(considerTicks.last)).toInt();
      int high = considerTicks.map((e) => double.parse(e[2]).toInt()).fold(
          -1,
          (previousValue, element) => previousValue == -1
              ? element
              : previousValue < element
                  ? element
                  : previousValue);
      int low = considerTicks.map((e) => double.parse(e[3]).toInt()).fold(
          -1,
          (previousValue, element) => previousValue == -1
              ? element
              : previousValue > element
                  ? element
                  : previousValue);
      int volume = considerTicks
          .map((e) => double.parse(e[5]).toInt())
          .reduce((value, element) => value + element);
      return ChartInfo(
        period: xPeriod,
        open: open,
        high: high,
        close: close,
        low: low,
        volume: volume,
        startTime: considerTicks.first[0],
        endTime: considerTicks.last[0],
      );
    }

    for (int i = 0; i < allTicks.length / xPeriod; i++) {
      final chartInfo = getChartInfo(allTicks.sublist(
          i * xPeriod, min((i + 1) * xPeriod, allTicks.length)));
      allChartInfo.add(chartInfo);
    }
  }

  void _updateCurrentChartValues() {
    if (allTicks.isEmpty) return;
    curOpen = allChartInfo.last.open;
    curClose = allChartInfo.last.close;
    curHigh = allChartInfo.last.high;
    curLow = allChartInfo.last.low;
    curMiddle = (curHigh + curLow) / 2;
    curVolume = allChartInfo.last.volume;
    curDistance = max(0, curHigh - curLow);
    closeToOpenDis = curClose - curOpen;
  }

  ChartInfo? getLastFinishChartInfo() {
    if (allChartInfo.length > 1) return allChartInfo[allChartInfo.length - 2];
    return null;
  }

  String get curTime => tickTime(allTicks.last);
}

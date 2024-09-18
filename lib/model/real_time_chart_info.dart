import 'dart:math';

import 'package:dominant_player/model/chart_data.dart';
import 'package:dominant_player/model/candle_info.dart';

class RealTimeChartInfo with ChartUtil {
  RealTimeChartInfo(this.xPeriod, this.allTicks) {
    _updateAllCandleInfo();
    _updateCurrentCandleValues();
  }

  final int xPeriod;
  final List<List<String>> allTicks;

  final List<CandleInfo> allCandleInfo = [];

  int curOpen = 0;
  int curClose = 0;
  int curHigh = 0;

  double curMiddle = 0;
  int curLow = 0;
  int curVolume = 0;
  int curDistance = 0;
  int closeToOpenDis = 0;

  late int low = allCandleInfo
      .map((e) => e.low)
      .reduce((value, element) => value < element ? value : element);


  late int high = allCandleInfo
      .map((e) => e.high)
      .reduce((value, element) => value > element ? value : element);

  void _updateAllCandleInfo() {
    CandleInfo getCandleInfo(List<List<String>> considerTicks) {
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

      // start time & end time 都減一分鐘
      return CandleInfo(
        period: xPeriod,
        open: open,
        high: high,
        close: close,
        low: low,
        volume: volume,
        startTime: fineTuneTime(considerTicks.first[0]),
        endTime: fineTuneTime(considerTicks.last[0]),
      );
    }

    for (int i = 0; i < allTicks.length / xPeriod; i++) {
      final chartInfo = getCandleInfo(allTicks.sublist(
          i * xPeriod, min((i + 1) * xPeriod, allTicks.length)));
      allCandleInfo.add(chartInfo);
    }
  }

  void _updateCurrentCandleValues() {
    if (allTicks.isEmpty) return;
    curOpen = allCandleInfo.last.open;
    curClose = allCandleInfo.last.close;
    curHigh = allCandleInfo.last.high;
    curLow = allCandleInfo.last.low;
    curMiddle = (curHigh + curLow) / 2;
    curVolume = allCandleInfo.last.volume;
    curDistance = max(0, curHigh - curLow);
    closeToOpenDis = curClose - curOpen;
  }

  CandleInfo? getLastFinishCandleInfo() {
    if (allCandleInfo.length > 1)
      return allCandleInfo[allCandleInfo.length - 2];
    return null;
  }

  String get curTime => tickTime(allTicks.last);
}

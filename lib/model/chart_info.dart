import 'dart:math';

import 'package:dominant_player/model/chart_data.dart';

class ChartInfo with ChartUtil {
  ChartInfo(this.xPeriod, this.allTicks) {
    _updateChartValues();
  }

  final int xPeriod;
  final List<List<String>> allTicks;

  int open = 0;
  int close = 0;
  int high = 0;
  int low = 0;
  int volume = 0;

  int distance = 0;
  int closeToOpenDis = 0;

  void _updateChartValues() {
    if (allTicks.isEmpty) return;
    final considerTicks = _considerTicks;
    open = double.parse(tickOpen(considerTicks.first)).toInt();
    close = double.parse(curClose).toInt();
    high = considerTicks.map((e) => double.parse(e[2]).toInt()).fold(
        -1,
        (previousValue, element) => previousValue == -1
            ? element
            : previousValue < element
                ? element
                : previousValue);
    low = considerTicks.map((e) => double.parse(e[3]).toInt()).fold(
        -1,
        (previousValue, element) => previousValue == -1
            ? element
            : previousValue > element
                ? element
                : previousValue);
    volume = considerTicks
        .map((e) => double.parse(e[5]).toInt())
        .reduce((value, element) => value + element);
    distance = max(0, high - low);
    closeToOpenDis = close - open;
  }

  void _shouldNotice() {
    // 正常來說，目前考慮的一分K只會有一個，代表才剛剛開始新的一分K
    if (_considerTicks.length > 1) return;

    // 計算剛剛完成的[xPeriod]分K棒的開高低收量
    final kChartTicks = allTicks.sublist(max(0, allTicks.length - xPeriod - 1));
    List<int> toValue(List<String> data) =>
        data.map((e) => double.parse(e).toInt()).toList();
    int open = double.parse(kChartTicks.first[1]).toInt();
    int close = double.parse(kChartTicks.last[4]).toInt();
    int high = kChartTicks.map((e) => double.parse(e[2]).toInt()).fold(
        -1,
        (previousValue, element) => previousValue == -1
            ? element
            : previousValue < element
                ? element
                : previousValue);
    int low = kChartTicks.map((e) => double.parse(e[3]).toInt()).fold(
        -1,
        (previousValue, element) => previousValue == -1
            ? element
            : previousValue > element
                ? element
                : previousValue);
    int volume = kChartTicks
        .map((e) => double.parse(e[5]).toInt())
        .fold(0, (previousValue, element) => previousValue + element);
  }

  List<List<String>> get _considerTicks {
    int h = double.parse(curTime.substring(0, 2)).toInt();
    int m = double.parse(curTime.substring(2, 4)).toInt();
    int s = double.parse(curTime.substring(4)).toInt();
    int minutes = h * 60 + m;
    int offset = minutes % xPeriod;
    if (offset == 0) offset = xPeriod;
    return allTicks.sublist(max(0, allTicks.length - offset));
  }

  String get curTime => tickTime(allTicks.last);

  String get curClose => tickClose(allTicks.last);

}

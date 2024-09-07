import 'dart:math';

import 'package:dominant_player/model/chart_data.dart';
import 'package:dominant_player/model/tick.dart';
import 'package:intl/intl.dart';

class ChartInfo with ChartUtil {
  ChartInfo(this.xPeriod);

  final int xPeriod;
  final List<List<String>> _allTicks = [];

  String open = '';
  String close = '';
  String high = '';
  String low = '';

  void updateCurrentTick(Tick curTick) {
    if (_allTicks.isEmpty) {
      _allTicks.addAll(curTick.tickData);
    } else {
      final dateFormat = DateFormat('hhmmss');
      DateTime lastTime = dateFormat.parse(this.curTime);
      DateTime curTime = dateFormat.parse(curTick.curTime);
      if (curTime.isAfter(lastTime)) {
        _allTicks.add(curTick.tickData.last);
      } else {
        _allTicks[_allTicks.length - 1] = curTick.tickData.last;
      }
    }
    _updateChartValues();
  }

  void _updateChartValues() {
    open = tickOpen(_considerTicks.first);
    close = curClose;
    if(int.parse(curHigh) > int.parse(high)) high = curHigh;
    if(int.parse(curLow) > int.parse(low)) low = curLow;
  }

  List<List<String>> get _considerTicks {
    return _allTicks.sublist(max(0, _allTicks.length - xPeriod)).toList();
  }

  String get curTime => tickTime(_allTicks.last);

  String get curOpen => tickOpen(_allTicks.last);

  String get curHigh => tickHigh(_allTicks.last);

  String get curLow => tickLow(_allTicks.last);

  String get curClose => tickClose(_allTicks.last);

  String get curVolume => tickVolume(_allTicks.last);
}

import 'chart_data.dart';

class Ticks with ChartUtil {
  List<List<String>> allTicks = [];

  String get curTime => allTicks.last[0];
  String get curOpen => allTicks.last[1];
  String get curHigh => allTicks.last[2];
  String get curLow => allTicks.last[3];
  String get curClose => allTicks.last[4];
  String get curVolume => allTicks.last[5];

  Ticks? updateTick(List<String> tick) {

    if(allTicks.isEmpty) {
      return Ticks()..allTicks.add(tick);
    }
    int index = allTicks.indexWhere((element) => tickTime(allTicks.last) == tickTime(tick));
    if(index == -1) {
      return Ticks()..allTicks.add(tick);
    }
    allTicks[index] = tick;
    return Ticks()..allTicks.addAll(allTicks);
  }
}
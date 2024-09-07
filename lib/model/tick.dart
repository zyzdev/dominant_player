import 'chart_data.dart';

class Tick with ChartUtil {

  Tick([this.tickData = const[]]);
  final List<List<String>> tickData;

  bool compareDiff(Tick newTick) {
    List<List<String>> newTickData = newTick.tickData;
    if(tickData.length != newTickData.length) return true;
      return tickDiff(tickData.last, newTickData.last);
  }

  String get curTime => tickTime(tickData.last);
  String get curOpen => tickOpen(tickData.last);
  String get curHigh => tickHigh(tickData.last);
  String get curLow => tickLow(tickData.last);
  String get curClose => tickClose(tickData.last);
  String get curVolume => tickVolume(tickData.last);

}
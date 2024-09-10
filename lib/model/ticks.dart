import 'chart_data.dart';

class Ticks with ChartUtil {
  List<List<String>> allTicks = [];

  void setAllTicks(List<List<String>> newTicks) {
    // 檢查倒數兩比的時間是否一樣
    if(!tickTimeDiff(newTicks[newTicks.length - 2], newTicks.last)) {
      // 刪除比較好看時間的那一筆，對齊currentTickProvider的結構
      newTicks.remove(newTicks.last);
    }
    allTicks = newTicks;
  }
  String get curTime => allTicks.last[0];

  String get curOpen => allTicks.last[1];

  String get curHigh => allTicks.last[2];

  String get curLow => allTicks.last[3];

  String get curClose => allTicks.last[4];

  String get curVolume => allTicks.last[5];

  Ticks? updateTick(List<String> tick) {
    if (allTicks.isEmpty) {
      return null;
    }


    // 新增還是取代最後一筆
    bool? add = addOrReplace(allTicks, tick);
    if (add == true) {
      allTicks.add(tick);
    } else if(add == false){
      allTicks[allTicks.length - 1] = tick;
    }
    return Ticks()..allTicks = allTicks;
  }
}

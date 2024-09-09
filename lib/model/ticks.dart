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


  // true 代表要新增
  bool? addOrReplace(List<String> newTick) {
    if(allTicks.isEmpty) return null;
    String timeA = tickTime(allTicks.last);
    String timeB = tickTime(newTick);
    int ha = double.parse(timeA.substring(0, 2)).toInt();
    int ma = double.parse(timeA.substring(2, 4)).toInt();
    int sa = double.parse(timeA.substring(4)).toInt();
    int minuteA = ha * 60 + ma;
    int hb = double.parse(timeB.substring(0, 2)).toInt();
    int mb = double.parse(timeB.substring(2, 4)).toInt();
    int sb = double.parse(timeB.substring(4)).toInt();
    int minuteB = hb * 60 + mb;
    // 分鐘比較大，要新增
    if (minuteB > minuteA) return true;
    // 秒數不同，要取代
    if(sb > sa) return false;
    // 數值不同，要取代
    if(tickValuesDiff(allTicks.last, newTick)) return false;

    return null;
  }

  Ticks? updateTick(List<String> tick) {
    if (allTicks.isEmpty) {
      return null;
    }


    // 新增還是取代最後一筆
    bool? add = addOrReplace(tick);
    if (add == true) {
      allTicks.add(tick);
    } else if(add == false){
      allTicks[allTicks.length - 1] = tick;
    }
    return Ticks()..allTicks = allTicks;
  }
}

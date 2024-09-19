import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'holiday_info.dart';

/// return [high, low]
/// [isDay] 是否為日盤
Future<List<String>> fetchSpyPrice([bool isDay = true]) async {
  String spyDate(bool isDay) {
    DateTime spyDate = DateTime.now().toUtc().add(const Duration(hours: 8));
    // 判斷使用日盤還是夜盤，時區必須一致
    final now = DateTime.now().toUtc().add(const Duration(hours: 8));
    final nowYMD = DateTime(now.year, now.month, now.day).toUtc().add(const Duration(hours: 8));
    DateTime dayStartTime = nowYMD.add(const Duration(hours: 8, minutes: 44, seconds: 59)); // 8:45
    DateTime dayEndTime = nowYMD.add(const Duration(hours: 13, minutes: 45, seconds: 1)); // 13:45

    DateTime nightStartTime =
        nowYMD.add(const Duration(hours: 14, minutes: 59, seconds: 59)); // 15:00
    DateTime nightEndTime = nowYMD.add(const Duration(days: 1, hours: 5, seconds: 1)); // 隔天凌晨五點

    if (isDay) {
      // 如果日盤已結束，用今天的，否則用上一次日盤的資料
      if (spyDate.isBefore(dayEndTime)) spyDate = spyDate.subtract(const Duration(days: 1));
    } else {
      spyDate = spyDate.subtract(const Duration(days: 1));
    }
    while (isHoliday(spyDate)) {
      spyDate = spyDate.subtract(const Duration(days: 1));
    }

    return DateFormat('yyyy/MM/dd').format(spyDate);
  }

  final response =
      await Client().post(Uri.parse('https://www.taifex.com.tw/cht/3/futDailyMarketReport'), body: {
    'queryType': '2',
    'marketCode': isDay ? '0' : '1',
    'commodity_id': 'TX',
    'queryDate': spyDate(isDay),
    'MarketCode': '0',
    'commodity_idt': 'TX'
  });
  String high = '';
  String low = '';
  if (response.statusCode == 200) {
    final document = parse(response.body);
    final List<Element> divs = document
        .getElementsByTagName('div')
        .where((element) => element.className == 'sidebar_right')
        .toList();
    Element element = divs.first
        .getElementsByTagName('div')
        .where((element) => element.id == 'printhere')
        .elementAt(1);
    List<Element> values = element.getElementsByTagName('td');
    high = values[3].text;
    low = values[4].text;
  }
  return [high, low];
}

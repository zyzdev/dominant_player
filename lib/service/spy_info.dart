import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

/// return [high, low]
/// [isDay] 是否為日盤
Future<List<String>> fetchSpyPrice([bool isDay = true]) async {
  String spyDate(bool isDay) {
    final now = DateTime.now().toUtc().add(const Duration(hours: 8));
    // final now = DateTime.now().subtract(Duration(days: 2, hours: 1, minutes: 47));
    late DateTime spyDate;
    if (now.weekday > DateTime.friday) {
      spyDate = isDay
          ? now.subtract(Duration(days: now.weekday - DateTime.friday))
          : now.add(Duration(days: now.weekday == DateTime.saturday ? 2 : 1));
    } else {
      if (now.hour < 15 && now.minute < 55) {
        spyDate = now.subtract(const Duration(days: 1));
      } else {
        spyDate = now;
      }
    }
    return DateFormat('yyyy/MM/dd').format(spyDate);
  }

  final response = await Client().post(
      Uri.parse('https://www.taifex.com.tw/cht/3/futDailyMarketReport'),
      body: {
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


import 'package:dominant_player/main_provider.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

final List<String> _holidays = [];

Future<void> fetchTaiwanHoliday() async {
  final y = DateTime.now().year;
  final holidayStoreKey = '${y}_holiday';
  final List<String> holidays = prefs.getStringList(holidayStoreKey) ?? [];

  if (holidays.isNotEmpty) {
    _holidays.addAll(holidays);
    return;
  }

  void removeExpiredData() {
    final expiredHolidayStoreKey = '${y - 1}_holiday';
    if (prefs.getStringList(expiredHolidayStoreKey) != null) {
      prefs.remove(expiredHolidayStoreKey);
    }
  }

  Response req = await Client().get(Uri.parse(
      'https://holidays-calendar.net/calendar_zh_tw/taiwan_zh_tw.html'));
  final dateFormat = DateFormat('y-MM-dd');
  if (req.statusCode == 200) {
    final document = parse(req.body);
    final List<Element> months = document
        .getElementsByTagName('div')
        .where((element) => element.className == 'item01' || element.className == 'item02')
    .expand((element) => element.getElementsByClassName('month-cell'))
        .toList();
    for (int i = 0; i < months.length; i++) {
      months[i].getElementsByTagName('tr').forEach((element) {
        element
            .getElementsByTagName('td')
            .where(
              (element) =>
          element.className.contains('hol') ||
              element.className.contains('day sat') ||
              element.className.contains('day sun'),
        )
            .forEach((element) {
          int? day = int.tryParse(element.text);
          if(day != null) {
            final dateTime = DateTime(y, i + 1, day);
            String date = dateFormat.format(dateTime);
            holidays.add(date);
          }
        });
      });
    }
  }
  _holidays.addAll(holidays);
  prefs.setStringList(holidayStoreKey, holidays);
  removeExpiredData();
}

bool isHoliday([DateTime? dateTime]) {
  dateTime ??= DateTime.now().toUtc().add(const Duration(hours: 8));
  return _holidays.contains(DateFormat('y-MM-dd').format(dateTime));
}


bool inTrade(DateTime dateTime, {bool isFuture = false}) {
  if (isHoliday(dateTime)) return false;
  final d = Duration(
      hours: dateTime.hour, minutes: dateTime.minute, seconds: dateTime.second);
  if (isFuture) {
    const open = Duration(hours: 8, minutes: 45, seconds: 0);
    const close = Duration(hours: 13, minutes: 45, seconds: 0);
    if (d < open || d >= close) return false;
  } else {
    const open = Duration(hours: 9, minutes: 0, seconds: 0);
    const close = Duration(hours: 13, minutes: 30, seconds: 0);
    if (d < open || d >= close) return false;
  }

  return true;
}

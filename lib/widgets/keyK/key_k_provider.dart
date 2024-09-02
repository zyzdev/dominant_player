import 'package:dominant_player/model/txf_info.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final keyKProvider =
    StateNotifierProvider.family<KeyKStateNotifier, KeyKState, KeyKState>(
  (ref, keyKState) {
    return KeyKStateNotifier(keyKState);
  },
);

class KeyKStateNotifier extends StateNotifier<KeyKState> {
  KeyKStateNotifier(super.state) {
    _initFetch();
  }

  late final RestClient _restClient = RestClient.instance;
  String _currentMonth = '';
  String _currentMonthSymbolID = '';
  Future<void> _initFetch() async {
    await _fetchCurrentMonth();
    await _fetchCurrentMonthSymbolID();
    await _fetchChartDate();
  }

  Future<void> _fetchChartDate() async {
    try {
      final response =
          await _restClient.getPerMinutePriceInfo(_currentMonthSymbolID);
      print(response.toJson());
      // ignore: empty_catches
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
    }
  }

  /// 取得近月
  Future<void> _fetchCurrentMonth() async {
    try {
      final response =
      await _restClient.getProductMonthsInfo(TxfRequest.current());
      _currentMonth = response.rtData.items
          .where((element) => element.item.length == 6)
          .reduce((value, element) {
        DateTime parseDate(String dateStr) {
          if (dateStr.length != 6) {
            throw const FormatException("Invalid date format");
          }
          final year = int.parse(dateStr.substring(0, 4));
          final month = int.parse(dateStr.substring(4, 6));
          return DateTime(year, month, 1);
        }

        // 找尋時間最小的，就是近月
        DateTime currentMonth = parseDate(value.item);
        DateTime compareMonth = parseDate(element.item);
        return currentMonth.isBefore(compareMonth) ? value : element;
      }).item;

      // 計算下一次更新近月的時間
      DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8));
      late Duration delay;
      if (isDay) {
        // 日盤等收盤就可以更新
        delay = DateTime(now.year, now.month, now.day, 13, 45).difference(now);
      } else {
        // 夜盤等收盤就可以更新
        late DateTime dis;
        if (now.hour >= 15 && now.hour <= 23) {
          dis = DateTime.fromMillisecondsSinceEpoch(
              DateTime(now.year, now.month, now.day + 1, 5, 0)
                  .millisecondsSinceEpoch -
                  now.millisecondsSinceEpoch);
        } else {
          dis = DateTime.fromMillisecondsSinceEpoch(
              DateTime(now.year, now.month, now.day, 5, 0)
                  .millisecondsSinceEpoch -
                  now.millisecondsSinceEpoch);
        }
        delay =
            Duration(hours: dis.hour, minutes: dis.minute, seconds: dis.second);
      }
      Future.delayed(delay, () {
        _fetchCurrentMonth();
      });
      // ignore: empty_catches
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
    }
  }

  Future<void> _fetchCurrentMonthSymbolID() async {
    try {
      final response =
          await _restClient.getTxfInfo(TxfRequest.current(_currentMonth));
      final quote = response.rtData.quoteList.length == 1
          ? response.rtData.quoteList.first
          : response.rtData.quoteList[1];
      _currentMonthSymbolID = quote.symbolID;
      // 計算下一次更新近月的時間
      DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8));
      late Duration delay;
      if (isDay) {
        // 日盤等收盤就可以更新
        delay = DateTime(now.year, now.month, now.day, 13, 45).difference(now);
      } else {
        // 夜盤等收盤就可以更新
        late DateTime dis;
        if (now.hour >= 15 && now.hour <= 23) {
          dis = DateTime.fromMillisecondsSinceEpoch(
              DateTime(now.year, now.month, now.day + 1, 5, 0)
                  .millisecondsSinceEpoch -
                  now.millisecondsSinceEpoch);
        } else {
          dis = DateTime.fromMillisecondsSinceEpoch(
              DateTime(now.year, now.month, now.day, 5, 0)
                  .millisecondsSinceEpoch -
                  now.millisecondsSinceEpoch);
        }
        delay =
            Duration(hours: dis.hour, minutes: dis.minute, seconds: dis.second);
      }
      Future.delayed(delay, () {
        _fetchCurrentMonthSymbolID();
      });
      // ignore: empty_catches
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
    }
  }

  bool get isDay {
    // 判斷現在是日盤還是夜盤
    final now = DateTime.now().toUtc().add(const Duration(hours: 8));
    final nowYMD = DateTime(now.year, now.month, now.day);
    DateTime dayStartTime =
    nowYMD.add(const Duration(hours: 5, minutes: 00)); // 8:45
    DateTime dayEndTime =
    nowYMD.add(const Duration(hours: 13, minutes: 45)); // 15:00
    return now.isAfter(dayStartTime) && now.isBefore(dayEndTime);
  }
}

class KeyKState {
  /// 關鍵K棒標題
  final String title;

  /// 關鍵K棒的週期
  final int kPeriod;

  KeyKState({
    required this.title,
    required this.kPeriod,
  });
}

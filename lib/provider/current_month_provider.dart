import 'package:dominant_player/model/txf_info.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:dominant_player/util/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentMonthProvider = StateProvider<String>((ref) {
  return '';
});


final FutureClient _restClient = FutureClient.instance;

/// 取得近月
Future<void> fetchCurrentMonth(StateNotifierProviderRef ref) async {
  try {
    final response =
    await _restClient.getProductMonthsInfo(TxfRequest.current());
    String currentMonth = response.rtData.items
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
    String oldMonth = ref.read(currentMonthProvider);
    if(oldMonth != currentMonth) {
      ref.read(currentMonthProvider.notifier).update((state) => currentMonth);
    }
    // 計算下一次更新近月的時間
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8));
    late Duration delay;
    if (inDayTrade()) {
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
      fetchCurrentMonth(ref);
    });
    // ignore: empty_catches
  } catch (e, stack) {
    debugPrint(e.toString());
    debugPrint(stack.toString());
  }
}

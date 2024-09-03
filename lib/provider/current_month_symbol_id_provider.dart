import 'package:dominant_player/model/txf_info.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_month_provider.dart';

final currentMonthSymbolIdProvider = StateProvider<String>((ref) {
  return '';
});


final RestClient _restClient = RestClient.instance;

Future<void> fetchCurrentMonthSymbolID(StateNotifierProviderRef ref) async {
  String currentMonth = ref.read(currentMonthProvider);
  try {
    final response =
    await _restClient.getTxfInfo(TxfRequest.current(currentMonth));
    final quote = response.rtData.quoteList.length == 1
        ? response.rtData.quoteList.first
        : response.rtData.quoteList[1];
    String currentMonthSymbolID = quote.symbolID;
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

    String oldId = ref.read(currentMonthSymbolIdProvider);
    if(oldId != currentMonthSymbolID) {
      ref.read(currentMonthSymbolIdProvider.notifier).update((state) => currentMonthSymbolID);
    }
    Future.delayed(delay, () {
      fetchCurrentMonthSymbolID(ref);
    });
    // ignore: empty_catches
  } catch (e, stack) {
    debugPrint(e.toString());
    debugPrint(stack.toString());
  }
}
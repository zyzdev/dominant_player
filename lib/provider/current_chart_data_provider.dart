import 'package:dominant_player/model/chart_data.dart';
import 'package:dominant_player/provider/current_month_symbol_id_provider.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentChartProvider = StateProvider<Ticks>((ref) => Ticks());

final RestClient _restClient = RestClient.instance;

/// 取得走勢資料
Future<void> fetchChartDate(StateNotifierProviderRef ref) async {
  try {
    String currentMonthSymbolID = ref.read(currentMonthSymbolIdProvider);
    final response =
        await _restClient.getCurrentChartInfo(currentMonthSymbolID);
    ref.read(currentChartProvider.notifier).update((state) {
      final data = Ticks();
      data.allTicks = response.rtData.ticks;
      return data;
    });
    // ignore: empty_catches
  } catch (e, stack) {
    debugPrint(e.toString());
    debugPrint(stack.toString());
  }
}


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
    int index = allTicks.indexWhere((element) => time(allTicks.last) == time(tick));
    if(index == -1) {
      return Ticks()..allTicks.add(tick);
    }
    allTicks[index] = tick;
    return Ticks()..allTicks.addAll(allTicks);
  }
}
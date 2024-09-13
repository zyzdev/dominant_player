import 'package:dominant_player/model/ticks.dart';
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
      final data = Ticks()..setAllTicks(response.rtData.ticks);
      return data;
    });
    // ignore: empty_catches
  } catch (e, stack) {
    debugPrint(e.toString());
    debugPrint(stack.toString());
  }
}

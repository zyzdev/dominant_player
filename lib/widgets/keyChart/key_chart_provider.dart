import 'package:dominant_player/provider/current_month_symbol_id_provider.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'key_chart_state.dart';

final keyChartProvider =
    StateNotifierProvider.family<KeyChartStateNotifier, KeyChartState, KeyChartState>(
  (ref, keyChartState) {
    return KeyChartStateNotifier(keyChartState, ref);
  },
);

class KeyChartStateNotifier extends StateNotifier<KeyChartState> {
  KeyChartStateNotifier(super.state, StateNotifierProviderRef ref) {
    ref.listen(currentMonthSymbolIdProvider, (previous, currentMonthSymbolID) {
      if(currentMonthSymbolID.isEmpty) return;
      _currentMonthSymbolID = currentMonthSymbolID;
      _fetchChartDate();
    },fireImmediately: true);
  }

  late final RestClient _restClient = RestClient.instance;
  String _currentMonthSymbolID = '';


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

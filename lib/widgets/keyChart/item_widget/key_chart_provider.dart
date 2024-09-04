import 'dart:convert';

import 'package:dominant_player/main_provider.dart';
import 'package:dominant_player/provider/current_month_symbol_id_provider.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:dominant_player/widgets/keyChart/key_chart_main_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'key_chart_state.dart';

const String _statsKey = 'key_char_stats_key';

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
    keyChartMainWidgetNotifier = ref.read(keyChartMainWidgetProvider.notifier);
  }

  late final KeyChartMainWidgetNotifier keyChartMainWidgetNotifier;
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

  void setTitle(String title) {
      state = state.copyWith(title: title);
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

  @override
  set state(KeyChartState state) {
    _updateState(state);
    super.state = state;
  }



  /// 自定義關鍵K棒名稱，是否重複
  bool isKeyChartTitleDuplicate(String title, [KeyChartState? except]) {
    List<KeyChartState> allState = keyChartMainWidgetNotifier.state;
    List<String> allTitle = List.from(allState.map((e) => e.title));
    allTitle.addAll(
        allState.where((element) => element != except).map((e) => e.title).toList());
    return allTitle.indexWhere((element) => element == title) != -1;
  }

  void removeKeyChart(){
    keyChartMainWidgetNotifier.removeKeyChart(state);
  }


  void _updateState(KeyChartState newState) {
    keyChartMainWidgetNotifier.updateKeyChart(state, newState);
  }
}

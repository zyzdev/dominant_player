import 'dart:convert';

import 'package:dominant_player/main_provider.dart';
import 'package:dominant_player/provider/current_chart_data_provider.dart';
import 'package:dominant_player/provider/current_month_symbol_id_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'item_widget/key_chart_state.dart';

const String _statsKey = 'key_char_stats_key';

final keyChartMainWidgetProvider =
    StateNotifierProvider<KeyChartMainWidgetNotifier, List<KeyChartState>>(
        (ref) {
  String? json = prefs.getString(_statsKey);
  late List<KeyChartState> state;
  try {
    if (json != null) {
      state = (jsonDecode(json) as List<dynamic>)
          .map((e) => KeyChartState.fromJson(e))
          .toList();
    } else {
      state = [KeyChartState(title: '關鍵x分K棒')];
    }
  } catch (e, stack) {
    state = [KeyChartState(title: '關鍵x分K棒')];

    debugPrint(e.toString());
    debugPrint(stack.toString());
  }

  return KeyChartMainWidgetNotifier(state, ref);
});

class KeyChartMainWidgetNotifier extends StateNotifier<List<KeyChartState>> {
  KeyChartMainWidgetNotifier(super.state, StateNotifierProviderRef ref) {
    ref.listen(currentMonthSymbolIdProvider, (previous, next) {
      fetchChartDate(ref);
    });
  }

  /// 是否提醒
  void setNotice(bool notice, KeyChartState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(notice: notice);
    this.state = List.of(this.state);
  }

  /// 標題
  void setTitle(String title, KeyChartState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(title: title);
    this.state = List.of(this.state);
  }

  /// K棒週期
  void setPeriod(String period, KeyChartState state) {
    int index = this.state.indexOf(state);
    int? p = double.tryParse(period)?.toInt();
    if (p == null) return;
    if (p <= 0) return;
    this.state[index] = state.copyWith(kPeriod: p);
    this.state = List.of(this.state);
  }

  void addKeyChart() {
    const String defTitle = '關鍵x分K棒';
    String title = defTitle;
    int cnt = 0;

    while (isKeyChartTitleDuplicate(title)) {
      cnt++;
      title = '$defTitle$cnt';
    }
    state.add(KeyChartState(title: title));
    state = List.of(state);
  }

  void updateKeyChart(KeyChartState state, KeyChartState newState) {
    int index = this.state.indexOf(state);
    this.state[index] = newState;
    this.state = this.state.toList();
  }

  void removeKeyChart(KeyChartState state) {
    this.state.remove(state);
    this.state = List.of(this.state);
  }

  /// 自定義關鍵K棒名稱，是否重複
  bool isKeyChartTitleDuplicate(String title, [KeyChartState? except]) {
    List<String> allTitle = state
        .where((element) => element != except)
        .map((e) => e.title)
        .toList();
    return allTitle.indexWhere((element) => element == title) != -1;
  }

  @override
  set state(List<KeyChartState> state) {
    super.state = state;
    prefs.setString(_statsKey, jsonEncode(state));
  }
}

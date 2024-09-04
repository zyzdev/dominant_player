import 'dart:convert';

import 'package:dominant_player/main_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'item_widget/key_chart_provider.dart';
import 'item_widget/key_chart_state.dart';

const String _statsKey = 'key_char_stats_key';

final keyChartMainWidgetProvider = StateNotifierProvider<KeyChartMainWidgetNotifier, List<KeyChartState>>((ref) {
  String? json = prefs.getString(_statsKey);
  late List<KeyChartState> state;
  try {
    if (json != null) {
      state = (jsonDecode(json) as List<dynamic>)
          .map((e) => KeyChartState.fromJson(e))
          .toList();
    } else {
      state = [KeyChartState(title: '自定義x分K棒')];
    }
  } catch (e, stack) {
    state = [];

    debugPrint(e.toString());
    debugPrint(stack.toString());
  }

  return KeyChartMainWidgetNotifier(state, ref);
});

class KeyChartMainWidgetNotifier extends StateNotifier<List<KeyChartState>> {
  KeyChartMainWidgetNotifier(super.state, StateNotifierProviderRef ref);

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

  void updateKeyChart(KeyChartState state, KeyChartState newState){
    int index = this.state.indexWhere((element) {
      return element.title == state.title;
    },);
    this.state[index] = newState;
    this.state = this.state.toList();
  }

  void removeKeyChart(KeyChartState state){
    this.state.remove(state);
    this.state = List.of(this.state);
  }

  /// 自定義關鍵K棒名稱，是否重複
  bool isKeyChartTitleDuplicate(String title, [KeyChartState? except]) {
    List<String> allTitle = List.from(state.map((e) => e.title));
    allTitle.addAll(
        state.where((element) => element != except).map((e) => e.title).toList());
    return allTitle.indexWhere((element) => element == title) != -1;
  }
  @override
  set state(List<KeyChartState> state) {
    super.state = state;
    prefs.setString(_statsKey, jsonEncode(state));
  }
}

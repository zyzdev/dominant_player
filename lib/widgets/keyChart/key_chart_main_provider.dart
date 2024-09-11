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

  /// 是否考慮成交量
  void setVolume(bool notice, KeyChartState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(considerVolume: notice);
    this.state = List.of(this.state);
  }

  /// 成交量的數值
  void setVolumeValue(int? volume, KeyChartState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(keyVolume: volume);
    this.state = List.of(this.state);
  }

  /// 是否考慮收長上影
  void setCloseWithLongUpperShadow(bool notice, KeyChartState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(closeWithLongUpperShadow: notice);
    this.state = List.of(this.state);
  }

  /// 是否考慮收長下影
  void setCloseWithLongLowerShadow(bool notice, KeyChartState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(closeWithLongLowerShadow: notice);
    this.state = List.of(this.state);
  }

  /// 是否考慮山峰轉折
  void setPeak(bool notice, KeyChartState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(peak: notice);
    this.state = List.of(this.state);
  }

  /// 山峰轉折考慮的K棒數量
  /// 如果[period] = 5, 這代表會考慮前五跟K棒的收盤價，且前一根收盤價必須為最高
  /// 當前K棒的收盤價比前跟低，代表轉折點發生
  void setPeakInPeriod(int? period, KeyChartState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(peakInPeriod: period);
    this.state = List.of(this.state);
  }

  /// 是否考慮山谷轉折
  void setValley(bool notice, KeyChartState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(valley: notice);
    this.state = List.of(this.state);
  }

  /// 山峰轉折考慮的K棒數量
  /// 如果[period] = 5, 這代表會考慮前五跟K棒的收盤價，且前一根收盤價必須為最高
  /// 當前K棒的收盤價比前跟低，代表轉折點發生
  void setValleyInPeriod(int? period, KeyChartState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(valleyInPeriod: period);
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

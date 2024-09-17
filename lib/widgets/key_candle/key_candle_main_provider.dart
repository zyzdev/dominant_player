import 'dart:convert';

import 'package:dominant_player/main_provider.dart';
import 'package:dominant_player/provider/current_chart_data_provider.dart';
import 'package:dominant_player/provider/current_month_symbol_id_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/key_candle_state.dart';

const String _statsKey = 'key_char_stats_key';

final keyCandleMainWidgetProvider =
    StateNotifierProvider<KeyCandleMainWidgetNotifier, List<KeyCandleState>>(
        (ref) {
  String? json = prefs.getString(_statsKey);
  late List<KeyCandleState> state;
  try {
    if (json != null) {
      state = (jsonDecode(json) as List<dynamic>)
          .map((e) => KeyCandleState.fromJson(e))
          .toList();
    } else {
      state = [KeyCandleState(title: '關鍵x分K棒')];
    }
  } catch (e, stack) {
    state = [KeyCandleState(title: '關鍵x分K棒')];

    debugPrint(e.toString());
    debugPrint(stack.toString());
  }

  return KeyCandleMainWidgetNotifier(state, ref);
});

class KeyCandleMainWidgetNotifier extends StateNotifier<List<KeyCandleState>> {
  KeyCandleMainWidgetNotifier(super.state, StateNotifierProviderRef ref) {
    ref.listen(currentMonthSymbolIdProvider, (previous, next) {
      fetchChartDate(ref);
    });
  }

  /// 是否提醒
  void setNotice(bool notice, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(notice: notice);
    this.state = List.of(this.state);
  }

  /// 標題
  void setTitle(String title, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(title: title);
    this.state = List.of(this.state);
  }

  /// K棒週期
  void setPeriod(String period, KeyCandleState state) {
    int index = this.state.indexOf(state);
    int? p = double.tryParse(period)?.toInt();
    if (p == null) return;
    if (p <= 0) return;
    this.state[index] = state.copyWith(kPeriod: p);
    this.state = List.of(this.state);
  }

  /// 是否考慮成交量
  void setVolume(bool notice, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(considerVolume: notice);
    this.state = List.of(this.state);
  }

  /// 成交量的數值
  void setVolumeValue(int? volume, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(keyVolume: volume);
    this.state = List.of(this.state);
  }

  /// 成交量是否為必要條件
  void setVolumeRequired(bool required, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(volumeRequired: required);
    this.state = List.of(this.state);
  }

  /// 是否考慮收長上影
  void setCloseWithLongUpperShadow(bool notice, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(closeWithLongUpperShadow: notice);
    this.state = List.of(this.state);
  }

  /// 收長下影是否為必要條件
  void setCloseWithLongUpperShadowRequired(bool required, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(closeWithLongUpperShadowRequired: required);
    this.state = List.of(this.state);
  }

  /// 是否考慮收長下影
  void setCloseWithLongLowerShadow(bool notice, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(closeWithLongLowerShadow: notice);
    this.state = List.of(this.state);
  }

  /// 收長下影是否為必要條件
  void setCloseWithLongLowerShadowRequired(bool required, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(closeWithLongLowerShadowRequired: required);
    this.state = List.of(this.state);
  }

  /// 是否考慮A轉
  void setATurn(bool notice, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(aTurn: notice);
    this.state = List.of(this.state);
  }

  /// A轉考慮的K棒數量
  /// 如果[period] = 5, 這代表會考慮前五跟K棒的收盤價，且前一根收盤價必須為最高
  /// 當前K棒的收盤價比前跟低，代表轉折點發生
  void setATurnInPeriod(int? period, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(aTurnInPeriod: period);
    this.state = List.of(this.state);
  }

  /// A轉是否為必要條件
  void setATurnRequired(bool required, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(aTurnRequired: required);
    this.state = List.of(this.state);
  }

  /// 是否考慮V轉
  void setVTurn(bool notice, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(vTurn: notice);
    this.state = List.of(this.state);
  }

  /// V轉考慮的K棒數量
  /// 如果[period] = 5, 這代表會考慮前五跟K棒的收盤價，且前一根收盤價必須為最高
  /// 當前K棒的收盤價比前跟低，代表轉折點發生
  void setVTurnInPeriod(int? period, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(vTurnInPeriod: period);
    this.state = List.of(this.state);
  }

  /// A轉是否為必要條件
  void setVTurnRequired(bool required, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(vTurnRequired: required);
    this.state = List.of(this.state);
  }

  /// 是否考慮多方攻擊
  void setLongAttack(bool notice, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(longAttack: notice);
    this.state = List.of(this.state);
  }

  /// 多方攻擊的點數，預設20
  void setLongAttackPoint(int? period, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(longAttackPoint: period);
    this.state = List.of(this.state);
  }

  /// 多方攻擊是否為必要條件
  void setLongAttackRequired(bool required, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(longAttackRequired: required);
    this.state = List.of(this.state);
  }

  /// 是否考慮空方攻擊
  void setShortAttack(bool notice, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(shortAttack: notice);
    this.state = List.of(this.state);
  }

  /// 空方攻擊的點數，預設20
  void setShortAttackPoint(int? period, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(shortAttackPoint: period);
    this.state = List.of(this.state);
  }

  /// 空方攻擊是否為必要條件
  void setShortAttackRequired(bool required, KeyCandleState state) {
    int index = this.state.indexOf(state);
    this.state[index] = state.copyWith(shortAttackRequired: required);
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
    state.add(KeyCandleState(title: title));
    state = List.of(state);
  }

  void updateKeyChart(KeyCandleState state, KeyCandleState newState) {
    int index = this.state.indexOf(state);
    this.state[index] = newState;
    this.state = this.state.toList();
  }

  void removeKeyChart(KeyCandleState state) {
    this.state.remove(state);
    this.state = List.of(this.state);
  }

  /// 自定義關鍵K棒名稱，是否重複
  bool isKeyChartTitleDuplicate(String title, [KeyCandleState? except]) {
    List<String> allTitle = state
        .where((element) => element != except)
        .map((e) => e.title)
        .toList();
    return allTitle.indexWhere((element) => element == title) != -1;
  }

  @override
  set state(List<KeyCandleState> state) {
    super.state = state;
    prefs.setString(_statsKey, jsonEncode(state));
  }
}

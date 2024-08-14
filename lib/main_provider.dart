import 'dart:convert';
import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/spy_state.dart';

final mainProvider =
    StateNotifierProvider<MainNotifier, SpyState>((ref) => MainNotifier());

class MainNotifier extends StateNotifier<SpyState> {

  MainNotifier() : super(SpyState.init()) {
    SharedPreferences.getInstance().then((value) {
      _prefs = value;
      String? json = _prefs.getString(_statsKey);
      if(json != null) {
        state = SpyState.fromJson(jsonDecode(json));
      }
    });
  }

  static const String _statsKey = 'stats_key';
  late final SharedPreferences _prefs;

  /// 設定前盤高點
  set high(String value) {
    state = state.copyWith(high: int.parse(value));
  }
  /// 設定前盤低點
  set low(String value) {
    state = state.copyWith(low: int.parse(value));
  }

  /// 設定15分最大多方邏輯高點
  void daySensitivitySpaceLongHigh15(String value) {
    state = state.copyWith(daySensitivitySpace15: state.daySensitivitySpace15.copyWith(maxLongHigh: int.parse(value)));
  }
  /// 設定15分最大多方邏輯低點
  void daySensitivitySpaceLongLow15(String value) {
    state = state.copyWith(daySensitivitySpace15: state.daySensitivitySpace15.copyWith(maxLongLow: int.parse(value)));
  }

  /// 設定30分最大多方邏輯高點
  set daySensitivitySpaceLongHigh30(String value) {
    state = state.copyWith(daySensitivitySpace30: state.daySensitivitySpace30.copyWith(maxLongHigh: int.parse(value)));
  }
  /// 設定30分最大多方邏輯低點
  set daySensitivitySpaceLongLow30(String value) {
    state = state.copyWith(daySensitivitySpace30: state.daySensitivitySpace30.copyWith(maxLongLow: int.parse(value)));
  }

  /// 設定15分最大空方邏輯高點
  set daySensitivitySpaceShortHigh15(String value) {
    state = state.copyWith(daySensitivitySpace15: state.daySensitivitySpace15.copyWith(maxShortHigh: int.parse(value)));
  }
  /// 設定15分最大空方邏輯低點
  set daySensitivitySpaceShortLow15(String value) {
    state = state.copyWith(daySensitivitySpace15: state.daySensitivitySpace15.copyWith(maxShortLow: int.parse(value)));
  }

  /// 設定30分最大空方邏輯高點
  set daySensitivitySpaceShortHigh30(String value) {
    state = state.copyWith(daySensitivitySpace30: state.daySensitivitySpace30.copyWith(maxShortHigh: int.parse(value)));
  }
  /// 設定30分最大空方邏輯低點
  set daySensitivitySpaceShortLow30(String value) {
    state = state.copyWith(daySensitivitySpace30: state.daySensitivitySpace30.copyWith(maxShortLow: int.parse(value)));
  }

  @override
  set state(SpyState state) {
    super.state = state;
    _prefs.setString(_statsKey, jsonEncode(state.toJson()));
  }
}

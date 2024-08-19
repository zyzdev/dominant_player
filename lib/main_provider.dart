import 'dart:convert';
import 'dart:core';

import 'package:dominant_player/model/key_value.dart';
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
      if (json != null) {
        state = SpyState.fromJson(jsonDecode(json));
      }
    });
  }

  static const String _statsKey = 'stats_key';
  late final SharedPreferences _prefs;

  /// 設定現價
  set current(String value) {
    state = state.copyWith(current: int.tryParse(value));
  }

  /// 設定前盤高點
  set high(String value) {
    state = state.copyWith(high: int.tryParse(value));
  }

  /// 設定前盤低點
  set low(String value) {
    state = state.copyWith(low: int.tryParse(value));
  }

  /// 設定日盤15分最大多方邏輯高點
  void daySensitivitySpaceLongHigh15(String value) {
    state = state.copyWith(
        daySensitivitySpace15: state.daySensitivitySpace15
            .copyWith(longHigh: int.tryParse(value)));
  }

  /// 設定日盤15分最大多方邏輯低點
  void daySensitivitySpaceLongLow15(String value) {
    state = state.copyWith(
        daySensitivitySpace15:
            state.daySensitivitySpace15.copyWith(longLow: int.tryParse(value)));
  }

  /// 設定日盤30分最大多方邏輯高點
  void daySensitivitySpaceLongHigh30(String value) {
    state = state.copyWith(
        daySensitivitySpace30: state.daySensitivitySpace30
            .copyWith(longHigh: int.tryParse(value)));
  }

  /// 設定30分最大多方邏輯低點
  void daySensitivitySpaceLongLow30(String value) {
    state = state.copyWith(
        daySensitivitySpace30:
            state.daySensitivitySpace30.copyWith(longLow: int.tryParse(value)));
  }

  /// 設定日盤15分最大空方邏輯高點
  void daySensitivitySpaceShortHigh15(String value) {
    state = state.copyWith(
        daySensitivitySpace15: state.daySensitivitySpace15
            .copyWith(shortHigh: int.tryParse(value)));
  }

  /// 設定日盤15分最大空方邏輯低點
  void daySensitivitySpaceShortLow15(String value) {
    state = state.copyWith(
        daySensitivitySpace15: state.daySensitivitySpace15
            .copyWith(shortLow: int.tryParse(value)));
  }

  /// 設定日盤30分最大空方邏輯高點
  void daySensitivitySpaceShortHigh30(String value) {
    state = state.copyWith(
        daySensitivitySpace30: state.daySensitivitySpace30
            .copyWith(shortHigh: int.tryParse(value)));
  }

  /// 設定日盤30分最大空方邏輯低點
  void daySensitivitySpaceShortLow30(String value) {
    state = state.copyWith(
        daySensitivitySpace30: state.daySensitivitySpace30
            .copyWith(shortLow: int.tryParse(value)));
  }

  /// 設定夜盤15分最大多方邏輯高點
  void nightSensitivitySpaceLongHigh15(String value) {
    state = state.copyWith(
        nightSensitivitySpace15: state.nightSensitivitySpace15
            .copyWith(longHigh: int.tryParse(value)));
  }

  /// 設定夜盤15分最大多方邏輯低點
  void nightSensitivitySpaceLongLow15(String value) {
    state = state.copyWith(
        nightSensitivitySpace15: state.nightSensitivitySpace15
            .copyWith(longLow: int.tryParse(value)));
  }

  /// 設定夜盤30分最大多方邏輯高點
  void nightSensitivitySpaceLongHigh30(String value) {
    state = state.copyWith(
        nightSensitivitySpace30: state.nightSensitivitySpace30
            .copyWith(longHigh: int.tryParse(value)));
  }

  /// 設定30分最大多方邏輯低點
  void nightSensitivitySpaceLongLow30(String value) {
    state = state.copyWith(
        nightSensitivitySpace30: state.nightSensitivitySpace30
            .copyWith(longLow: int.tryParse(value)));
  }

  /// 設定夜盤15分最大空方邏輯高點
  void nightSensitivitySpaceShortHigh15(String value) {
    state = state.copyWith(
        nightSensitivitySpace15: state.nightSensitivitySpace15
            .copyWith(shortHigh: int.tryParse(value)));
  }

  /// 設定夜盤15分最大空方邏輯低點
  void nightSensitivitySpaceShortLow15(String value) {
    state = state.copyWith(
        nightSensitivitySpace15: state.nightSensitivitySpace15
            .copyWith(shortLow: int.tryParse(value)));
  }

  /// 設定夜盤30分最大空方邏輯高點
  void nightSensitivitySpaceShortHigh30(String value) {
    state = state.copyWith(
        nightSensitivitySpace30: state.nightSensitivitySpace30
            .copyWith(shortHigh: int.tryParse(value)));
  }

  /// 設定日盤30分最大空方邏輯低點
  void nightSensitivitySpaceShortLow30(String value) {
    state = state.copyWith(
        nightSensitivitySpace30: state.nightSensitivitySpace30
            .copyWith(shortLow: int.tryParse(value)));
  }

  void considerKeyValue(KeyValue keyValue, bool consider) {
    final considerKeyValue = state.considerKeyValue;
    considerKeyValue[keyValue] = consider;
    state = state.copyWith(considerKeyValue: considerKeyValue);
  }

  List<MapEntry<KeyValue, num?>> get spyValues {
    List<MapEntry<KeyValue, num?>> keyValues = [
      MapEntry(KeyValue.current, state.current),
      MapEntry(KeyValue.high, state.high),
      MapEntry(KeyValue.low, state.low),
      MapEntry(KeyValue.range, state.range),
      MapEntry(KeyValue.rangeDiv4, state.rangeDiv4),
      MapEntry(KeyValue.highCost, state.highCost),
      MapEntry(KeyValue.middleCost, state.middleCost),
      MapEntry(KeyValue.lowCost, state.lowCost),
      MapEntry(KeyValue.superPress, state.superPress),
      MapEntry(KeyValue.absolutePress, state.absolutePress),
      MapEntry(KeyValue.nestPress, state.nestPress),
      MapEntry(KeyValue.nestSupport, state.nestSupport),
      MapEntry(KeyValue.absoluteSupport, state.absoluteSupport),
      MapEntry(KeyValue.superSupport, state.superSupport),
    ];
    return keyValues;
  }

  List<MapEntry<KeyValue, num>> get keyValues {
    List<MapEntry<KeyValue, num>> keyValues = [
      MapEntry(KeyValue.current, state.current),
      MapEntry(KeyValue.high, state.high),
      MapEntry(KeyValue.low, state.low),
      MapEntry(KeyValue.highCost, state.highCost),
      MapEntry(KeyValue.middleCost, state.middleCost),
      MapEntry(KeyValue.lowCost, state.lowCost),
      MapEntry(KeyValue.superPress, state.superPress),
      MapEntry(KeyValue.absolutePress, state.absolutePress),
      MapEntry(KeyValue.nestPress, state.nestPress),
      MapEntry(KeyValue.nestSupport, state.nestSupport),
      MapEntry(KeyValue.absoluteSupport, state.absoluteSupport),
      MapEntry(KeyValue.superSupport, state.superSupport),
      MapEntry(
          KeyValue.dayLongAttack15, state.daySensitivitySpace15.longAttack),
      MapEntry(
          KeyValue.dayLongMiddle15, state.daySensitivitySpace15.longMiddle),
      MapEntry(
          KeyValue.dayLongDefense15, state.daySensitivitySpace15.longDefense),
      MapEntry(
          KeyValue.dayLongAttack30, state.daySensitivitySpace30.longAttack),
      MapEntry(
          KeyValue.dayLongMiddle30, state.daySensitivitySpace30.longMiddle),
      MapEntry(
          KeyValue.dayLongDefense30, state.daySensitivitySpace30.longDefense),
      MapEntry(
          KeyValue.dayShortAttack15, state.daySensitivitySpace15.shortAttack),
      MapEntry(
          KeyValue.dayShortMiddle15, state.daySensitivitySpace15.shortMiddle),
      MapEntry(
          KeyValue.dayShortDefense15, state.daySensitivitySpace15.shortDefense),
      MapEntry(
          KeyValue.dayShortAttack30, state.daySensitivitySpace30.shortAttack),
      MapEntry(
          KeyValue.dayShortMiddle30, state.daySensitivitySpace30.shortMiddle),
      MapEntry(
          KeyValue.dayShortDefense30, state.daySensitivitySpace30.shortDefense),
      MapEntry(
          KeyValue.nightLongAttack15, state.nightSensitivitySpace15.longAttack),
      MapEntry(
          KeyValue.nightLongMiddle15, state.nightSensitivitySpace15.longMiddle),
      MapEntry(KeyValue.nightLongDefense15,
          state.nightSensitivitySpace15.longDefense),
      MapEntry(
          KeyValue.nightLongAttack30, state.nightSensitivitySpace30.longAttack),
      MapEntry(
          KeyValue.nightLongMiddle30, state.nightSensitivitySpace30.longMiddle),
      MapEntry(KeyValue.nightLongDefense30,
          state.nightSensitivitySpace30.longDefense),
      MapEntry(KeyValue.nightShortAttack15,
          state.nightSensitivitySpace15.shortAttack),
      MapEntry(KeyValue.nightShortMiddle15,
          state.nightSensitivitySpace15.shortMiddle),
      MapEntry(KeyValue.nightShortDefense15,
          state.nightSensitivitySpace15.shortDefense),
      MapEntry(KeyValue.nightShortAttack30,
          state.nightSensitivitySpace30.shortAttack),
      MapEntry(KeyValue.nightShortMiddle30,
          state.nightSensitivitySpace30.shortMiddle),
      MapEntry(KeyValue.nightShortDefense30,
          state.nightSensitivitySpace30.shortDefense),
    ]
        .
        // 找出數值不為空值的
        where((element) => element.value != null)
        // 找出有考慮的
        .where((element) => state.considerKeyValue[element.key] ?? false)
        .map((e) => MapEntry(e.key, e.value!))
        .toList();

    // 用數值大小排序
    keyValues.sort(
      (a, b) {
        return a.value > b.value
            ? -1
            : a.value < b.value
                ? 1
                : 0;
      },
    );
    return keyValues;
  }

  @override
  set state(SpyState state) {
    super.state = state;
    _prefs.setString(_statsKey, jsonEncode(state.toJson()));
  }
}
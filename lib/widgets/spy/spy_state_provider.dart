import 'dart:convert';

import 'package:dominant_player/main_provider.dart';
import 'package:dominant_player/model/key_value.dart';
import 'package:dominant_player/model/spy_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dominant_player/service/spy_info.dart';

const String _statsKey = 'spy_stats_key';

final spyStateNotifierProvider =
    StateNotifierProvider<SpyMainNotifier, SpyState>((ref) {

      String? json = prefs.getString(_statsKey);
      late SpyState state;
      try {
        if (json != null) {
          state = SpyState.fromJson(jsonDecode(json));
        } else {
          state = SpyState.init();
        }
      } catch (e, stack) {
        state = SpyState.init();

        debugPrint(e.toString());
        debugPrint(stack.toString());
      }

  return SpyMainNotifier(
    state,
    ref,
  );
});

class SpyMainNotifier extends StateNotifier<SpyState> {

  SpyMainNotifier(super.state, StateNotifierProviderRef ref) {
    _fetchSpyPrice();
  }

  final TextEditingController daySpyHighController = TextEditingController();
  final TextEditingController daySpyLowController = TextEditingController();
  final TextEditingController nightSpyHighController = TextEditingController();
  final TextEditingController nightSpyLowController = TextEditingController();

  /// 設定Spy高點
  void setSpyHigh(Spy spy, String value) {
    if (spy.isDay) {
      state = state.copyWith(daySpy: spy.copyWith(high: int.tryParse(value)));
    } else {
      state = state.copyWith(nightSpy: spy.copyWith(high: int.tryParse(value)));
    }
  }

  /// 設定Spy低點
  void setSpyLow(Spy spy, String value) {
    if (spy.isDay) {
      state = state.copyWith(daySpy: spy.copyWith(low: int.tryParse(value)));
    } else {
      state = state.copyWith(nightSpy: spy.copyWith(low: int.tryParse(value)));
    }
  }

  /// 取得SPY價格
  Future<void> _fetchSpyPrice() async {
    // 判斷是否需要夜盤資訊
    // 日盤和週末需要日盤和夜盤資訊
    await Future.wait([
      fetchSpyPrice(),
      fetchSpyPrice(false),
    ]).then((value) {
      String dayHigh = value[0][0];
      String dayLow = value[0][1];
      // 日盤SPY
      state = state.copyWith(
          daySpy: state.daySpy.copyWith(
              high: int.tryParse(dayHigh), low: int.tryParse(dayLow)));
      daySpyHighController.text = dayHigh;
      daySpyLowController.text = dayLow;
      // 夜盤SPY
      String nightHigh = value[1][0];
      String nightLow = value[1][1];
      state = state.copyWith(
          nightSpy: state.nightSpy.copyWith(
              high: int.tryParse(nightHigh), low: int.tryParse(nightLow)));
      nightSpyHighController.text = nightHigh;
      nightSpyLowController.text = nightLow;
    });
    // 計算下一次更新SPY的時間
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8));
    late Duration delay;
    if (isDay) {
      // 日盤等收盤就可以更新
      delay = DateTime(now.year, now.month, now.day, 13, 45).difference(now);
    } else {
      // 夜盤等收盤就可以更新
      late DateTime dis;
      if (now.hour >= 15 && now.hour <= 23) {
        dis = DateTime.fromMillisecondsSinceEpoch(
            DateTime(now.year, now.month, now.day + 1, 5, 0)
                    .millisecondsSinceEpoch -
                now.millisecondsSinceEpoch);
      } else {
        dis = DateTime.fromMillisecondsSinceEpoch(
            DateTime(now.year, now.month, now.day, 5, 0)
                    .millisecondsSinceEpoch -
                now.millisecondsSinceEpoch);
      }
      delay =
          Duration(hours: dis.hour, minutes: dis.minute, seconds: dis.second);
    }
    Future.delayed(delay, () {
      _fetchSpyPrice();
    });
  }

  /// 是否考慮此關鍵價位
  void considerKeyValue(String valueTitle, bool consider) {
    final considerKeyValue = state.considerKeyValue;
    considerKeyValue[valueTitle] = consider;
    state = state.copyWith(considerKeyValue: considerKeyValue);
  }

  List<MapEntry<KeyValue, num?>> spyValues(Spy spy) {
    List<MapEntry<KeyValue, num?>> keyValues = [
      MapEntry(KeyValue.high, spy.high),
      MapEntry(KeyValue.low, spy.low),
      MapEntry(KeyValue.range, spy.range),
      MapEntry(KeyValue.rangeDiv4, spy.rangeDiv4),
      MapEntry(KeyValue.highCost, spy.highCost),
      MapEntry(KeyValue.middleCost, spy.middleCost),
      MapEntry(KeyValue.lowCost, spy.lowCost),
      MapEntry(KeyValue.superPress, spy.superPress),
      MapEntry(KeyValue.absolutePress, spy.absolutePress),
      MapEntry(KeyValue.nestPress, spy.nestPress),
      MapEntry(KeyValue.nestSupport, spy.nestSupport),
      MapEntry(KeyValue.absoluteSupport, spy.absoluteSupport),
      MapEntry(KeyValue.superSupport, spy.superSupport),
    ];
    return keyValues;
  }

  bool get isWeekend {
    final now = DateTime.now().toUtc().add(const Duration(hours: 8));
    return now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
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
  set state(SpyState state) {
    super.state = state;
    prefs.setString(_statsKey, jsonEncode(state.toJson()));
  }
}

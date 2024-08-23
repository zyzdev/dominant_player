import 'dart:async';
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



  num? _current;
  Timer? _currentDebouncing;
  /// 設定現價
  set current(String value) {
    _current = int.tryParse(value);
    _currentDebouncing?.cancel();
    _currentDebouncing = Timer(const Duration(milliseconds: 300), () {
      state = state.copyWith(current: int.tryParse(value));
    });
  }

  /// 設定前盤高點
  set high(String value) {
    state = state.copyWith(high: int.tryParse(value));
  }

  /// 設定前盤低點
  set low(String value) {
    state = state.copyWith(low: int.tryParse(value));
  }

  /// 日盤靈敏度空間，是否展開
  void daySensitivitySpaceExpend(bool expend) {
    state = state.copyWith(daySensitivitySpaceExpend: expend);
  }

  /// 設定日盤15分最大多方邏輯高點
  void daySensitivitySpaceLongHigh15(String value) {
    print(value);
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

  /// 夜盤靈敏度空間，是否展開
  void nightSensitivitySpaceExpend(bool expend) {
    state = state.copyWith(nightSensitivitySpaceExpend: expend);
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

  /// 是否考慮此關鍵價位
  void considerKeyValue(String valueTitle, bool consider) {
    final considerKeyValue = state.considerKeyValue;
    considerKeyValue[valueTitle] = consider;
    state = state.copyWith(considerKeyValue: considerKeyValue);
  }

  /// 自定義靈敏度空間，是否展開
  void customizeSensitivitySpaceExpend(bool expend) {
    state = state.copyWith(customizeSensitivitySpaceExpend: expend);
  }

  void setCustomizeSensitivitySpaceHigh(
      CustomizeSensitivitySpace customizeSensitivitySpace, String value) {
    final data = state.customizeSensitivitySpaces;
    int index = data.indexOf(customizeSensitivitySpace);
    data[index] = customizeSensitivitySpace.copyWith(high: int.tryParse(value));
    state = state.copyWith(customizeSensitivitySpaces: data);
  }

  void setCustomizeSensitivitySpaceLow(
      CustomizeSensitivitySpace customizeSensitivitySpace, String value) {
    final data = state.customizeSensitivitySpaces;
    int index = data.indexOf(customizeSensitivitySpace);
    data[index] = customizeSensitivitySpace.copyWith(low: int.tryParse(value));

    state = state.copyWith(customizeSensitivitySpaces: data);
  }

  void setCustomizeSensitivitySpaceTitle(
      CustomizeSensitivitySpace customizeSensitivitySpace, String title) {
    final data = state.customizeSensitivitySpaces;
    int index = data.indexOf(customizeSensitivitySpace);
    data[index] = customizeSensitivitySpace.copyWith(title: title);

    state = state.copyWith(customizeSensitivitySpaces: data);
  }

  void setCustomizeSensitivitySpaceDirection(
      CustomizeSensitivitySpace customizeSensitivitySpace,
      Direction direction) {
    final data = state.customizeSensitivitySpaces;
    int index = data.indexOf(customizeSensitivitySpace);
    data[index] = customizeSensitivitySpace.copyWith(direction: direction);

    state = state.copyWith(customizeSensitivitySpaces: data);
  }

  bool isCustomizeSensitivitySpaceTitleDuplicate(String title,
      [CustomizeSensitivitySpace? except]) {
    List<String> allTitle = List.from(KeyValue.values.map((e) => e.title));
    allTitle.addAll(state.customizeSensitivitySpaces
        .where((element) => element != except)
        .map((e) => e.title)
        .toList());
    return allTitle.indexWhere((element) => element == title) != -1;
  }

  void addCustomizeSensitivitySpace() {
    const String defTitle = '自定義靈敏度空間';
    String title = defTitle;
    int cnt = 0;

    while (isCustomizeSensitivitySpaceTitleDuplicate(title)) {
      cnt++;
      title = '$defTitle$cnt';
    }
    final data = state.customizeSensitivitySpaces;
    data.add(CustomizeSensitivitySpace(
        title: title, direction: Direction.customizeLong));
    state = state.copyWith(customizeSensitivitySpaces: data);
  }

  void removeCustomizeSensitivitySpace(
      CustomizeSensitivitySpace customizeSensitivitySpace) {
    final data = state.customizeSensitivitySpaces;
    data.remove(customizeSensitivitySpace);
    state = state.copyWith(customizeSensitivitySpaces: data);
  }

  List<MapEntry<KeyValue, num?>> get spyValues {
    List<MapEntry<KeyValue, num?>> keyValues = [
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

  List<MapEntry<String, num>> get keyValues {
    List<MapEntry<String, num>> keyValues = [
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
        .where((element) => state.considerKeyValue[element.key.title] ?? false)
        .map((e) => MapEntry(e.key.title, e.value!))
        .toList();
    // 加入自定義靈敏度空間
    keyValues.addAll(state.customizeSensitivitySpaces
        .expand((element) => [
              if (element.attack != null)
                MapEntry(element.attackKeyTitle, element.attack!),
              if (element.middle != null)
                MapEntry(element.middleKeyTitle, element.middle!),
              if (element.defense != null)
                MapEntry(element.defenseKeyTitle, element.defense!),
            ]) // 找出有考慮的
        .where((element) => state.considerKeyValue[element.key] ?? false));
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
    // 如果現價為空，加到第一個
    if(keyValues.indexWhere((element) => element.key == KeyValue.current.title) == -1){
      keyValues.insert(0, MapEntry(KeyValue.current.title, -1));
    }
    return keyValues;
  }

  bool isSensitivitySpaceTitleDuplicate(String title) {
    bool duplicate = false;
    for (MapEntry<String, num> element in keyValues) {
      if (title.trim() == element.key) {
        duplicate = true;
        break;
      }
    }
    return duplicate;
  }

  @override
  set state(SpyState state) {
    super.state = state;
    _prefs.setString(_statsKey, jsonEncode(state.toJson()));
  }
}

import 'dart:convert';

import 'package:dominant_player/main_provider.dart';
import 'package:dominant_player/model/key_value.dart';
import 'package:dominant_player/model/sensitivity_space_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _statsKey = 'sensitivity_space_stats_key';

final sensitivitySpaceStateNotifierProvider =
    StateNotifierProvider<SensitivitySpaceMainNotifier, SensitivitySpaceState>((ref) {

      String? json = prefs.getString(_statsKey);
      late SensitivitySpaceState state;
      try {
        if (json != null) {
          state = SensitivitySpaceState.fromJson(jsonDecode(json));
        } else {
          state = SensitivitySpaceState.init();
        }
      } catch (e, stack) {
        state = SensitivitySpaceState.init();

        debugPrint(e.toString());
        debugPrint(stack.toString());
      }

  return SensitivitySpaceMainNotifier(
    state,
    ref,
  );
});

class SensitivitySpaceMainNotifier extends StateNotifier<SensitivitySpaceState> {

  SensitivitySpaceMainNotifier(super.state, StateNotifierProviderRef ref) {

  }


  void exchangeSensitivitySpaceWidgetIndex(int oldIndex, int newIndex) {
    final SensitivitySpaceType item =
    state.sensitivitySpaceWidgetIndex.removeAt(oldIndex);
    state.sensitivitySpaceWidgetIndex.insert(newIndex, item);
    state = state.copyWith(
        sensitivitySpaceWidgetIndex: state.sensitivitySpaceWidgetIndex);
  }

  /// 日盤靈敏度空間，是否展開
  void daySensitivitySpaceExpand(bool expand) {
    state = state.copyWith(daySensitivitySpaceExpand: expand);
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

  /// 夜盤靈敏度空間，是否展開
  void nightSensitivitySpaceExpand(bool expand) {
    state = state.copyWith(nightSensitivitySpaceExpand: expand);
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
  void customizeSensitivitySpaceExpand(bool expand) {
    state = state.copyWith(customizeSensitivitySpaceExpand: expand);
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

  void addCustomizeSensitivitySpace(
      [Direction direction = Direction.customizeLong]) {
    String defTitle = direction.typeName;
    String title = defTitle;
    int cnt = 0;

    while (isCustomizeSensitivitySpaceTitleDuplicate(title)) {
      cnt++;
      title = '$defTitle$cnt';
    }
    final data = state.customizeSensitivitySpaces;
    data.add(CustomizeSensitivitySpace(title: title, direction: direction));
    state = state.copyWith(customizeSensitivitySpaces: data);
  }

  void removeCustomizeSensitivitySpace(
      CustomizeSensitivitySpace customizeSensitivitySpace) {
    final data = state.customizeSensitivitySpaces;
    data.remove(customizeSensitivitySpace);
    state = state.copyWith(customizeSensitivitySpaces: data);
  }

  /// 自定義靈敏度空間名稱，是否重複
  bool isCustomizeSensitivitySpaceTitleDuplicate(String title,
      [CustomizeSensitivitySpace? except]) {
    List<String> allTitle = List.from(KeyValue.values.map((e) => e.title));
    allTitle.addAll(state.customizeSensitivitySpaces
        .where((element) => element != except)
        .map((e) => e.title)
        .toList());
    return allTitle.indexWhere((element) => element == title) != -1;
  }

  /// 自定義關鍵價，是否展開
  void customizeValueExpand(bool expand) {
    state = state.copyWith(customizeValuesExpand: expand);
  }

  void setCustomizeValueTitle(CustomizeValue customizeValue, String title) {
    final data = state.customizeValues;
    int index = data.indexOf(customizeValue);
    data[index] = customizeValue.copyWith(title: title);

    state = state.copyWith(customizeValues: data);
  }

  void setCustomizeValueValue(CustomizeValue customizeValue, String value) {
    final data = state.customizeValues;
    int index = data.indexOf(customizeValue);
    data[index] = customizeValue.copyWith(value: int.tryParse(value));

    state = state.copyWith(customizeValues: data);
  }

  void addCustomizeValue() {
    const String defTitle = '自定義關鍵價';
    String title = defTitle;
    int cnt = 0;

    while (isCustomizeValueTitleDuplicate(title)) {
      cnt++;
      title = '$defTitle$cnt';
    }
    final data = state.customizeValues;
    data.add(CustomizeValue(title: title));
    state = state.copyWith(customizeValues: data);
  }

  void removeCustomizeValue(CustomizeValue customizeValue) {
    final data = state.customizeValues;
    data.remove(customizeValue);
    state = state.copyWith(customizeValues: data);
  }

  /// 自定義靈關鍵價名稱，是否重複
  bool isCustomizeValueTitleDuplicate(String title, [CustomizeValue? except]) {
    List<String> allTitle = List.from(KeyValue.values.map((e) => e.title));
    allTitle.addAll(state.customizeValues
        .where((element) => element != except)
        .map((e) => e.title)
        .toList());
    return allTitle.indexWhere((element) => element == title) != -1;
  }

  @override
  set state(SensitivitySpaceState state) {
    super.state = state;
    prefs.setString(_statsKey, jsonEncode(state.toJson()));
  }
}

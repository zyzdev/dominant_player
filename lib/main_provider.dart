import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dominant_player/model/key_value.dart';
import 'package:dominant_player/model/txf_info.dart';
import 'package:dominant_player/service/holiday_info.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:dominant_player/service/spy_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/spy_state.dart';

SharedPreferences? _prefs;

SharedPreferences get prefs => _prefs!;

Future<void> init() async {
  _prefs ??= await SharedPreferences.getInstance();
  HttpOverrides.global = MyHttpOverrides();
  await fetchTaiwanHoliday();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

const String _statsKey = 'stats_key';

final mainProvider = StateNotifierProvider<MainNotifier, SpyState>((ref) {
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

  return MainNotifier(state);
});

class MainNotifier extends StateNotifier<SpyState> {
  MainNotifier(SpyState state) : super(state) {
    _init();
  }

  late final RestClient _restClient = RestClient.instance;

  String _currentMonth = '';
  TextEditingController currentController = TextEditingController();
  String? _current;
  Timer? _currentDebouncing;

  bool loading = true;

  /// 設定現價
  set current(String value) {
    _current = value;
    _currentDebouncing?.cancel();
    _currentDebouncing = Timer(const Duration(milliseconds: 500), () {
      state = state.copyWith(current: int.tryParse(_current?.toString() ?? ''));
      currentController.text =
          int.tryParse(_current?.toString() ?? '').toString();
    });
  }

  /// 取得SPY價格
  Future<void> _init() async {
    await _fetchCurrentMonth();
    await Future.wait([
      _fetchCurrentPrice(),
      _fetchSpyPrice(),
    ]);

    loading = false;
    state = state.copyWith();
  }

  /// 取得近月
  Future<void> _fetchCurrentMonth() async {
    try {
      final response =
          await _restClient.getProductMonthsInfo(TxfRequest.current());
      _currentMonth = response.rtData.items
          .where((element) => element.item.length == 6)
          .reduce((value, element) {
        DateTime parseDate(String dateStr) {
          if (dateStr.length != 6) {
            throw const FormatException("Invalid date format");
          }
          final year = int.parse(dateStr.substring(0, 4));
          final month = int.parse(dateStr.substring(4, 6));
          return DateTime(year, month, 1);
        }

        // 找尋時間最小的，就是近月
        DateTime currentMonth = parseDate(value.item);
        DateTime compareMonth = parseDate(element.item);
        return currentMonth.isBefore(compareMonth) ? value : element;
      }).item;
      // ignore: empty_catches
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
    }
  }

  Future<void> _fetchSpyPrice() async {
    await Future.wait([
      fetchSpyPrice(),
      if (isDay) fetchSpyPrice(false),
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
      if (isDay) {
        String nightHigh = value[1][0];
        String nightLow = value[1][1];
        state = state.copyWith(
            nightSpy: state.nightSpy.copyWith(
                high: int.tryParse(nightHigh), low: int.tryParse(nightLow)));
        nightSpyHighController.text = nightHigh;
        nightSpyLowController.text = nightLow;
      }
    });
    // 計算下一次更新SPY的時間
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8));
    if (isDay) {
      // 日盤等收盤就可以更新
      Future.delayed(
          DateTime(now.year, now.month, now.day, 13, 45).difference(now), () {
        _fetchSpyPrice();
      });
    } else {
      // 夜盤等收盤就可以更新
      late Duration diff;
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
      diff = Duration(hours: dis.hour, minutes: dis.minute, seconds: dis.second);
      Future.delayed(diff, () {
        _fetchSpyPrice();
      });
    }
  }

  /// 取得現價
  Future<void> _fetchCurrentPrice() async {
    final response =
        await _restClient.getTxfInfo(TxfRequest.current(_currentMonth));
    final quoteList = response.rtData.quoteList.length == 1
        ? response.rtData.quoteList.first
        : response.rtData.quoteList[1];
    int? price = double.tryParse(quoteList.cLastPrice)?.toInt();
    state = state.copyWith(current: price);
    currentController.text = price?.toString() ?? '';
    Future.delayed(const Duration(seconds: 1), () {
      _fetchCurrentPrice();
    });
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

  /// Spy，是否展開
  void spyExpand(bool expand) {
    state = state.copyWith(spyExpand: expand);
  }

  /// 靈敏度空間，是否展開
  void sensitivitySpaceExpand(bool expand) {
    state = state.copyWith(sensitivitySpaceExpand: expand);
  }

  /// 關鍵價位列表，是否展開
  void keyValuesExpand(bool expand) {
    state = state.copyWith(keyValuesExpand: expand);
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
    String defTitle =  direction.typeName;
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

  List<MapEntry<String, num>> get keyValues {
    List<MapEntry<String, num>> keyValues = [
      MapEntry(KeyValue.current, state.current),
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
        // 找出數值不為空值的
        .where((element) => element.value != null)
        // 找出有考慮的
        .where((element) => state.considerKeyValue[element.key.title] ?? true)
        .map((e) => MapEntry(e.key.title, e.value!))
        .toList();
    // 加入Spy
    keyValues.addAll(
      [state.daySpy, state.nightSpy]
          .expand((spy) {
            // 標題加入日夜盤
            return spyValues(spy)
                // 移除點差和點差/4
                .where((element) =>
                    element.key != KeyValue.range &&
                    element.key != KeyValue.rangeDiv4)
                .map((e) => MapEntry(
                    '${spy.isDay ? '日' : '夜'}盤，${e.key.title}', e.value));
          })
          // 找出數值不為空值的
          .where((element) => element.value != null)
          // 找出有考慮的
          .where((element) => state.considerKeyValue[element.key] ?? true)
          .map((e) => MapEntry(e.key, e.value!)),
    );
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
        .where((element) => state.considerKeyValue[element.key] ?? true));

    // 加入自定義關鍵價
    keyValues.addAll(state.customizeValues
        // 找出數值不為空值的
        .where((element) => element.value != null)
        // 找出有考慮的
        .where((element) => state.considerKeyValue[element.title] ?? true)
        .map((element) => MapEntry(element.title, element.value!)));

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
    if (keyValues
            .indexWhere((element) => element.key == KeyValue.current.title) ==
        -1) {
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
    prefs.setString(_statsKey, jsonEncode(state.toJson()));
  }
}

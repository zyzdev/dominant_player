import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dominant_player/model/key_value.dart';
import 'package:dominant_player/model/sensitivity_space_state.dart';
import 'package:dominant_player/provider/current_month_symbol_id_provider.dart';
import 'package:dominant_player/provider/current_price_provider.dart';
import 'package:dominant_player/provider/current_tick_provider.dart';
import 'package:dominant_player/service/holiday_info.dart';
import 'package:dominant_player/widgets/notification_wall/notification_wall_provider.dart';
import 'package:dominant_player/widgets/sensitivity_space/sensitivity_space_state_provider.dart';
import 'package:dominant_player/widgets/spy/spy_state_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/main_state.dart';
import 'model/spy_state.dart';
import 'provider/current_month_provider.dart';

SharedPreferences? _prefs;

SharedPreferences get prefs => _prefs!;

Future<void> init() async {
  _prefs ??= await SharedPreferences.getInstance();
  if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
    await fetchTaiwanHoliday();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

const String _statsKey = 'main_stats_key';

final mainProvider = StateNotifierProvider<MainNotifier, MainState>((ref) {
  String? json = prefs.getString(_statsKey);
  late MainState state;
  try {
    if (json != null) {
      state = MainState.fromJson(jsonDecode(json));
    } else {
      state = MainState();
    }
  } catch (e, stack) {
    state = MainState();

    debugPrint(e.toString());
    debugPrint(stack.toString());
  }

  return MainNotifier(state, ref);
});

class MainNotifier extends StateNotifier<MainState> {
  MainNotifier(MainState state, StateNotifierProviderRef ref) : super(state) {
    _spyState = ref.read(spyStateNotificationProvider);
    _sensitivitySpaceState = ref.read(sensitivitySpaceStateNotificationProvider);
    _notificationStateNotifier = ref.read(notificationWallStateProvider.notifier);

    if (!kIsWeb) _initFetch(ref);
    currentController.text = state.current?.toString() ?? '';
    noticeDisController.text = state.noticeDis.toString();
    updateKeyValues();
  }

  late final SpyState _spyState;
  late final SensitivitySpaceState _sensitivitySpaceState;
  late final NotificationWallStateNotifier _notificationStateNotifier;

  void setAutoNotice(bool enable) {
    state = state.copyWith(autoNotice: enable);
  }

  String? _noticeDis;
  TextEditingController noticeDisController = TextEditingController();
  Timer? _noticeDisDebouncing;
  Map<String, bool> noticedKeyValues = {};

  set noticeDis(String value) {
    _noticeDis = value;
    _noticeDisDebouncing?.cancel();
    _noticeDisDebouncing = Timer(const Duration(milliseconds: 500), () {
      int? newDis = int.tryParse(_noticeDis?.toString() ?? '');
      if (newDis == state.noticeDis) return;
      state = state.copyWith(noticeDis: newDis);
      _shouldNotice();
    });
  }

  /// 紀錄最近才推播過的關鍵價
  final List<String> _justNotificationKeyValues = [];

  Future<void> _shouldNotice() async {
    if (state.current == null || kIsWeb || !state.autoNotice) return;
    // 找尋需要推播的關鍵價
    Map<String, String> msgEntry = {};
    Map<num, MapEntry<String, num>> disEntry = {};
    keyValues
        .where((element) => element.key != KeyValue.current.title)
        .where((element) => !_justNotificationKeyValues.contains(element.key))
        .forEach((element) {
      int dis = (element.value - state.current!).toInt();
      if (dis.abs() <= state.noticeDis) {
        disEntry[dis] = element;
        _justNotificationKeyValues.add(element.key);
      }
    });


    if (disEntry.isNotEmpty) {
      final disList = disEntry.keys.toList()..sort();
      for (var dis in disList) {
        MapEntry<String, num> data = disEntry[dis]!;
        msgEntry[data.key] = '${data.value.toInt().toString()} ${dis > 0 ? '+' : ''}$dis';
      }
      msgEntry = {
        '現價': '${state.current}',
        ...msgEntry,
      };
      _notificationStateNotifier.pushNotification('接近關鍵價位！', msgEntry);
    }
    // 移除剛推播過，但已離現價較遠的關鍵價
    keyValues
        .where((element) => _justNotificationKeyValues.contains(element.key))
        .where((element) =>
            (element.value - state.current!).abs() > state.noticeDis + 5)
        .forEach((element) {
      _justNotificationKeyValues.remove(element.key);
    });
  }

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
          int.tryParse(_current?.toString() ?? '')?.toString() ?? '';
      _shouldNotice();
    });
  }

  /// 取得SPY價格
  Future<void> _initFetch(StateNotifierProviderRef ref) async {
    ref.listen(currentMonthProvider, (previous, currentMonth) {
      fetchCurrentMonthSymbolID(ref);
    });
    ref.listen(currentMonthSymbolIdProvider, (previous, currentSymbolId) {
      fetchCurrentTick(ref);
    });
    ref.listen<int?>(currentPriceProvider, (previous, currentPrice) {
      if (currentPrice == null) return;
      currentController.text = currentPrice.toString();
      updateKeyValues();
      _shouldNotice();
      state = state.copyWith(current: currentPrice);
    });

    await fetchCurrentMonth(ref);

    loading = false;
    state = state.copyWith();
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

  /// 關鍵K棒，是否展開
  void keyChartNoticeExpand(bool expand) {
    state = state.copyWith(keyChartNoticeExpand: expand);
  }

  /// 推播牆，是否展開
  void notificationWallExpand(bool expand) {
    state = state.copyWith(notificationWallExpand: expand);
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

  List<MapEntry<String, num>> _keyValues = [];

  List<MapEntry<String, num>> get keyValues => _keyValues;

  void updateKeyValues() {
    List<MapEntry<String, num>> keyValues = [
      MapEntry(KeyValue.current, state.current),
      MapEntry(
          KeyValue.dayLongAttack15, _sensitivitySpaceState.daySensitivitySpace15.longAttack),
      MapEntry(
          KeyValue.dayLongMiddle15, _sensitivitySpaceState.daySensitivitySpace15.longMiddle),
      MapEntry(
          KeyValue.dayLongDefense15, _sensitivitySpaceState.daySensitivitySpace15.longDefense),
      MapEntry(
          KeyValue.dayLongAttack30, _sensitivitySpaceState.daySensitivitySpace30.longAttack),
      MapEntry(
          KeyValue.dayLongMiddle30, _sensitivitySpaceState.daySensitivitySpace30.longMiddle),
      MapEntry(
          KeyValue.dayLongDefense30, _sensitivitySpaceState.daySensitivitySpace30.longDefense),
      MapEntry(
          KeyValue.dayShortAttack15, _sensitivitySpaceState.daySensitivitySpace15.shortAttack),
      MapEntry(
          KeyValue.dayShortMiddle15, _sensitivitySpaceState.daySensitivitySpace15.shortMiddle),
      MapEntry(
          KeyValue.dayShortDefense15, _sensitivitySpaceState.daySensitivitySpace15.shortDefense),
      MapEntry(
          KeyValue.dayShortAttack30, _sensitivitySpaceState.daySensitivitySpace30.shortAttack),
      MapEntry(
          KeyValue.dayShortMiddle30, _sensitivitySpaceState.daySensitivitySpace30.shortMiddle),
      MapEntry(
          KeyValue.dayShortDefense30, _sensitivitySpaceState.daySensitivitySpace30.shortDefense),
      MapEntry(
          KeyValue.nightLongAttack15, _sensitivitySpaceState.nightSensitivitySpace15.longAttack),
      MapEntry(
          KeyValue.nightLongMiddle15, _sensitivitySpaceState.nightSensitivitySpace15.longMiddle),
      MapEntry(KeyValue.nightLongDefense15,
          _sensitivitySpaceState.nightSensitivitySpace15.longDefense),
      MapEntry(
          KeyValue.nightLongAttack30, _sensitivitySpaceState.nightSensitivitySpace30.longAttack),
      MapEntry(
          KeyValue.nightLongMiddle30, _sensitivitySpaceState.nightSensitivitySpace30.longMiddle),
      MapEntry(KeyValue.nightLongDefense30,
          _sensitivitySpaceState.nightSensitivitySpace30.longDefense),
      MapEntry(KeyValue.nightShortAttack15,
          _sensitivitySpaceState.nightSensitivitySpace15.shortAttack),
      MapEntry(KeyValue.nightShortMiddle15,
          _sensitivitySpaceState.nightSensitivitySpace15.shortMiddle),
      MapEntry(KeyValue.nightShortDefense15,
          _sensitivitySpaceState.nightSensitivitySpace15.shortDefense),
      MapEntry(KeyValue.nightShortAttack30,
          _sensitivitySpaceState.nightSensitivitySpace30.shortAttack),
      MapEntry(KeyValue.nightShortMiddle30,
          _sensitivitySpaceState.nightSensitivitySpace30.shortMiddle),
      MapEntry(KeyValue.nightShortDefense30,
          _sensitivitySpaceState.nightSensitivitySpace30.shortDefense),
    ]
        // 找出數值不為空值的
        .where((element) => element.value != null)
        // 找出有考慮的
        .where((element) => _sensitivitySpaceState.considerKeyValue[element.key.title] ?? true)
        .map((e) => MapEntry(e.key.title, e.value!))
        .toList();
    // 加入Spy
    keyValues.addAll(
      [_spyState.daySpy, _spyState.nightSpy]
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
          .where((element) => _sensitivitySpaceState.considerKeyValue[element.key] ?? true)
          .map((e) => MapEntry(e.key, e.value!)),
    );
    // 加入自定義靈敏度空間
    keyValues.addAll(_sensitivitySpaceState.customizeSensitivitySpaces
        .expand((element) => [
              if (element.attack != null)
                MapEntry(element.attackKeyTitle, element.attack!),
              if (element.middle != null)
                MapEntry(element.middleKeyTitle, element.middle!),
              if (element.defense != null)
                MapEntry(element.defenseKeyTitle, element.defense!),
            ]) // 找出有考慮的
        .where((element) => _sensitivitySpaceState.considerKeyValue[element.key] ?? true));

    // 加入自定義關鍵價
    keyValues.addAll(_sensitivitySpaceState.customizeValues
        // 找出數值不為空值的
        .where((element) => element.value != null)
        // 找出有考慮的
        .where((element) => _sensitivitySpaceState.considerKeyValue[element.title] ?? true)
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
    _keyValues = keyValues;
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
  set state(MainState state) {
    super.state = state;
    updateKeyValues();
    prefs.setString(_statsKey, jsonEncode(state.toJson()));
  }
}

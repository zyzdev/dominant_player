import 'dart:async';
import 'dart:convert';

import 'package:dominant_player/main_provider.dart';
import 'package:dominant_player/model/key_value.dart';
import 'package:dominant_player/model/key_value_list_state.dart';
import 'package:dominant_player/model/sensitivity_space_state.dart';
import 'package:dominant_player/model/spy_state.dart';
import 'package:dominant_player/provider/current_price_provider.dart';
import 'package:dominant_player/widgets/notification_wall/notification_wall_provider.dart';
import 'package:dominant_player/widgets/sensitivity_space/sensitivity_space_state_provider.dart';
import 'package:dominant_player/widgets/spy/spy_state_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _statsKey = 'key_value_list_stats_key';

final keyValueListNotifierProvider =
    StateNotifierProvider<KeyValueListMainNotifier, KeyValueListState>((ref) {
  final current = ref.read(currentPriceProvider);

  String? json = prefs.getString(_statsKey);
  late KeyValueListState state;
  try {
    if (json != null) {
      state = KeyValueListState.fromJson(jsonDecode(json));
    } else {
      state = KeyValueListState();
    }
  } catch (e, stack) {
    state = KeyValueListState();

    debugPrint(e.toString());
    debugPrint(stack.toString());
  }
  state = state.copyWith(current: current);
  return KeyValueListMainNotifier(
    state,
    ref,
  );
});

class KeyValueListMainNotifier extends StateNotifier<KeyValueListState> {
  KeyValueListMainNotifier(
    super.state,
    StateNotifierProviderRef ref,
  ) {
    _spyState = ref.read(spyStateNotifierProvider);
    _sensitivitySpaceState = ref.read(sensitivitySpaceStateNotifierProvider);
    updateKeyValues();

    ref.listen<int?>(currentPriceProvider, (previous, next) {
      if (next == null) return;
      state = state.copyWith(current: next);
      currentController.text = next.toString();
      updateKeyValues();
    });
    ref.listen<SpyState>(
      spyStateNotifierProvider,
      (previous, next) {
        _spyState = next;
        updateKeyValues();
      },
    );
    ref.listen<SensitivitySpaceState>(
      sensitivitySpaceStateNotifierProvider,
      (previous, next) {
        _sensitivitySpaceState = next;
        updateKeyValues();
      },
    );

    _notificationStateNotifier = ref.read(notificationWallStateProvider.notifier);
    currentController.text = state.current?.toString() ?? '';
    noticeDisController.text = state.noticeDis.toString();
  }

  SpyState? _spyState;

  SpyState get spyState => _spyState!;

  SensitivitySpaceState? _sensitivitySpaceState;

  SensitivitySpaceState get sensitivitySpaceState => _sensitivitySpaceState!;

  final List<MapEntry<String, num>> keyValues = [];

  late final NotificationWallStateNotifier _notificationStateNotifier;

  void updateKeyValues() {
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

    // 加入Spy
    List<MapEntry<String, num>> keyValues = [spyState.daySpy, spyState.nightSpy]
        .expand((spy) {
          // 標題加入日夜盤
          return spyValues(spy)
              // 移除點差和點差/4
              .where(
                  (element) => element.key != KeyValue.range && element.key != KeyValue.rangeDiv4)
              .map((e) => MapEntry('${spy.isDay ? '日' : '夜'}盤，${e.key.title}', e.value));
        })
        // 找出數值不為空值的
        .where((element) => element.value != null)
        // 找出有考慮的
        .where((element) => spyState.considerKeyValue[element.key] ?? true)
        .map((e) => MapEntry(e.key, e.value!))
        .toList();

    // 加入日夜盤最大邏輯靈敏度空間
    keyValues.addAll([
      MapEntry(KeyValue.current, state.current),
      MapEntry(KeyValue.dayLongAttack15, sensitivitySpaceState.daySensitivitySpace15.longAttack),
      MapEntry(KeyValue.dayLongMiddle15, sensitivitySpaceState.daySensitivitySpace15.longMiddle),
      MapEntry(KeyValue.dayLongDefense15, sensitivitySpaceState.daySensitivitySpace15.longDefense),
      MapEntry(KeyValue.dayLongAttack30, sensitivitySpaceState.daySensitivitySpace30.longAttack),
      MapEntry(KeyValue.dayLongMiddle30, sensitivitySpaceState.daySensitivitySpace30.longMiddle),
      MapEntry(KeyValue.dayLongDefense30, sensitivitySpaceState.daySensitivitySpace30.longDefense),
      MapEntry(KeyValue.dayShortAttack15, sensitivitySpaceState.daySensitivitySpace15.shortAttack),
      MapEntry(KeyValue.dayShortMiddle15, sensitivitySpaceState.daySensitivitySpace15.shortMiddle),
      MapEntry(
          KeyValue.dayShortDefense15, sensitivitySpaceState.daySensitivitySpace15.shortDefense),
      MapEntry(KeyValue.dayShortAttack30, sensitivitySpaceState.daySensitivitySpace30.shortAttack),
      MapEntry(KeyValue.dayShortMiddle30, sensitivitySpaceState.daySensitivitySpace30.shortMiddle),
      MapEntry(
          KeyValue.dayShortDefense30, sensitivitySpaceState.daySensitivitySpace30.shortDefense),
      MapEntry(
          KeyValue.nightLongAttack15, sensitivitySpaceState.nightSensitivitySpace15.longAttack),
      MapEntry(
          KeyValue.nightLongMiddle15, sensitivitySpaceState.nightSensitivitySpace15.longMiddle),
      MapEntry(
          KeyValue.nightLongDefense15, sensitivitySpaceState.nightSensitivitySpace15.longDefense),
      MapEntry(
          KeyValue.nightLongAttack30, sensitivitySpaceState.nightSensitivitySpace30.longAttack),
      MapEntry(
          KeyValue.nightLongMiddle30, sensitivitySpaceState.nightSensitivitySpace30.longMiddle),
      MapEntry(
          KeyValue.nightLongDefense30, sensitivitySpaceState.nightSensitivitySpace30.longDefense),
      MapEntry(
          KeyValue.nightShortAttack15, sensitivitySpaceState.nightSensitivitySpace15.shortAttack),
      MapEntry(
          KeyValue.nightShortMiddle15, sensitivitySpaceState.nightSensitivitySpace15.shortMiddle),
      MapEntry(
          KeyValue.nightShortDefense15, sensitivitySpaceState.nightSensitivitySpace15.shortDefense),
      MapEntry(
          KeyValue.nightShortAttack30, sensitivitySpaceState.nightSensitivitySpace30.shortAttack),
      MapEntry(
          KeyValue.nightShortMiddle30, sensitivitySpaceState.nightSensitivitySpace30.shortMiddle),
      MapEntry(
          KeyValue.nightShortDefense30, sensitivitySpaceState.nightSensitivitySpace30.shortDefense),
    ]
        // 找出數值不為空值的
        .where((element) => element.value != null)
        // 找出有考慮的
        .where((element) => sensitivitySpaceState.considerKeyValue[element.key.title] ?? true)
        .map((e) => MapEntry(e.key.title, e.value!)));

    // 加入自定義靈敏度空間
    keyValues.addAll(sensitivitySpaceState.customizeSensitivitySpaces
        .expand((element) => [
              if (element.attack != null) MapEntry(element.attackKeyTitle, element.attack!),
              if (element.middle != null) MapEntry(element.middleKeyTitle, element.middle!),
              if (element.defense != null) MapEntry(element.defenseKeyTitle, element.defense!),
            ]) // 找出有考慮的
        .where((element) => sensitivitySpaceState.considerKeyValue[element.key] ?? true));

    // 加入自定義關鍵價
    keyValues.addAll(sensitivitySpaceState.customizeValues
        // 找出數值不為空值的
        .where((element) => element.value != null)
        // 找出有考慮的
        .where((element) => sensitivitySpaceState.considerKeyValue[element.title] ?? true)
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
    if (keyValues.indexWhere((element) => element.key == KeyValue.current.title) == -1) {
      keyValues.insert(0, MapEntry(KeyValue.current.title, -1));
    }
    this.keyValues.clear();
    this.keyValues.addAll(keyValues);

    state = state.copyWith();
    _shouldNotice();
  }

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

      List<String> messages = ['現價：${state.current}'];
      msgEntry.forEach((key, value) {
        messages.add('$key：$value');
      });
      _notificationStateNotifier.pushNotification('接近關鍵價位！', messages);
    }
    // 移除剛推播過，但已離現價較遠的關鍵價
    keyValues
        .where((element) => _justNotificationKeyValues.contains(element.key))
        .where((element) => (element.value - state.current!).abs() > state.noticeDis + 5)
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
      currentController.text = int.tryParse(_current?.toString() ?? '')?.toString() ?? '';
      _shouldNotice();
    });
  }

  @override
  set state(KeyValueListState state) {
    super.state = state;
    prefs.setString(_statsKey, jsonEncode(state.toJson()));
  }
}

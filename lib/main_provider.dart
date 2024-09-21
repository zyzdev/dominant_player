import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dominant_player/provider/current_month_symbol_id_provider.dart';
import 'package:dominant_player/provider/current_tick_provider.dart';
import 'package:dominant_player/provider/index_statistics_provider.dart';
import 'package:dominant_player/provider/transaction_statistics_provider.dart';
import 'package:dominant_player/service/holiday_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/main_state.dart';
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
    if (!kIsWeb) _initFetch(ref);
  }

  Future<void> _initFetch(StateNotifierProviderRef ref) async {
    ref.listen(currentMonthProvider, (previous, currentMonth) {
      fetchCurrentMonthSymbolID(ref);
    });
    ref.listen(currentMonthSymbolIdProvider, (previous, currentSymbolId) {
      fetchCurrentTick(ref);
    });

    await fetchCurrentMonth(ref);

    state = state.copyWith();
  }

  bool get isWeekend {
    final now = DateTime.now().toUtc().add(const Duration(hours: 8));
    return now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
  }

  /// 盤勢判斷，是否展開
  void marketPotentialExpand(bool expand) {
    state = state.copyWith(marketPotentialExpand: expand);
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

  @override
  set state(MainState state) {
    super.state = state;
    prefs.setString(_statsKey, jsonEncode(state.toJson()));
  }
}

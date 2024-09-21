import 'dart:async';

import 'package:dominant_player/model/index_statistics.dart';
import 'package:dominant_player/model/market_potential_state.dart';
import 'package:dominant_player/model/transaction_statistics.dart';
import 'package:dominant_player/service/holiday_info.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final marketPotentialStateProvider =
    StateNotifierProvider<MarketPotentialNotifier, MarketPotentialState>((ref) {
  return MarketPotentialNotifier(MarketPotentialState.init(), ref);
});

class MarketPotentialNotifier extends StateNotifier<MarketPotentialState> {
  MarketPotentialNotifier(super.state, StateNotifierProviderRef ref) {
    // 先找出最近的開盤日
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8));
    while (isHoliday(now)) {
      now = now.subtract(const Duration(days: 1));
    }
    lastTrendDateTime = dateFormat.format(now);
    now = now.subtract(const Duration(days: 1));
    while (isHoliday(now)) {
      now = now.subtract(const Duration(days: 1));
    }
    preTrendDateTime = dateFormat.format(now);
    //
    _fetchData();
  }

  final dateFormat = DateFormat('yyyyMMdd');

  /// 最近的交易日
  late String lastTrendDateTime;

  /// 最近的交易日的上一個交易日
  late String preTrendDateTime;
  final TaiexClient _restClient = TaiexClient.instance;

  bool _openInfoMayTrend = false;

  bool get openInfoMayTrend => _openInfoMayTrend;
  bool _cumulativeTransactionAmountInfoMayTrend = false;

  bool get cumulativeTransactionAmountInfoMayTrend =>
      _cumulativeTransactionAmountInfoMayTrend;

  bool get mayTrend => _openInfoMayTrend && _cumulativeTransactionAmountInfoMayTrend;

  Future<void> _fetchData() async {
    _fetchTodayData();
    _fetchPreDayData();
  }

  /// 抓取上一次日盤的高低點、開盤5K的成交量
  Future<void> _fetchPreDayData() async {
    final responses = await Future.wait([
      _restClient
          .getTransactionStatistics(preTrendDateTime)
          .then((value) => value.first5KCumulativeTransactionAmount()),
      _restClient.getIndexStatistics(preTrendDateTime)
    ]);
    state = state.copyWith(
      preCumulativeTransactionAmount: responses[0] as double,
      preHigh: (responses[1] as IndexStatisticsResponse).highTaiexIndex,
      preLow: (responses[1] as IndexStatisticsResponse).lowTaiexIndex,
    );
  }

  /// 抓取開盤價
  Future<void> _fetchTodayData() async {
    try {
      // 要抓9：00：05的資料，才是開盤價
      DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8));
      DateTime openTime = DateTime(now.year, now.month, now.day, 9, 0, 5)
          .toUtc()
          .add(const Duration(hours: 8));
      // 如果在9：00：05之前，要先延遲一下
      if (now.isBefore(openTime)) {
        await Future.delayed(openTime.difference(now));
      }
      final responses = await Future.wait([
        _restClient.getIndexStatistics().then((value) => value.openTaiexIndex),
        _restClient.getTransactionStatistics(),
      ]);

      state = state.copyWith(
        open: responses[0] as int,
        cumulativeTransactionAmount:
            (responses[1] as TransactionStatisticsResponse)
                .cumulativeTransactionAmountInBillions,
      );
      // 如果尚未五分，要每五秒更新累計交易金額，直到9：05
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        final response = await _restClient.getTransactionStatistics();
        state = state.copyWith(
            cumulativeTransactionAmount:
                response.first5KCumulativeTransactionAmount());
        if (response.data.length >= 60) timer.cancel();
      });
    } catch (error, stack) {
      debugPrint(error.toString());
      debugPrint(stack.toString());
      return _fetchIndexStatistics();
    }
  }

  /// 抓取開盤價
  Future<void> _fetchIndexStatistics() async {
    try {
      // 要抓9：00：05的資料，才是開盤價
      DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8));
      DateTime openTime = DateTime(now.year, now.month, now.day, 9, 0, 5)
          .toUtc()
          .add(const Duration(hours: 8));
      // 如果在9：00：05之前，要先延遲一下
      if (now.isBefore(openTime)) {
        await Future.delayed(openTime.difference(now));
      }

      final response = await _restClient.getIndexStatistics();
      state = state.copyWith(open: response.openTaiexIndex);
    } catch (error, stack) {
      debugPrint(error.toString());
      debugPrint(stack.toString());
      return _fetchIndexStatistics();
    }
  }

  List<String> get openInfo {
    final List<String> openInfo = [];
    Map<String, num> values = {
      '開盤價': state.open,
      '昨高': state.preHigh,
      '昨低': state.preLow,
    };
    final sortedValues = values.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (int i = 0; i < sortedValues.length; i++) {
      final tmp = sortedValues[i];
      String info;
      if (tmp.key == '開盤價') {
        _openInfoMayTrend =
            (i == 0 && tmp.value - sortedValues[i + 1].value >= 60) ||
                (i == 2 && sortedValues[i - 1].value - tmp.value >= 60);
        if (_openInfoMayTrend) {
          num dis = i == 0
              ? tmp.value - sortedValues[i + 1].value
              : tmp.value - sortedValues[i - 1].value;
          info = '${tmp.key}：${tmp.value} ${dis > 0 ? '+' : ''}$dis';
        } else {
          info = '${tmp.key}：${tmp.value == 0 ? '-' : '${tmp.value}'}';
        }
      } else {
        info = '${tmp.key}：${tmp.value}';
      }
      openInfo.add(info);
    }
    return openInfo;
  }

  List<String> get cumulativeTransactionAmountInfo {
    final List<String> cumulativeTransactionAmountInfo = [];
    double dis = state.cumulativeTransactionAmount -
        state.preCumulativeTransactionAmount;
    _cumulativeTransactionAmountInfoMayTrend = dis > 0;
    cumulativeTransactionAmountInfo.add(
        '今量：${state.cumulativeTransactionAmount}億 ${_cumulativeTransactionAmountInfoMayTrend ? '+' : ''}${dis.toStringAsFixed(2)}億');
    cumulativeTransactionAmountInfo
        .add('昨量：${state.preCumulativeTransactionAmount}億');

    return cumulativeTransactionAmountInfo;
  }
}

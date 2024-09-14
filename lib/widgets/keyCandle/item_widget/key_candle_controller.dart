import 'package:dominant_player/model/candle_info.dart';
import 'package:dominant_player/model/real_time_chart_info.dart';
import 'package:dominant_player/service/notification.dart';
import 'package:dominant_player/widgets/notification_wall/notification_wall_provider.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'key_candle_state.dart';

/// [KeyChartState]是一個model
/// [KeyChartStateController]主要是加入一些[KeyChartState]相關的業務邏輯
extension KeyChartStateController on KeyCandleState {
  void shouldNotice(
    RealTimeChartInfo realTimeChartInfo,
    BuildContext context,
      WidgetRef ref,
  ) {
    CandleInfo? candleInfo = realTimeChartInfo.getLastFinishCandleInfo();
    if (candleInfo == null) return;
    String msg = '';
    if (considerVolume && keyVolume != null) {
      if (candleInfo.volume > keyVolume!) {
        print('成交量：${candleInfo.volume}, $keyVolume');
        msg = '成交量：${candleInfo.volume}';
      } else {
        return;
      }
    }
    if (closeWithLongUpperShadow) {
      if (candleInfo.isCloseWithLongUpperShadow) {
        print(
            '收長上影：upperShadow:${candleInfo.upperShadowDis}, dis/2:${candleInfo.distance / 2}, ${candleInfo.close}');
        print(candleInfo);
        msg += '${msg.isNotEmpty ? ', ' : ''}長上影';
      }
    }
    if (closeWithLongLowerShadow) {
      if (candleInfo.isCloseWithLongLowerShadow) {
        print(
            '收長下影：lowerShadow:${candleInfo.lowerShadowDis}, dis/2:${candleInfo.distance / 2},  ${candleInfo.close}');
        print(candleInfo);
        msg += '${msg.isNotEmpty ? ', ' : ''}長下影';
      }
    }

    if (aTurn) {
      // 至少要考慮前兩根K棒
      int peakInPeriod = aTurnInPeriod ?? 2;
      if (realTimeChartInfo.allCandleInfo.length > peakInPeriod) {
        int finishIndex = realTimeChartInfo.allCandleInfo.indexOf(candleInfo);
        // 上升的K棒
        final uphill = realTimeChartInfo.allCandleInfo
            .sublist(finishIndex - peakInPeriod, finishIndex);
        int peakClose = uphill.last.close;
        // 檢查上一根收盤點是否為最高
        bool isHighest = !uphill
            .sublist(0, uphill.length)
            .any((element) => element.close > peakClose);
        if (isHighest && candleInfo.close < uphill.last.close) {
          print('A轉:${candleInfo.startTime}');
          print('======');
          uphill.forEach((element) {
            print(element);
          });
          print('\n');
          print(candleInfo);
          print('======');
          msg += '${msg.isNotEmpty ? ', ' : ''}A轉';
        }
      }
    }
    if (vTurn) {
      // 至少要考慮前兩根K棒
      int valleyInPeriod = vTurnInPeriod ?? 2;
      if (realTimeChartInfo.allCandleInfo.length > valleyInPeriod) {
        int finishIndex = realTimeChartInfo.allCandleInfo.indexOf(candleInfo);
        // 下降的K棒
        final downhill = realTimeChartInfo.allCandleInfo
            .sublist(finishIndex - valleyInPeriod, finishIndex);
        int valleyLow = downhill.last.close;
        // 檢查上一根收盤點是否為最低
        bool isLowest = !downhill
            .sublist(0, downhill.length)
            .any((element) => element.close < valleyLow);
        if (isLowest && candleInfo.close > downhill.last.close) {
          print('V轉:${candleInfo.startTime}');
          print('======');
          downhill.forEach((element) {
            print(element);
          });
          print('\n');
          print(candleInfo);
          print('======');
          msg += '${msg.isNotEmpty ? ', ' : ''}V轉';
        }
      }
    }

    if (longAttack && longAttackPoint != null) {
      if (realTimeChartInfo.allCandleInfo.length - 3 >= 0) {
        CandleInfo preCandleInfo = realTimeChartInfo
            .allCandleInfo[realTimeChartInfo.allCandleInfo.length - 3];
        if (candleInfo.close - preCandleInfo.close >= longAttackPoint!) {
          print('======多方攻擊');
          print(preCandleInfo);
          print(candleInfo);
          print('======');
          msg += '${msg.isNotEmpty ? ', ' : ''}多方攻擊';
        }
      }
    }

    if (shortAttack && shortAttackPoint != null) {
      if (realTimeChartInfo.allCandleInfo.length - 3 >= 0) {
        CandleInfo preCandleInfo = realTimeChartInfo
            .allCandleInfo[realTimeChartInfo.allCandleInfo.length - 3];
        if (preCandleInfo.close - candleInfo.close - preCandleInfo.close >=
            shortAttackPoint!) {
          msg += '${msg.isNotEmpty ? ', ' : ''}空方攻擊';
          print('======空方攻擊');
          print(preCandleInfo);
          print(candleInfo);
          print('======');
        }
      }
    }
    if (msg.isNotEmpty) {
      String time = DateFormat('HH:mm')
          .format(DateTime.now().toUtc().add(const Duration(hours: 8)));
      //ref.read(notificationStateProvider.notifier).pushNotification('關鍵K棒提醒！', msg);
      final snackBar = SnackBar(
        duration: const Duration(minutes: 3),
        showCloseIcon: true,
        content: Row(
          children: [
            Text('$time：', style: infoST),
            Text(msg, style: titleST),
          ],
        ),
      );
      ScaffoldMessenger.of(context)
          .removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

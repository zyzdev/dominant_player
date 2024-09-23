import 'package:dominant_player/model/candle_info.dart';
import 'package:dominant_player/model/key_candle_state.dart';
import 'package:dominant_player/model/real_time_chart_info.dart';
import 'package:dominant_player/widgets/notification_wall/notification_wall_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    List<String> messages = [];
    if (considerVolume && keyVolume != null) {
      if (candleInfo.volume > keyVolume!) {
        debugPrint('成交量：${candleInfo.volume}, $keyVolume');
        String info = '成交量：${candleInfo.volume}';
        messages.add(info);
      } else if (volumeRequired) {
        return;
      }
    }
    if (closeWithLongUpperShadow) {
      if (candleInfo.isCloseWithLongUpperShadow) {
        debugPrint(
            '收長上影：upperShadow:${candleInfo.upperShadowDis}, dis/2:${candleInfo.distance / 2}, ${candleInfo.close}');
        debugPrint(candleInfo.toString());
        String info = '長上影';
        messages.add(info);
      } else if (closeWithLongUpperShadowRequired) {
        return;
      }
    }
    if (closeWithLongLowerShadow) {
      if (candleInfo.isCloseWithLongLowerShadow) {
        debugPrint(
            '收長下影：lowerShadow:${candleInfo.lowerShadowDis}, dis/2:${candleInfo.distance / 2},  ${candleInfo.close}');
        debugPrint(candleInfo.toString());
        String info = '長下影';
        messages.add(info);
      } else if (closeWithLongLowerShadowRequired) {
        return;
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
          if ((aTurnAtHigh && realTimeChartInfo.high == candleInfo.high) ||
              !aTurnAtHigh) {
            debugPrint('A轉:${candleInfo.startTime}');
            debugPrint('======');
            for (var element in uphill) {
              debugPrint(element.toString());
            }
            debugPrint('\n');
            debugPrint(candleInfo.toString());
            debugPrint('======');
            String info = 'A轉${aTurnAtHigh ? '(今高)' : ''}';
            messages.add(info);
          }
        } else if (aTurnRequired) {
          return;
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
          if ((vTurnAtLow && realTimeChartInfo.low == candleInfo.low) ||
              !vTurnAtLow) {
            debugPrint('V轉:${candleInfo.startTime}');
            debugPrint('======');
            for (var element in downhill) {
              debugPrint(element.toString());
            }
            debugPrint('\n');
            debugPrint(candleInfo.toString());
            debugPrint('======');
            String info = 'V轉${vTurnAtLow ? '(今低)' : ''}';
            messages.add(info);
          }
        } else if (vTurnRequired) {
          return;
        }
      }
    }

    if (longAttack && longAttackPoint != null) {
      if (realTimeChartInfo.allCandleInfo.length - 3 >= 0) {
        CandleInfo preCandleInfo = realTimeChartInfo
            .allCandleInfo[realTimeChartInfo.allCandleInfo.length - 3];
        if (candleInfo.close - preCandleInfo.high >= longAttackPoint!) {
          debugPrint('======多方攻擊');
          debugPrint(preCandleInfo.toString());
          debugPrint(candleInfo.toString());
          debugPrint('longAttackPoint:$longAttackPoint');
          debugPrint('======');
          String info = '多方攻擊';
          messages.add(info);
        } else if (longAttackRequired) {
          return;
        }
      }
    }

    if (shortAttack && shortAttackPoint != null) {
      if (realTimeChartInfo.allCandleInfo.length - 3 >= 0) {
        CandleInfo preCandleInfo = realTimeChartInfo
            .allCandleInfo[realTimeChartInfo.allCandleInfo.length - 3];
        if (preCandleInfo.low - candleInfo.close >= shortAttackPoint!) {
          debugPrint('======空方攻擊');
          debugPrint(preCandleInfo.toString());
          debugPrint(candleInfo.toString());
          debugPrint('======');
          String info = '空方攻擊';
          debugPrint('shortAttackPoint:$shortAttackPoint');
          messages.add(info);
        } else if (shortAttackRequired) {
          return;
        }
      }
    }
    if (messages.isNotEmpty) {
      messages.insert(0,
          '開：${candleInfo.open} 高：${candleInfo.high} 中：${candleInfo.middle} 低：${candleInfo.low} 量：${candleInfo.volume} 收：${candleInfo.close} ${'${candleInfo.closeToOpen > 0 ? '+' : ''}${candleInfo.closeToOpen}'}');
      ref
          .read(notificationWallStateProvider.notifier)
          .pushNotification('關鍵K棒提醒！', messages);
    }
  }
}

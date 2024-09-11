import 'dart:math';

import 'package:dominant_player/model/chart_info.dart';
import 'package:dominant_player/model/real_time_chart_info.dart';
import 'package:dominant_player/service/notification.dart';

import 'key_chart_state.dart';

/// [KeyChartState]是一個model
/// [KeyChartStateController]主要是加入一些[KeyChartState]相關的業務邏輯
extension KeyChartStateController on KeyChartState {
  void shouldNotice(
    RealTimeChartInfo realTimeChartInfo,
  ) {
    ChartInfo? chartInfo = realTimeChartInfo.getLastFinishChartInfo();
    if (chartInfo == null) return;
    String msg = '';
    if (considerVolume && keyVolume != null) {
      if (chartInfo.volume > keyVolume!) {
        print('成交量：${chartInfo.volume}, $keyVolume');
        msg = '成交量：${chartInfo.volume}';
      } else {
        return;
      }
    }
    if (closeWithLongUpperShadow) {
      if (chartInfo.isCloseWithLongUpperShadow) {
        print(
            '收長上影：upperShadow:${chartInfo.upperShadowDis}, dis/2:${chartInfo.distance / 2}, ${chartInfo.close}');
        print(chartInfo);
        msg += '${msg.isNotEmpty ? ', ' :''}長上影';
      }
    }
    if (closeWithLongLowerShadow) {
      if (chartInfo.isCloseWithLongLowerShadow) {
        print(
            '收長下影：lowerShadow:${chartInfo.lowerShadowDis}, dis/2:${chartInfo.distance / 2},  ${chartInfo.close}');
        print(chartInfo);
        msg += '${msg.isNotEmpty ? ', ' :''}長下影';
      }
    }

    if (peak) {
      // 至少要考慮前兩根K棒
      int peakInPeriod = this.peakInPeriod ?? 2;
      if (realTimeChartInfo.allChartInfo.length > peakInPeriod) {
        int finishIndex = realTimeChartInfo.allChartInfo.indexOf(chartInfo);
        // 上升的K棒
        final uphill = realTimeChartInfo.allChartInfo
            .sublist(finishIndex - peakInPeriod, finishIndex);
        int peakClose = uphill.last.close;
        // 檢查上一根收盤點是否為最高
        bool isHighest = !uphill
            .sublist(0, uphill.length)
            .any((element) => element.close > peakClose);
        if (isHighest && chartInfo.close < uphill.last.close) {
          print('A轉:${chartInfo.startTime}');
          print('======');
          uphill.forEach((element) {
            print(element);
          });
          print('\n');
          print(chartInfo);
          print('======');
          msg += '${msg.isNotEmpty ? ', ' :''}A轉';
        }
      }
    }
    if (valley) {
      // 至少要考慮前兩根K棒
      int valleyInPeriod = this.valleyInPeriod ?? 2;
      if (realTimeChartInfo.allChartInfo.length > valleyInPeriod) {
        int finishIndex = realTimeChartInfo.allChartInfo.indexOf(chartInfo);
        // 下降的K棒
        final downhill = realTimeChartInfo.allChartInfo
            .sublist(finishIndex - valleyInPeriod, finishIndex);
        int valleyLow = downhill.last.close;
        // 檢查上一根收盤點是否為最低
        bool isLowest = !downhill
            .sublist(0, downhill.length)
            .any((element) => element.close < valleyLow);
        if (isLowest && chartInfo.close > downhill.last.close) {
          print('V轉:${chartInfo.startTime}');
          print('======');
          downhill.forEach((element) {
            print(element);
          });
          print('\n');
          print(chartInfo);
          print('======');
          msg += '${msg.isNotEmpty ? ', ' :''}V轉';
        }
      }
    }
    if(msg.isNotEmpty) {
      sendNotification('關鍵K棒提醒！', msg);
    }
  }
}

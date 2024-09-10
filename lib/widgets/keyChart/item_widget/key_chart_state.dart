import 'dart:math';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dominant_player/model/chart_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'key_chart_state.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class KeyChartState {
  /// 關鍵K棒標題
  final String title;

  /// 關鍵K棒的週期
  final int? kPeriod;

  final bool notice;

  /// 關鍵量
  final int? keyVolume;
  final bool considerVolume;

  /// 收長上影
  final bool closeWithLongUpperShadow;

  /// 收長下影
  final bool closeWithLongLowerShadow;

  /// 在[peakInPeriod]K棒裡面的山峰
  final int peakInPeriod;
  final bool peak;

  /// 在[valleyInPeriod]K棒裡面的山谷
  final int valleyInPeriod;
  final bool valley;

  KeyChartState({
    required this.title,
    this.kPeriod,
    this.notice = true,
    this.keyVolume,
    this.considerVolume = false,
    this.closeWithLongUpperShadow = false,
    this.closeWithLongLowerShadow = false,
    this.peakInPeriod = 10,
    this.peak = false,
    this.valleyInPeriod = 10,
    this.valley = false,
  });

  void shouldNotice(ChartInfo? chartInfo) {
    if (chartInfo == null) return;

    if (considerVolume && keyVolume != null) {
      if (chartInfo.volume > keyVolume!) {
        print('${chartInfo.volume}, $keyVolume');
      }
    }
    if (closeWithLongUpperShadow) {
      if (min(chartInfo.highToCloseDis, chartInfo.highToOpenDis) >= chartInfo.distance / 2) {
        print(
            '收長上影：upperShadow:${min(chartInfo.highToCloseDis, chartInfo.highToOpenDis)}, dis/2:${chartInfo.distance / 2}, ${chartInfo.close}');
        print(chartInfo);
      }
    }
    if (closeWithLongLowerShadow) {
      if (min(chartInfo.lowToCloseDis, chartInfo.lowToOpenDis) >= chartInfo.distance / 2) {
        print(
            '收長下影：lowerShadow:${min(chartInfo.lowToCloseDis, chartInfo.lowToOpenDis)}, dis/2:${chartInfo.distance / 2},  ${chartInfo.close}');
        print(chartInfo);
      }
    }
  }

  factory KeyChartState.fromJson(Map<String, dynamic> json) =>
      _$KeyChartStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KeyChartStateToJson(this);
}

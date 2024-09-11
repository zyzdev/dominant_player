import 'package:copy_with_extension/copy_with_extension.dart';
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
  final bool andOrCloseWithLongUpperShadow;
  final bool closeWithLongUpperShadow;

  /// 收長下影
  final bool andOrCloseWithLongLowerShadow;
  final bool closeWithLongLowerShadow;

  /// 在[peakInPeriod]K棒裡面的A轉
  final bool andOrPeak;
  final int? peakInPeriod;
  final bool peak;

  /// 在[valleyInPeriod]K棒裡面的V轉
  final bool andOrValley;
  final int? valleyInPeriod;
  final bool valley;

  KeyChartState({
    required this.title,
    this.kPeriod,
    this.notice = true,
    this.keyVolume,
    this.considerVolume = false,
    this.closeWithLongUpperShadow = false,
    this.andOrCloseWithLongLowerShadow = false,
    this.closeWithLongLowerShadow = false,
    this.andOrCloseWithLongUpperShadow = false,
    this.peakInPeriod = 10,
    this.peak = false,
    this.andOrPeak = false,
    this.valleyInPeriod = 10,
    this.valley = false,
    this.andOrValley = false,
  });

  factory KeyChartState.fromJson(Map<String, dynamic> json) =>
      _$KeyChartStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KeyChartStateToJson(this);
}

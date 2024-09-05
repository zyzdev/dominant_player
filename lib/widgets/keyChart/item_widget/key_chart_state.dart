
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

  KeyChartState({
    required this.title,
    this.kPeriod,
    this.notice = true,
  });

  factory KeyChartState.fromJson(Map<String, dynamic> json) =>
      _$KeyChartStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KeyChartStateToJson(this);
}

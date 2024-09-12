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

  /// 在[aTurnInPeriod]K棒裡面的A轉
  final bool andOrATurn;
  final int? aTurnInPeriod;
  final bool aTurn;

  /// 在[vTurnInPeriod]K棒裡面的V轉
  final bool andOrVTurn;
  final int? vTurnInPeriod;
  final bool vTurn;

  /// 多方攻擊
  final bool longAttack;
  final int? longAttackPoint;

  /// 空方攻擊
  final bool shortAttack;
  final int? shortAttackPoint;
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
    this.aTurnInPeriod = 10,
    this.aTurn = false,
    this.andOrATurn = false,
    this.vTurnInPeriod = 10,
    this.vTurn = false,
    this.andOrVTurn = false,
    this.longAttack = false,
    this.longAttackPoint = 20,
    this.shortAttack = false,
    this.shortAttackPoint = 20,
  });

  factory KeyChartState.fromJson(Map<String, dynamic> json) =>
      _$KeyChartStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KeyChartStateToJson(this);
}

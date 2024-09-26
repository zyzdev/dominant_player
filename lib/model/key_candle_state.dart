import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'key_candle_state.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class KeyCandleState {
  /// 關鍵K棒標題
  final String title;

  /// 關鍵K棒的週期
  final int? kPeriod;

  /// 是否展開
  final bool expand;

  /// 是否開啟推播
  final bool notice;

  /// 觸發時機
  TriggerType triggerType;

  /// 關鍵量
  final int? keyVolume;
  final bool considerVolume;
  /// 關鍵量是否為必要條件
  final bool volumeRequired;

  /// 收長上影
  final bool closeWithLongUpperShadow;
  /// 收長上影是否為必要條件
  final bool closeWithLongUpperShadowRequired;

  /// 收長下影
  final bool closeWithLongLowerShadow;
  /// 收長下影是否為必要條件
  final bool closeWithLongLowerShadowRequired;

  /// 在[aTurnInPeriod]K棒裡面的A轉
  final int? aTurnInPeriod;
  final bool aTurn;
  /// A轉是否為必要條件
  final bool aTurnRequired;
  /// A轉是否在今高
  final bool aTurnAtHigh;

  /// 在[vTurnInPeriod]K棒裡面的V轉
  final int? vTurnInPeriod;
  final bool vTurn;
  /// V轉是否為必要條件
  final bool vTurnRequired;
  /// V轉是否在今低
  final bool vTurnAtLow;

  /// 多方攻擊
  final bool longAttack;
  final int? longAttackPoint;
  /// 多方攻擊是否為必要條件
  final bool longAttackRequired;

  /// 空方攻擊
  final bool shortAttack;
  final int? shortAttackPoint;
  /// 空方攻擊是否為必要條件
  final bool shortAttackRequired;

  KeyCandleState({
    required this.title,
    this.kPeriod,
    this.expand = true,
    this.notice = true,
    this.triggerType = TriggerType.onClose,
    this.keyVolume,
    this.considerVolume = false,
    this.volumeRequired = false,
    this.closeWithLongUpperShadow = false,
    this.closeWithLongUpperShadowRequired = false,
    this.closeWithLongLowerShadow = false,
    this.closeWithLongLowerShadowRequired = false,
    this.aTurnInPeriod = 10,
    this.aTurn = false,
    this.aTurnRequired = false,
    this.aTurnAtHigh = true,
    this.vTurnInPeriod = 10,
    this.vTurn = false,
    this.vTurnRequired = false,
    this.vTurnAtLow = true,
    this.longAttack = false,
    this.longAttackPoint = 20,
    this.longAttackRequired = false,
    this.shortAttack = false,
    this.shortAttackPoint = 20,
    this.shortAttackRequired = false,
  });

  factory KeyCandleState.fromJson(Map<String, dynamic> json) =>
      _$KeyCandleStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KeyCandleStateToJson(this);
}

enum TriggerType {
  onClose,      // 收盤才觸發
  onceInPeriod  // 一個週期一次，有達標就觸發
}
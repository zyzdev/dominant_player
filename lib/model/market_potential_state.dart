import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'market_potential_state.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class MarketPotentialState {
  /// 上一次日盤高點
  final int preHigh;

  /// 上一次日盤低點
  final int preLow;

  /// 上一次日盤開盤5分K，累計交易金額
  final double preCumulativeTransactionAmount;

  /// 開盤價
  final int open;

  /// 5分K，累計交易金額
  final double cumulativeTransactionAmount;


  factory MarketPotentialState.init() => MarketPotentialState(
        preHigh: 0,
        open: 0,
        preLow: 0,
        preCumulativeTransactionAmount: 0,
        cumulativeTransactionAmount: 0,
      );

  factory MarketPotentialState.fromJson(Map<String, dynamic> json) =>
      _$MarketPotentialStateFromJson(json);

  MarketPotentialState({
    required this.preHigh,
    required this.preLow,
    required this.preCumulativeTransactionAmount,
    required this.open,
    required this.cumulativeTransactionAmount,
  });

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MarketPotentialStateToJson(this);
}

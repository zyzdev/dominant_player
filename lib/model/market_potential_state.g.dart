// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_potential_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MarketPotentialStateCWProxy {
  MarketPotentialState preHigh(int preHigh);

  MarketPotentialState preLow(int preLow);

  MarketPotentialState preCumulativeTransactionAmount(
      double preCumulativeTransactionAmount);

  MarketPotentialState open(int open);

  MarketPotentialState cumulativeTransactionAmount(
      double cumulativeTransactionAmount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MarketPotentialState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MarketPotentialState(...).copyWith(id: 12, name: "My name")
  /// ````
  MarketPotentialState call({
    int? preHigh,
    int? preLow,
    double? preCumulativeTransactionAmount,
    int? open,
    double? cumulativeTransactionAmount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMarketPotentialState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMarketPotentialState.copyWith.fieldName(...)`
class _$MarketPotentialStateCWProxyImpl
    implements _$MarketPotentialStateCWProxy {
  const _$MarketPotentialStateCWProxyImpl(this._value);

  final MarketPotentialState _value;

  @override
  MarketPotentialState preHigh(int preHigh) => this(preHigh: preHigh);

  @override
  MarketPotentialState preLow(int preLow) => this(preLow: preLow);

  @override
  MarketPotentialState preCumulativeTransactionAmount(
          double preCumulativeTransactionAmount) =>
      this(preCumulativeTransactionAmount: preCumulativeTransactionAmount);

  @override
  MarketPotentialState open(int open) => this(open: open);

  @override
  MarketPotentialState cumulativeTransactionAmount(
          double cumulativeTransactionAmount) =>
      this(cumulativeTransactionAmount: cumulativeTransactionAmount);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MarketPotentialState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MarketPotentialState(...).copyWith(id: 12, name: "My name")
  /// ````
  MarketPotentialState call({
    Object? preHigh = const $CopyWithPlaceholder(),
    Object? preLow = const $CopyWithPlaceholder(),
    Object? preCumulativeTransactionAmount = const $CopyWithPlaceholder(),
    Object? open = const $CopyWithPlaceholder(),
    Object? cumulativeTransactionAmount = const $CopyWithPlaceholder(),
  }) {
    return MarketPotentialState(
      preHigh: preHigh == const $CopyWithPlaceholder() || preHigh == null
          ? _value.preHigh
          // ignore: cast_nullable_to_non_nullable
          : preHigh as int,
      preLow: preLow == const $CopyWithPlaceholder() || preLow == null
          ? _value.preLow
          // ignore: cast_nullable_to_non_nullable
          : preLow as int,
      preCumulativeTransactionAmount:
          preCumulativeTransactionAmount == const $CopyWithPlaceholder() ||
                  preCumulativeTransactionAmount == null
              ? _value.preCumulativeTransactionAmount
              // ignore: cast_nullable_to_non_nullable
              : preCumulativeTransactionAmount as double,
      open: open == const $CopyWithPlaceholder() || open == null
          ? _value.open
          // ignore: cast_nullable_to_non_nullable
          : open as int,
      cumulativeTransactionAmount:
          cumulativeTransactionAmount == const $CopyWithPlaceholder() ||
                  cumulativeTransactionAmount == null
              ? _value.cumulativeTransactionAmount
              // ignore: cast_nullable_to_non_nullable
              : cumulativeTransactionAmount as double,
    );
  }
}

extension $MarketPotentialStateCopyWith on MarketPotentialState {
  /// Returns a callable class that can be used as follows: `instanceOfMarketPotentialState.copyWith(...)` or like so:`instanceOfMarketPotentialState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MarketPotentialStateCWProxy get copyWith =>
      _$MarketPotentialStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketPotentialState _$MarketPotentialStateFromJson(
        Map<String, dynamic> json) =>
    MarketPotentialState(
      preHigh: json['preHigh'] as int,
      preLow: json['preLow'] as int,
      preCumulativeTransactionAmount:
          (json['preCumulativeTransactionAmount'] as num).toDouble(),
      open: json['open'] as int,
      cumulativeTransactionAmount:
          (json['cumulativeTransactionAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$MarketPotentialStateToJson(
        MarketPotentialState instance) =>
    <String, dynamic>{
      'preHigh': instance.preHigh,
      'preLow': instance.preLow,
      'preCumulativeTransactionAmount': instance.preCumulativeTransactionAmount,
      'open': instance.open,
      'cumulativeTransactionAmount': instance.cumulativeTransactionAmount,
    };

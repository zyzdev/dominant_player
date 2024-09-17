// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spy_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SpyStateCWProxy {
  SpyState daySpy(Spy daySpy);

  SpyState nightSpy(Spy nightSpy);

  SpyState considerKeyValue(Map<String, bool> considerKeyValue);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SpyState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SpyState(...).copyWith(id: 12, name: "My name")
  /// ````
  SpyState call({
    Spy? daySpy,
    Spy? nightSpy,
    Map<String, bool>? considerKeyValue,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSpyState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSpyState.copyWith.fieldName(...)`
class _$SpyStateCWProxyImpl implements _$SpyStateCWProxy {
  const _$SpyStateCWProxyImpl(this._value);

  final SpyState _value;

  @override
  SpyState daySpy(Spy daySpy) => this(daySpy: daySpy);

  @override
  SpyState nightSpy(Spy nightSpy) => this(nightSpy: nightSpy);

  @override
  SpyState considerKeyValue(Map<String, bool> considerKeyValue) =>
      this(considerKeyValue: considerKeyValue);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SpyState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SpyState(...).copyWith(id: 12, name: "My name")
  /// ````
  SpyState call({
    Object? daySpy = const $CopyWithPlaceholder(),
    Object? nightSpy = const $CopyWithPlaceholder(),
    Object? considerKeyValue = const $CopyWithPlaceholder(),
  }) {
    return SpyState(
      daySpy: daySpy == const $CopyWithPlaceholder() || daySpy == null
          ? _value.daySpy
          // ignore: cast_nullable_to_non_nullable
          : daySpy as Spy,
      nightSpy: nightSpy == const $CopyWithPlaceholder() || nightSpy == null
          ? _value.nightSpy
          // ignore: cast_nullable_to_non_nullable
          : nightSpy as Spy,
      considerKeyValue: considerKeyValue == const $CopyWithPlaceholder() ||
              considerKeyValue == null
          ? _value.considerKeyValue
          // ignore: cast_nullable_to_non_nullable
          : considerKeyValue as Map<String, bool>,
    );
  }
}

extension $SpyStateCopyWith on SpyState {
  /// Returns a callable class that can be used as follows: `instanceOfSpyState.copyWith(...)` or like so:`instanceOfSpyState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SpyStateCWProxy get copyWith => _$SpyStateCWProxyImpl(this);
}

abstract class _$SpyCWProxy {
  Spy isDay(bool isDay);

  Spy high(int? high);

  Spy low(int? low);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Spy(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Spy(...).copyWith(id: 12, name: "My name")
  /// ````
  Spy call({
    bool? isDay,
    int? high,
    int? low,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSpy.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSpy.copyWith.fieldName(...)`
class _$SpyCWProxyImpl implements _$SpyCWProxy {
  const _$SpyCWProxyImpl(this._value);

  final Spy _value;

  @override
  Spy isDay(bool isDay) => this(isDay: isDay);

  @override
  Spy high(int? high) => this(high: high);

  @override
  Spy low(int? low) => this(low: low);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Spy(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Spy(...).copyWith(id: 12, name: "My name")
  /// ````
  Spy call({
    Object? isDay = const $CopyWithPlaceholder(),
    Object? high = const $CopyWithPlaceholder(),
    Object? low = const $CopyWithPlaceholder(),
  }) {
    return Spy(
      isDay: isDay == const $CopyWithPlaceholder() || isDay == null
          ? _value.isDay
          // ignore: cast_nullable_to_non_nullable
          : isDay as bool,
      high: high == const $CopyWithPlaceholder()
          ? _value.high
          // ignore: cast_nullable_to_non_nullable
          : high as int?,
      low: low == const $CopyWithPlaceholder()
          ? _value.low
          // ignore: cast_nullable_to_non_nullable
          : low as int?,
    );
  }
}

extension $SpyCopyWith on Spy {
  /// Returns a callable class that can be used as follows: `instanceOfSpy.copyWith(...)` or like so:`instanceOfSpy.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SpyCWProxy get copyWith => _$SpyCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpyState _$SpyStateFromJson(Map<String, dynamic> json) => SpyState(
      daySpy: Spy.fromJson(json['daySpy'] as Map<String, dynamic>),
      nightSpy: Spy.fromJson(json['nightSpy'] as Map<String, dynamic>),
      considerKeyValue: Map<String, bool>.from(json['considerKeyValue'] as Map),
    );

Map<String, dynamic> _$SpyStateToJson(SpyState instance) => <String, dynamic>{
      'daySpy': instance.daySpy.toJson(),
      'nightSpy': instance.nightSpy.toJson(),
      'considerKeyValue': instance.considerKeyValue,
    };

Spy _$SpyFromJson(Map<String, dynamic> json) => Spy(
      isDay: json['isDay'] as bool,
      high: json['high'] as int?,
      low: json['low'] as int?,
    );

Map<String, dynamic> _$SpyToJson(Spy instance) => <String, dynamic>{
      'isDay': instance.isDay,
      'high': instance.high,
      'low': instance.low,
    };

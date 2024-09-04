// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_chart_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$KeyChartStateCWProxy {
  KeyChartState title(String title);

  KeyChartState kPeriod(int kPeriod);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KeyChartState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KeyChartState(...).copyWith(id: 12, name: "My name")
  /// ````
  KeyChartState call({
    String? title,
    int? kPeriod,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfKeyChartState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfKeyChartState.copyWith.fieldName(...)`
class _$KeyChartStateCWProxyImpl implements _$KeyChartStateCWProxy {
  const _$KeyChartStateCWProxyImpl(this._value);

  final KeyChartState _value;

  @override
  KeyChartState title(String title) => this(title: title);

  @override
  KeyChartState kPeriod(int kPeriod) => this(kPeriod: kPeriod);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KeyChartState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KeyChartState(...).copyWith(id: 12, name: "My name")
  /// ````
  KeyChartState call({
    Object? title = const $CopyWithPlaceholder(),
    Object? kPeriod = const $CopyWithPlaceholder(),
  }) {
    return KeyChartState(
      title: title == const $CopyWithPlaceholder() || title == null
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      kPeriod: kPeriod == const $CopyWithPlaceholder() || kPeriod == null
          ? _value.kPeriod
          // ignore: cast_nullable_to_non_nullable
          : kPeriod as int,
    );
  }
}

extension $KeyChartStateCopyWith on KeyChartState {
  /// Returns a callable class that can be used as follows: `instanceOfKeyChartState.copyWith(...)` or like so:`instanceOfKeyChartState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$KeyChartStateCWProxy get copyWith => _$KeyChartStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeyChartState _$KeyChartStateFromJson(Map<String, dynamic> json) =>
    KeyChartState(
      title: json['title'] as String,
      kPeriod: (json['kPeriod'] as num).toInt(),
    );

Map<String, dynamic> _$KeyChartStateToJson(KeyChartState instance) =>
    <String, dynamic>{
      'title': instance.title,
      'kPeriod': instance.kPeriod,
    };

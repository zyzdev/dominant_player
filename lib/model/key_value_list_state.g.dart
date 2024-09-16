// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_value_list_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$KeyValueListStateCWProxy {
  KeyValueListState current(int? current);

  KeyValueListState autoNotice(bool autoNotice);

  KeyValueListState noticeDis(int noticeDis);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KeyValueListState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KeyValueListState(...).copyWith(id: 12, name: "My name")
  /// ````
  KeyValueListState call({
    int? current,
    bool? autoNotice,
    int? noticeDis,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfKeyValueListState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfKeyValueListState.copyWith.fieldName(...)`
class _$KeyValueListStateCWProxyImpl implements _$KeyValueListStateCWProxy {
  const _$KeyValueListStateCWProxyImpl(this._value);

  final KeyValueListState _value;

  @override
  KeyValueListState current(int? current) => this(current: current);

  @override
  KeyValueListState autoNotice(bool autoNotice) => this(autoNotice: autoNotice);

  @override
  KeyValueListState noticeDis(int noticeDis) => this(noticeDis: noticeDis);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KeyValueListState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KeyValueListState(...).copyWith(id: 12, name: "My name")
  /// ````
  KeyValueListState call({
    Object? current = const $CopyWithPlaceholder(),
    Object? autoNotice = const $CopyWithPlaceholder(),
    Object? noticeDis = const $CopyWithPlaceholder(),
  }) {
    return KeyValueListState(
      current: current == const $CopyWithPlaceholder()
          ? _value.current
          // ignore: cast_nullable_to_non_nullable
          : current as int?,
      autoNotice:
          autoNotice == const $CopyWithPlaceholder() || autoNotice == null
              ? _value.autoNotice
              // ignore: cast_nullable_to_non_nullable
              : autoNotice as bool,
      noticeDis: noticeDis == const $CopyWithPlaceholder() || noticeDis == null
          ? _value.noticeDis
          // ignore: cast_nullable_to_non_nullable
          : noticeDis as int,
    );
  }
}

extension $KeyValueListStateCopyWith on KeyValueListState {
  /// Returns a callable class that can be used as follows: `instanceOfKeyValueListState.copyWith(...)` or like so:`instanceOfKeyValueListState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$KeyValueListStateCWProxy get copyWith =>
      _$KeyValueListStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeyValueListState _$KeyValueListStateFromJson(Map<String, dynamic> json) =>
    KeyValueListState(
      current: json['current'] as int?,
      autoNotice: json['autoNotice'] as bool? ?? true,
      noticeDis: json['noticeDis'] as int? ?? 10,
    );

Map<String, dynamic> _$KeyValueListStateToJson(KeyValueListState instance) =>
    <String, dynamic>{
      'current': instance.current,
      'autoNotice': instance.autoNotice,
      'noticeDis': instance.noticeDis,
    };

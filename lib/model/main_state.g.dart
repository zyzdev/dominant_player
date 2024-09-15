// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MainStateCWProxy {
  MainState autoNotice(bool autoNotice);

  MainState noticeDis(int noticeDis);

  MainState current(int? current);

  MainState spyExpand(bool spyExpand);

  MainState sensitivitySpaceExpand(bool sensitivitySpaceExpand);

  MainState keyValuesExpand(bool keyValuesExpand);

  MainState keyChartNoticeExpand(bool keyChartNoticeExpand);

  MainState notificationWallExpand(bool notificationWallExpand);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MainState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MainState(...).copyWith(id: 12, name: "My name")
  /// ````
  MainState call({
    bool? autoNotice,
    int? noticeDis,
    int? current,
    bool? spyExpand,
    bool? sensitivitySpaceExpand,
    bool? keyValuesExpand,
    bool? keyChartNoticeExpand,
    bool? notificationWallExpand,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMainState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMainState.copyWith.fieldName(...)`
class _$MainStateCWProxyImpl implements _$MainStateCWProxy {
  const _$MainStateCWProxyImpl(this._value);

  final MainState _value;

  @override
  MainState autoNotice(bool autoNotice) => this(autoNotice: autoNotice);

  @override
  MainState noticeDis(int noticeDis) => this(noticeDis: noticeDis);

  @override
  MainState current(int? current) => this(current: current);

  @override
  MainState spyExpand(bool spyExpand) => this(spyExpand: spyExpand);

  @override
  MainState sensitivitySpaceExpand(bool sensitivitySpaceExpand) =>
      this(sensitivitySpaceExpand: sensitivitySpaceExpand);

  @override
  MainState keyValuesExpand(bool keyValuesExpand) =>
      this(keyValuesExpand: keyValuesExpand);

  @override
  MainState keyChartNoticeExpand(bool keyChartNoticeExpand) =>
      this(keyChartNoticeExpand: keyChartNoticeExpand);

  @override
  MainState notificationWallExpand(bool notificationWallExpand) =>
      this(notificationWallExpand: notificationWallExpand);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MainState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MainState(...).copyWith(id: 12, name: "My name")
  /// ````
  MainState call({
    Object? autoNotice = const $CopyWithPlaceholder(),
    Object? noticeDis = const $CopyWithPlaceholder(),
    Object? current = const $CopyWithPlaceholder(),
    Object? spyExpand = const $CopyWithPlaceholder(),
    Object? sensitivitySpaceExpand = const $CopyWithPlaceholder(),
    Object? keyValuesExpand = const $CopyWithPlaceholder(),
    Object? keyChartNoticeExpand = const $CopyWithPlaceholder(),
    Object? notificationWallExpand = const $CopyWithPlaceholder(),
  }) {
    return MainState(
      autoNotice:
          autoNotice == const $CopyWithPlaceholder() || autoNotice == null
              ? _value.autoNotice
              // ignore: cast_nullable_to_non_nullable
              : autoNotice as bool,
      noticeDis: noticeDis == const $CopyWithPlaceholder() || noticeDis == null
          ? _value.noticeDis
          // ignore: cast_nullable_to_non_nullable
          : noticeDis as int,
      current: current == const $CopyWithPlaceholder()
          ? _value.current
          // ignore: cast_nullable_to_non_nullable
          : current as int?,
      spyExpand: spyExpand == const $CopyWithPlaceholder() || spyExpand == null
          ? _value.spyExpand
          // ignore: cast_nullable_to_non_nullable
          : spyExpand as bool,
      sensitivitySpaceExpand:
          sensitivitySpaceExpand == const $CopyWithPlaceholder() ||
                  sensitivitySpaceExpand == null
              ? _value.sensitivitySpaceExpand
              // ignore: cast_nullable_to_non_nullable
              : sensitivitySpaceExpand as bool,
      keyValuesExpand: keyValuesExpand == const $CopyWithPlaceholder() ||
              keyValuesExpand == null
          ? _value.keyValuesExpand
          // ignore: cast_nullable_to_non_nullable
          : keyValuesExpand as bool,
      keyChartNoticeExpand:
          keyChartNoticeExpand == const $CopyWithPlaceholder() ||
                  keyChartNoticeExpand == null
              ? _value.keyChartNoticeExpand
              // ignore: cast_nullable_to_non_nullable
              : keyChartNoticeExpand as bool,
      notificationWallExpand:
          notificationWallExpand == const $CopyWithPlaceholder() ||
                  notificationWallExpand == null
              ? _value.notificationWallExpand
              // ignore: cast_nullable_to_non_nullable
              : notificationWallExpand as bool,
    );
  }
}

extension $MainStateCopyWith on MainState {
  /// Returns a callable class that can be used as follows: `instanceOfMainState.copyWith(...)` or like so:`instanceOfMainState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MainStateCWProxy get copyWith => _$MainStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainState _$MainStateFromJson(Map<String, dynamic> json) => MainState(
      autoNotice: json['autoNotice'] as bool? ?? true,
      noticeDis: json['noticeDis'] as int? ?? 10,
      current: json['current'] as int?,
      spyExpand: json['spyExpand'] as bool? ?? true,
      sensitivitySpaceExpand: json['sensitivitySpaceExpand'] as bool? ?? true,
      keyValuesExpand: json['keyValuesExpand'] as bool? ?? true,
      keyChartNoticeExpand: json['keyChartNoticeExpand'] as bool? ?? true,
      notificationWallExpand: json['notificationWallExpand'] as bool? ?? true,
    );

Map<String, dynamic> _$MainStateToJson(MainState instance) => <String, dynamic>{
      'autoNotice': instance.autoNotice,
      'noticeDis': instance.noticeDis,
      'current': instance.current,
      'spyExpand': instance.spyExpand,
      'sensitivitySpaceExpand': instance.sensitivitySpaceExpand,
      'keyValuesExpand': instance.keyValuesExpand,
      'keyChartNoticeExpand': instance.keyChartNoticeExpand,
      'notificationWallExpand': instance.notificationWallExpand,
    };

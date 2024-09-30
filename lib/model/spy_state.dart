import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'key_value.dart';

import 'package:dominant_player/service/spy_info.dart' as spy_info;

part 'spy_state.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class SpyState {
  SpyState({
    required this.daySpy,
    required this.nightSpy,
    required this.considerKeyValue,
  });

  factory SpyState.init() {
    Spy daySpy = Spy(isDay: true);
    Spy nightSpy = Spy(isDay: false);
    List<MapEntry<KeyValue, num?>> spyValues(Spy spy) {
      List<MapEntry<KeyValue, num?>> keyValues = [
        MapEntry(KeyValue.high, spy.high),
        MapEntry(KeyValue.low, spy.low),
        MapEntry(KeyValue.range, spy.range),
        MapEntry(KeyValue.rangeDiv4, spy.rangeDiv4),
        MapEntry(KeyValue.highCost, spy.highCost),
        MapEntry(KeyValue.middleCost, spy.middleCost),
        MapEntry(KeyValue.lowCost, spy.lowCost),
        MapEntry(KeyValue.superPress, spy.superPress),
        MapEntry(KeyValue.absolutePress, spy.absolutePress),
        MapEntry(KeyValue.nestPress, spy.nestPress),
        MapEntry(KeyValue.nestSupport, spy.nestSupport),
        MapEntry(KeyValue.absoluteSupport, spy.absoluteSupport),
        MapEntry(KeyValue.superSupport, spy.superSupport),
      ];
      return keyValues;
    }

    final Map<String, bool> considerKeyValue = {};
    [daySpy, nightSpy].expand((spy) {
      // 標題加入日夜盤
      return spyValues(spy)
          // 移除點差和點差/4
          .where((element) =>
              element.key != KeyValue.range &&
              element.key != KeyValue.rangeDiv4)
          .map((e) => '${spy.isDay ? '日' : '夜'}盤，${e.key.title}');
    }).forEach((element) {
      considerKeyValue[element] = true;
    });

    return SpyState(
      daySpy: daySpy,
      nightSpy: nightSpy,
      considerKeyValue: considerKeyValue,
    );
  }

  /// 日盤SPY
  Spy daySpy;

  /// 夜盤SPY
  Spy nightSpy;

  Map<String, bool> considerKeyValue;

  factory SpyState.fromJson(Map<String, dynamic> json) => _$SpyStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SpyStateToJson(this);
}

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Spy {
  bool isDay;

  String get spyDate {
    return DateFormat('MM/dd').format(spy_info.spyDate(isDay));
  }

  /// 高點
  final int? high;

  /// 低點
  final int? low;

  /// 點差
  int? get range => high != null && low != null ? high! - low! : null;

  /// 點差/4
  double? get rangeDiv4 => range != null ? range! / 4 : null;

  /// 超漲
  num? get superPress => high != null && rangeDiv4 != null && range != null
      ? high! - rangeDiv4! + range!
      : null;

  /// 壓二
  num? get absolutePress =>
      superPress != null && rangeDiv4 != null ? superPress! - rangeDiv4! : null;

  /// 壓一
  num? get nestPress => absolutePress != null && rangeDiv4 != null
      ? absolutePress! - rangeDiv4!
      : null;

  /// 撐一
  double? get nestSupport => absoluteSupport != null && rangeDiv4 != null
      ? absoluteSupport! + rangeDiv4!
      : null;

  /// 撐二
  double? get absoluteSupport => superSupport != null && rangeDiv4 != null
      ? superSupport! + rangeDiv4!
      : null;

  /// 超跌
  double? get superSupport => low != null && rangeDiv4 != null && range != null
      ? low! + rangeDiv4! - range!
      : null;

  /// 高成本區
  double? get highCost =>
      high != null && rangeDiv4 != null ? high! - rangeDiv4! : null;

  /// 中成本區
  double? get middleCost =>
      high != null && low != null ? (high! + low!) / 2 : null;

  /// 低成本區
  double? get lowCost =>
      low != null && rangeDiv4 != null ? low! + rangeDiv4! : null;

  Spy({required this.isDay, this.high, this.low});

  factory Spy.fromJson(Map<String, dynamic> json) => _$SpyFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SpyToJson(this);
}

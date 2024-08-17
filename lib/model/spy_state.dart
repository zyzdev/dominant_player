import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'spy_state.g.dart';

/// 一股腦兒之SPY理論
/// 【當日高點+當日低點 ÷ 2】＝中關(範圍)
/// 【震幅÷4】＝4分價(4等分)
/// 【高點-低點】＝震幅
/// 【P(壓力超漲區)】＝高點-4等分+震幅
/// 【S(支撐超跌區)】＝低點+4等分-震幅
/// 高成本區＝當日高點-4等分
/// 低成本區＝當日低點+4等分
/// 1/2壓力＝P(超漲)-4等分
/// 1/4壓力＝1/2壓力–4等分
/// 1/2支撐＝S(超跌)+4等分
/// 1/4支撐＝1/2支撐+4等分

@JsonSerializable(explicitToJson: true)
@CopyWith()
class SpyState {
  SpyState({
    this.current,
    this.high,
    this.low ,
    required this.daySensitivitySpace15,
    required this.daySensitivitySpace30,
    required this.nightSensitivitySpace15,
    required this.nightSensitivitySpace30,
  });

  factory SpyState.init() {
    return SpyState(
      daySensitivitySpace15: SensitivitySpace(),
      daySensitivitySpace30: SensitivitySpace(),
      nightSensitivitySpace15: SensitivitySpace(),
      nightSensitivitySpace30: SensitivitySpace(),
    );
  }

  String get today => DateFormat('M/dd').format(DateTime.now());

  /// 目前點數
  final int? current;

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
  double? get absoluteSupport => supperSupport != null && rangeDiv4 != null
      ? supperSupport! + rangeDiv4!
      : null;

  /// 超跌
  double? get supperSupport => low != null && rangeDiv4 != null && range != null
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

  /// 日盤靈敏度空間
  /// 15分K靈敏度空間
  final SensitivitySpace daySensitivitySpace15;

  /// 30分K靈敏度空間
  final SensitivitySpace daySensitivitySpace30;

  /// 夜盤靈敏度空間
  /// 15分K靈敏度空間
  final SensitivitySpace nightSensitivitySpace15;

  /// 30分K靈敏度空間
  final SensitivitySpace nightSensitivitySpace30;

  factory SpyState.fromJson(Map<String, dynamic> json) =>
      _$SpyStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SpyStateToJson(this);
}

@JsonSerializable(explicitToJson: true)
@CopyWith()
class SensitivitySpace {
  SensitivitySpace(
      {this.longHigh, this.longLow, this.shortHigh, this.shortLow});

  factory SensitivitySpace.init() => SensitivitySpace(
      longHigh: null, longLow: null, shortHigh: null, shortLow: null);

  /// 空間偏移量
  static const int _spaceOffset = 20;

  /// 最大多方邏輯高點
  final int? longHigh;

  /// 最大多方邏輯低點
  final int? longLow;

  /// 分K最大多方邏輯中關
  double? get longMiddle =>
      longHigh != null && longLow != null ? (longHigh! + longLow!) / 2 : null;

  /// 分K最大多方邏輯攻擊點
  int? get longAttack => longHigh != null ? longHigh! + _spaceOffset : null;

  /// 分K最大多方邏輯防守點
  int? get longDefense => longLow != null ? longLow! - _spaceOffset : null;

  /// 分K最大空方邏輯高點
  final int? shortHigh;

  /// 分K最大空方邏輯低點
  final int? shortLow;

  /// 分K最大空方邏輯中關
  double? get shortMiddle => shortHigh != null && shortLow != null
      ? (shortHigh! + shortLow!) / 2
      : null;

  /// 分K最大空方邏輯攻擊點
  int? get maxShortAttack => shortLow != null ? shortLow! - _spaceOffset : null;

  /// 分K最大空方邏輯防守點
  int? get shortDefense => shortHigh != null ? shortHigh! + _spaceOffset : null;

  factory SensitivitySpace.fromJson(Map<String, dynamic> json) =>
      _$SensitivitySpaceFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SensitivitySpaceToJson(this);
}

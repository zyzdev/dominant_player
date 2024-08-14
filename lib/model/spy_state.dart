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
    this.high = 0,
    this.low = 0,
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

  String get today => DateFormat('yyyy/M/dd').format(DateTime.now());

  /// 高點
  final int high;

  /// 低點
  final int low;

  /// 中關
  late final int D = (high + low).round();

  /// 點差
  late final int dis = high - low;

  /// 點差/4
  late final int disDiv4 = (dis / 4).round();

  /// 超漲
  late final int superPress = high - disDiv4 + dis;

  /// 壓二
  late final int press2 = superPress - disDiv4;

  /// 壓一
  late final int press1 = press2 - disDiv4;

  /// 撐一
  late final int support1 = support2 + disDiv4;

  /// 撐二
  late final int support2 = superSupport + disDiv4;

  /// 超跌
  late final int superSupport = low + disDiv4 - dis;

  /// 高成本區
  late final int hCost = high - disDiv4;

  /// 中成本區
  late final int mCost = ((high + low) / 2).round();

  /// 低成本區
  late final int lCost = low + disDiv4;

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
  SensitivitySpace({
    this.maxLongHigh = 0,
    this.maxLongLow = 0,
    this.maxShortHigh = 0,
    this.maxShortLow = 0,
  });

  /// 空間偏移量
  static const int _spaceOffset = 20;

  /// 最大多方邏輯高點
  final int maxLongHigh;

  /// 最大多方邏輯低點
  final int maxLongLow;

  /// 分K最大多方邏輯中關
  int get maxLongMiddle => ((maxLongHigh + maxLongLow) / 2).round();

  /// 分K最大多方邏輯攻擊點
  int get maxLongAttack => maxLongHigh + _spaceOffset;

  /// 分K最大多方邏輯防守點
  int get maxLongDefense => maxLongLow - _spaceOffset;

  /// 分K最大空方邏輯高點
  final int maxShortHigh;

  /// 分K最大空方邏輯低點
  final int maxShortLow;

  /// 分K最大空方邏輯中關
  int get maxShortMiddle => ((maxShortHigh + maxShortLow) / 2).round();

  /// 分K最大空方邏輯攻擊點
  int get maxShortAttack => maxShortLow - _spaceOffset;

  /// 分K最大空方邏輯防守點
  int get maxShortDefense => maxShortHigh + _spaceOffset;

  factory SensitivitySpace.fromJson(Map<String, dynamic> json) =>
      _$SensitivitySpaceFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SensitivitySpaceToJson(this);
}

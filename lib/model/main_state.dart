import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dominant_player/model/key_value.dart';
import 'package:dominant_player/model/spy_state.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'main_state.g.dart';

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
class MainState {
  MainState({
    this.autoNotice = true,
    this.noticeDis = 10,
    this.current,
    this.spyExpand = true,
    this.sensitivitySpaceExpand = true,
    this.keyValuesExpand = true,
    this.sensitivitySpaceWidgetIndex = SensitivitySpaceType.values,
    this.daySensitivitySpaceExpand = true,
    required this.daySensitivitySpace15,
    required this.daySensitivitySpace30,
    this.nightSensitivitySpaceExpand = true,
    required this.nightSensitivitySpace15,
    required this.nightSensitivitySpace30,
    required this.considerKeyValue,
    this.customizeSensitivitySpaceExpand = true,
    required this.customizeSensitivitySpaces,
    this.customizeValuesExpand = true,
    required this.customizeValues,
    this.keyChartNoticeExpand = true,
    this.notificationWallExpand = true,
  });

  factory MainState.init() {
    return MainState(
        daySensitivitySpace15: SensitivitySpace(),
        daySensitivitySpace30: SensitivitySpace(),
        nightSensitivitySpace15: SensitivitySpace(),
        nightSensitivitySpace30: SensitivitySpace(),
        considerKeyValue: {
          for (var element in KeyValue.values) element.title: true
        },
        customizeSensitivitySpaces: [
          CustomizeSensitivitySpace(
              direction: Direction.customizeLong, title:  Direction.customizeLong.typeName)
        ],
        customizeValues: [
          CustomizeValue(title: '自定義關鍵價')
        ]);
  }

  /// 接近關鍵價，自動提醒
  @JsonKey(defaultValue: true)
  final bool autoNotice;

  /// 接近關鍵價[noticeDis]，自動提醒
  @JsonKey(defaultValue: 10)
  final int noticeDis;

  /// 目前點數
  final int? current;

  /// SPY是否展開
  @JsonKey(defaultValue: true)
  final bool spyExpand;

  /// 靈敏度空間是否展開
  @JsonKey(defaultValue: true)
  final bool sensitivitySpaceExpand;

  /// 關鍵價位列表是否展開
  @JsonKey(defaultValue: true)
  final bool keyValuesExpand;

  /// 靈敏度空間排序
  List<SensitivitySpaceType> sensitivitySpaceWidgetIndex;

  /// 日盤靈敏度空間
  /// 是否展開
  final bool daySensitivitySpaceExpand;

  /// 15分K靈敏度空間
  final SensitivitySpace daySensitivitySpace15;

  /// 30分K靈敏度空間
  final SensitivitySpace daySensitivitySpace30;

  /// 夜盤靈敏度空間
  /// 是否展開
  final bool nightSensitivitySpaceExpand;

  /// 15分K靈敏度空間
  final SensitivitySpace nightSensitivitySpace15;

  /// 30分K靈敏度空間
  final SensitivitySpace nightSensitivitySpace30;

  /// 自定義靈敏度空間
  /// 是否展開
  final bool customizeSensitivitySpaceExpand;
  @JsonKey(defaultValue: [])
  List<CustomizeSensitivitySpace> customizeSensitivitySpaces;

  /// 自定義關鍵價
  /// 是否展開
  final bool customizeValuesExpand;
  @JsonKey(defaultValue: [])
  List<CustomizeValue> customizeValues;

  final Map<String, bool> considerKeyValue;

  /// 關鍵K棒警示
  /// 是否展開
  final bool keyChartNoticeExpand;

  /// 推播牆
  /// 是否展開
  final bool notificationWallExpand;
  factory MainState.fromJson(Map<String, dynamic> json) =>
      _$MainStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MainStateToJson(this);
}

@JsonSerializable(explicitToJson: true)
@CopyWith()
class SensitivitySpace {
  SensitivitySpace(
      {this.longHigh, this.longLow, this.shortHigh, this.shortLow});

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
  int? get shortAttack => shortLow != null ? shortLow! - _spaceOffset : null;

  /// 分K最大空方邏輯防守點
  int? get shortDefense => shortHigh != null ? shortHigh! + _spaceOffset : null;

  factory SensitivitySpace.fromJson(Map<String, dynamic> json) =>
      _$SensitivitySpaceFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SensitivitySpaceToJson(this);
}

enum SensitivitySpaceType { day, night, customize, value }

@JsonSerializable(explicitToJson: true)
@CopyWith()
class CustomizeSensitivitySpace {
  final String title;

  /// 空間偏移量
  static const int _spaceOffset = 20;

  final Direction direction;

  /// 高點
  final int? high;

  /// 低點
  final int? low;

  /// 攻擊title
  String get attackKeyTitle => '$title，攻擊';

  String get middleKeyTitle => '$title，中關';

  String get defenseKeyTitle => '$title，防守';

  /// 分K最大多方邏輯中關
  double? get middle => high != null && low != null ? (high! + low!) / 2 : null;

  /// 分K最大多方邏輯攻擊點
  int? get attack => direction.isLong
      ? high != null
      ? high! + _spaceOffset
      : null
      : low != null
      ? low! - _spaceOffset
      : null;

  /// 分K最大多方邏輯防守點
  int? get defense => direction.isLong
      ? low != null
      ? low! - _spaceOffset
      : null
      : high != null
      ? high! + _spaceOffset
      : null;

  CustomizeSensitivitySpace(
      {this.high, this.low, required this.direction, required this.title});

  factory CustomizeSensitivitySpace.fromJson(Map<String, dynamic> json) =>
      _$CustomizeSensitivitySpaceFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CustomizeSensitivitySpaceToJson(this);
}

@JsonSerializable(explicitToJson: true)
@CopyWith()
class CustomizeValue {
  final String title;
  final num? value;

  CustomizeValue({this.title = '自定義關鍵價', this.value});

  factory CustomizeValue.fromJson(Map<String, dynamic> json) =>
      _$CustomizeValueFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CustomizeValueToJson(this);
}

enum Direction {
  customizeLong,
  customizeShort,
  long15,
  long30,
  short15,
  short30,
}

extension DirectionName on Direction {
  bool get isLong =>
      this == Direction.long15 ||
          this == Direction.long30 ||
          this == Direction.customizeLong;

  String get typeName {
    switch (this) {
      case Direction.long15:
        return '15分多方最大邏輯';
      case Direction.long30:
        return '30分多方最大邏輯';
      case Direction.short15:
        return '15分空方最大邏輯';
      case Direction.short30:
        return '30分空方最大邏輯';
      case Direction.customizeLong:
        return '自定義多方邏輯';
      case Direction.customizeShort:
        return '自定義空方邏輯';
    }
  }
}

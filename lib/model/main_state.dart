import 'dart:ui';

import 'package:copy_with_extension/copy_with_extension.dart';
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
    this.fullScreen = false,
    this.screenWidth,
    this.screenHeight,
    this.screenX,
    this.screenY,
    this.marketPotentialExpand = true,
    this.spyExpand = true,
    this.sensitivitySpaceExpand = true,
    this.keyValuesExpand = true,
    this.keyChartNoticeExpand = true,
    this.notificationWallExpand = true,
  });

  /// 是否全螢幕，desktop only
  @JsonKey(defaultValue: false)
  final bool fullScreen;
  
  /// 螢幕尺寸寬度，desktop only
  final double? screenWidth;

  /// 螢幕尺寸高度，desktop only
  final double? screenHeight;

  /// 螢幕位置x，desktop only
  final double? screenX;

  /// 螢幕位置y，desktop only
  final double? screenY;

  /// 盤勢判斷是否展開
  @JsonKey(defaultValue: true)
  final bool marketPotentialExpand;

  /// SPY是否展開
  @JsonKey(defaultValue: true)
  final bool spyExpand;

  /// 靈敏度空間是否展開
  @JsonKey(defaultValue: true)
  final bool sensitivitySpaceExpand;

  /// 關鍵價位列表是否展開
  @JsonKey(defaultValue: true)
  final bool keyValuesExpand;

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


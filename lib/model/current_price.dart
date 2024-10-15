import 'dart:math';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_price.g.dart';

@JsonSerializable(explicitToJson: true)
class CurrentPriceResponse {
  @JsonKey(name: 'RtCode')
  final String rtCode;
  @JsonKey(name: 'RtMsg')
  final String rtMsg;
  @JsonKey(name: 'RtData')
  final RtData rtData;

  CurrentPriceResponse({
    required this.rtCode,
    required this.rtMsg,
    required this.rtData,
  });

  factory CurrentPriceResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentPriceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentPriceResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RtData {
  @JsonKey(name: 'Ticks')
  final List<List<String>> ticks;

  RtData({
    required this.ticks,
  });

  String get preTime => ticks[0][0];
  String get preOpen => ticks[0][1];
  String get preHigh => ticks[0][2];
  String get preLow => ticks[0][3];
  String get preClose => ticks[0][4];
  String get preVolume => ticks[0][5];


  String get curTime => ticks.length > 1 ? ticks[1][0] : preTime;
  String get curOpen =>  ticks.length > 1 ? ticks[1][1] : preOpen;
  String get curHigh => ticks.length > 1 ?  ticks[1][2] : preHigh;
  String get curLow =>  ticks.length > 1 ? ticks[1][3] : preLow;
  String get curClose => ticks.length > 1 ?  ticks[1][4] : preClose;
  String get curVolume =>  ticks.length > 1 ? ticks[1][5] : preVolume;
  factory RtData.fromJson(Map<String, dynamic> json) {
  return _$RtDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RtDataToJson(this);
}

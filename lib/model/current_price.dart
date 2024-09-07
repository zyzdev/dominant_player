import 'dart:math';

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


  String get curTime => ticks[1][0];
  String get curOpen => ticks[1][1];
  String get curHigh => ticks[1][2];
  String get curLow => ticks[1][3];
  String get curClose => ticks[1][4];
  String get curVolume => ticks[1][5];
  factory RtData.fromJson(Map<String, dynamic> json) {
    int cur = double.parse((json['Ticks'] as List<dynamic>)[1][4]).toInt();
    cur += Random().nextInt(100);
    json['Ticks'][1][4] = cur.toString();
  return _$RtDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RtDataToJson(this);
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentPriceResponse _$CurrentPriceResponseFromJson(
        Map<String, dynamic> json) =>
    CurrentPriceResponse(
      rtCode: json['RtCode'] as String,
      rtMsg: json['RtMsg'] as String,
      rtData: RtData.fromJson(json['RtData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurrentPriceResponseToJson(
        CurrentPriceResponse instance) =>
    <String, dynamic>{
      'RtCode': instance.rtCode,
      'RtMsg': instance.rtMsg,
      'RtData': instance.rtData.toJson(),
    };

RtData _$RtDataFromJson(Map<String, dynamic> json) => RtData(
      ticks: (json['Ticks'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );

Map<String, dynamic> _$RtDataToJson(RtData instance) => <String, dynamic>{
      'Ticks': instance.ticks,
    };

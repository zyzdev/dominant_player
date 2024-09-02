// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_months_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductMonthsInfoResponse _$ProductMonthsInfoResponseFromJson(
        Map<String, dynamic> json) =>
    ProductMonthsInfoResponse(
      rtCode: json['RtCode'] as String,
      rtMsg: json['RtMsg'] as String,
      rtData: RtData.fromJson(json['RtData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductMonthsInfoResponseToJson(
        ProductMonthsInfoResponse instance) =>
    <String, dynamic>{
      'RtCode': instance.rtCode,
      'RtMsg': instance.rtMsg,
      'RtData': instance.rtData.toJson(),
    };

RtData _$RtDataFromJson(Map<String, dynamic> json) => RtData(
      items: (json['Items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RtDataToJson(RtData instance) => <String, dynamic>{
      'Items': instance.items.map((e) => e.toJson()).toList(),
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      item: json['item'] as String,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'item': instance.item,
    };

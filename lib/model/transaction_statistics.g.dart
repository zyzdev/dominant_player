// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionStatisticsResponse _$TransactionStatisticsResponseFromJson(
        Map<String, dynamic> json) =>
    TransactionStatisticsResponse(
      stat: json['stat'] as String,
      date: json['date'] as String,
      title: json['title'] as String,
      hints: json['hints'] as String,
      fields:
          (json['fields'] as List<dynamic>).map((e) => e as String).toList(),
      data: (json['data'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );

Map<String, dynamic> _$TransactionStatisticsResponseToJson(
        TransactionStatisticsResponse instance) =>
    <String, dynamic>{
      'stat': instance.stat,
      'date': instance.date,
      'title': instance.title,
      'hints': instance.hints,
      'fields': instance.fields,
      'data': instance.data,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndexStatisticsResponse _$IndexStatisticsResponseFromJson(
        Map<String, dynamic> json) =>
    IndexStatisticsResponse(
      stat: json['stat'] as String,
      date: json['date'] as String,
      title: json['title'] as String,
      fields:
          (json['fields'] as List<dynamic>).map((e) => e as String).toList(),
      data: (json['data'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );

Map<String, dynamic> _$IndexStatisticsResponseToJson(
        IndexStatisticsResponse instance) =>
    <String, dynamic>{
      'stat': instance.stat,
      'date': instance.date,
      'title': instance.title,
      'fields': instance.fields,
      'data': instance.data,
    };

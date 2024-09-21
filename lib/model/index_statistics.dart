import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'index_statistics.g.dart'; // 修改为你实际的文件名

@JsonSerializable()
class IndexStatisticsResponse {
  final String stat;
  final String date;
  final String title;
  final List<String> fields;
  final List<List<String>> data;

  IndexStatisticsResponse({
    required this.stat,
    required this.date,
    required this.title,
    required this.fields,
    required this.data,
  });

  final NumberFormat _numberFormat = NumberFormat();

  @JsonKey(includeFromJson: false, includeToJson: false)
  late int openTaiexIndex =
      data.isNotEmpty ? _numberFormat.parse(data[1][1]).toInt() : 0;

  @JsonKey(includeFromJson: false, includeToJson: false)
  late int curTaiexIndex =
      data.isNotEmpty ? _numberFormat.parse(data.last[1]).toInt() : 0;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late int highTaiexIndex = data.isNotEmpty
      ? data
          .map((e) => _numberFormat.parse(e[1]).toInt())
          .reduce((value, element) => value > element ? value : element)
      : 0;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late int lowTaiexIndex = data.isNotEmpty
      ? data
          .map((e) => _numberFormat.parse(e[1]).toInt())
          .reduce((value, element) => value < element ? value : element)
      : 0;

  factory IndexStatisticsResponse.init() => IndexStatisticsResponse(
        fields: [],
        date: '',
        data: [],
        title: '',
        stat: '',
      );

  factory IndexStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$IndexStatisticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IndexStatisticsResponseToJson(this);
}

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_statistics.g.dart'; // 根据你的文件名来修改

@JsonSerializable()
class TransactionStatisticsResponse {
  final String stat;
  final String date;
  final String title;
  final String hints;
  final List<String> fields;
  final List<List<String>> data;

  /// 累計成交金額，單位百萬元
  int get cumulativeTransactionAmount =>
      data.isNotEmpty ? NumberFormat().parse(data.last.last).toInt() : 0;

  double get cumulativeTransactionAmountInBillions => cumulativeTransactionAmount / 100; // 1百萬 = 0.01億

  /// 取得五分K的累計成交金額
  /// 如果不到五分，則用目前累計成交金額
  /// 單位，億
  double first5KCumulativeTransactionAmount() {
    if(data.length < 60) return  cumulativeTransactionAmountInBillions;
    return NumberFormat().parse(data[59].last).toInt() / 100;
  }

  TransactionStatisticsResponse({
    required this.stat,
    required this.date,
    required this.title,
    required this.hints,
    required this.fields,
    required this.data,
  });

  factory TransactionStatisticsResponse.init() => TransactionStatisticsResponse(
        title: '',
        data: [],
        date: '',
        fields: [],
        hints: '',
        stat: '',
      );

  factory TransactionStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionStatisticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionStatisticsResponseToJson(this);
}

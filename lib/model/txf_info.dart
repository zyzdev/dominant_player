import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'txf_info.g.dart'; // 更改為你實際的 Dart 文件名

@JsonSerializable()
class TxfResponse {
  @JsonKey(name: 'RtCode')
  final String rtCode;

  @JsonKey(name: 'RtMsg')
  final String rtMsg;

  @JsonKey(name: 'RtData')
  final RtData rtData;

  TxfResponse({required this.rtCode, required this.rtMsg, required this.rtData});

  factory TxfResponse.fromJson(Map<String, dynamic> json) => _$TxfResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TxfResponseToJson(this);
}

@JsonSerializable()
class RtData {
  @JsonKey(name: 'QuoteList')
  final List<Quote> quoteList;

  @JsonKey(name: 'QuoteCount')
  final String quoteCount;

  RtData({required this.quoteList, required this.quoteCount});

  factory RtData.fromJson(Map<String, dynamic> json) => _$RtDataFromJson(json);

  Map<String, dynamic> toJson() => _$RtDataToJson(this);
}

@JsonSerializable()
class Quote {
  @JsonKey(name: 'SymbolID')
  final String symbolID;

  @JsonKey(name: 'SpotID')
  final String spotID;

  @JsonKey(name: 'DispCName')
  final String dispCName;

  @JsonKey(name: 'DispEName')
  final String dispEName;

  @JsonKey(name: 'Status')
  final String status;

  @JsonKey(name: 'CBidPrice1')
  final String cBidPrice1;

  @JsonKey(name: 'CBidSize1')
  final String cBidSize1;

  @JsonKey(name: 'CAskPrice1')
  final String cAskPrice1;

  @JsonKey(name: 'CAskSize1')
  final String cAskSize1;

  @JsonKey(name: 'CTotalVolume')
  final String cTotalVolume;

  @JsonKey(name: 'COpenPrice')
  final String cOpenPrice;

  @JsonKey(name: 'CHighPrice')
  final String cHighPrice;

  @JsonKey(name: 'CLowPrice')
  final String cLowPrice;

  @JsonKey(name: 'CLastPrice')
  final String cLastPrice;

  @JsonKey(name: 'CRefPrice')
  final String cRefPrice;

  @JsonKey(name: 'CCeilPrice')
  final String cCeilPrice;

  @JsonKey(name: 'CFloorPrice')
  final String cFloorPrice;

  @JsonKey(name: 'SettlementPrice')
  final String settlementPrice;

  @JsonKey(name: 'OpenInterest')
  final String openInterest;

  @JsonKey(name: 'CDate')
  final String cDate;

  @JsonKey(name: 'CTime')
  final String cTime;

  @JsonKey(name: 'CTestTime')
  final String cTestTime;

  @JsonKey(name: 'CDiff')
  final String cDiff;

  @JsonKey(name: 'CDiffRate')
  final String cDiffRate;

  @JsonKey(name: 'CAmpRate')
  final String cAmpRate;

  @JsonKey(name: 'CBestBidPrice')
  final String cBestBidPrice;

  @JsonKey(name: 'CBestAskPrice')
  final String cBestAskPrice;

  @JsonKey(name: 'CBestBidSize')
  final String cBestBidSize;

  @JsonKey(name: 'CBestAskSize')
  final String cBestAskSize;

  @JsonKey(name: 'CTestPrice')
  final String cTestPrice;

  @JsonKey(name: 'CTestVolume')
  final String cTestVolume;

  Quote({
    required this.symbolID,
    required this.spotID,
    required this.dispCName,
    required this.dispEName,
    required this.status,
    required this.cBidPrice1,
    required this.cBidSize1,
    required this.cAskPrice1,
    required this.cAskSize1,
    required this.cTotalVolume,
    required this.cOpenPrice,
    required this.cHighPrice,
    required this.cLowPrice,
    required this.cLastPrice,
    required this.cRefPrice,
    required this.cCeilPrice,
    required this.cFloorPrice,
    required this.settlementPrice,
    required this.openInterest,
    required this.cDate,
    required this.cTime,
    required this.cTestTime,
    required this.cDiff,
    required this.cDiffRate,
    required this.cAmpRate,
    required this.cBestBidPrice,
    required this.cBestAskPrice,
    required this.cBestBidSize,
    required this.cBestAskSize,
    required this.cTestPrice,
    required this.cTestVolume,
  });

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteToJson(this);
}

@JsonSerializable()
class TxfRequest {
  @JsonKey(name: 'MarketType')
  final String marketType;

  @JsonKey(name: 'SymbolType')
  final String symbolType;

  @JsonKey(name: 'KindID')
  final String kindID;

  @JsonKey(name: 'CID')
  final String cid;

  @JsonKey(name: 'ExpireMonth')
  final String expireMonth;

  @JsonKey(name: 'RowSize')
  final String rowSize;

  @JsonKey(name: 'PageNo')
  final String pageNo;

  @JsonKey(name: 'SortColumn')
  final String sortColumn;

  @JsonKey(name: 'AscDesc')
  final String ascDesc;

  TxfRequest({
    required this.marketType,
    required this.symbolType,
    required this.kindID,
    required this.cid,
    required this.expireMonth,
    required this.rowSize,
    required this.pageNo,
    required this.sortColumn,
    required this.ascDesc,
  });

  /// 現價
  factory TxfRequest.current() {
    // 判斷使用日盤還是夜盤
    final now = DateTime.now().toUtc().add(const Duration(hours: 8));
    final nowYMD = DateTime(now.year, now.month, now.day);
    DateTime dayStartTime = nowYMD.add(const Duration(hours: 8, minutes: 45)); // 8:45
    DateTime dayEndTime = nowYMD.add(const Duration(hours: 15, minutes: 00)); // 15:00
    bool useDay = now.isAfter(dayStartTime) && now.isBefore(dayEndTime);
    return TxfRequest.fromJson(jsonDecode('''
  {"MarketType":"${useDay ? '0' : '1'}","SymbolType":"F","KindID":"1","CID":"TXF","ExpireMonth":"","RowSize":"全部","PageNo":"","SortColumn":"","AscDesc":"A"}
  '''));
  }

  /// 日盤全部
  factory TxfRequest.day() => TxfRequest.fromJson(jsonDecode('''
  {"MarketType":"0","SymbolType":"F","KindID":"1","CID":"TXF","ExpireMonth":"","RowSize":"全部","PageNo":"","SortColumn":"","AscDesc":"A"}
  '''));

  /// 夜盤全部
  factory TxfRequest.night() => TxfRequest.fromJson(jsonDecode('''
  {"MarketType":"1","SymbolType":"F","KindID":"1","CID":"TXF","ExpireMonth":"","RowSize":"全部","PageNo":"","SortColumn":"","AscDesc":"A"}
  '''));

  /// 日盤，指定到期月份
  factory TxfRequest.dayExpireMonth(String month) => TxfRequest.fromJson(jsonDecode('''
  {"MarketType":"0","SymbolType":"F","KindID":"1","CID":"TXF","ExpireMonth":"$month","RowSize":"全部","PageNo":"","SortColumn":"","AscDesc":"A"}
  '''));

  /// 夜盤，指定到期月份
  factory TxfRequest.nightExpireMonth(String month) => TxfRequest.fromJson(jsonDecode('''
  {"MarketType":"1","SymbolType":"F","KindID":"1","CID":"TXF","ExpireMonth":"$month","RowSize":"全部","PageNo":"","SortColumn":"","AscDesc":"A"}
  '''));

  factory TxfRequest.fromJson(Map<String, dynamic> json) => _$TxfRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TxfRequestToJson(this);
}

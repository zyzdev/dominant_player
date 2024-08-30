// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txf_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxfResponse _$TxfResponseFromJson(Map<String, dynamic> json) => TxfResponse(
      rtCode: json['RtCode'] as String,
      rtMsg: json['RtMsg'] as String,
      rtData: RtData.fromJson(json['RtData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TxfResponseToJson(TxfResponse instance) =>
    <String, dynamic>{
      'RtCode': instance.rtCode,
      'RtMsg': instance.rtMsg,
      'RtData': instance.rtData,
    };

RtData _$RtDataFromJson(Map<String, dynamic> json) => RtData(
      quoteList: (json['QuoteList'] as List<dynamic>)
          .map((e) => Quote.fromJson(e as Map<String, dynamic>))
          .toList(),
      quoteCount: json['QuoteCount'] as String,
    );

Map<String, dynamic> _$RtDataToJson(RtData instance) => <String, dynamic>{
      'QuoteList': instance.quoteList,
      'QuoteCount': instance.quoteCount,
    };

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      symbolID: json['SymbolID'] as String,
      spotID: json['SpotID'] as String,
      dispCName: json['DispCName'] as String,
      dispEName: json['DispEName'] as String,
      status: json['Status'] as String,
      cBidPrice1: json['CBidPrice1'] as String,
      cBidSize1: json['CBidSize1'] as String,
      cAskPrice1: json['CAskPrice1'] as String,
      cAskSize1: json['CAskSize1'] as String,
      cTotalVolume: json['CTotalVolume'] as String,
      cOpenPrice: json['COpenPrice'] as String,
      cHighPrice: json['CHighPrice'] as String,
      cLowPrice: json['CLowPrice'] as String,
      cLastPrice: json['CLastPrice'] as String,
      cRefPrice: json['CRefPrice'] as String,
      cCeilPrice: json['CCeilPrice'] as String,
      cFloorPrice: json['CFloorPrice'] as String,
      settlementPrice: json['SettlementPrice'] as String,
      openInterest: json['OpenInterest'] as String,
      cDate: json['CDate'] as String,
      cTime: json['CTime'] as String,
      cTestTime: json['CTestTime'] as String,
      cDiff: json['CDiff'] as String,
      cDiffRate: json['CDiffRate'] as String,
      cAmpRate: json['CAmpRate'] as String,
      cBestBidPrice: json['CBestBidPrice'] as String,
      cBestAskPrice: json['CBestAskPrice'] as String,
      cBestBidSize: json['CBestBidSize'] as String,
      cBestAskSize: json['CBestAskSize'] as String,
      cTestPrice: json['CTestPrice'] as String,
      cTestVolume: json['CTestVolume'] as String,
    );

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'SymbolID': instance.symbolID,
      'SpotID': instance.spotID,
      'DispCName': instance.dispCName,
      'DispEName': instance.dispEName,
      'Status': instance.status,
      'CBidPrice1': instance.cBidPrice1,
      'CBidSize1': instance.cBidSize1,
      'CAskPrice1': instance.cAskPrice1,
      'CAskSize1': instance.cAskSize1,
      'CTotalVolume': instance.cTotalVolume,
      'COpenPrice': instance.cOpenPrice,
      'CHighPrice': instance.cHighPrice,
      'CLowPrice': instance.cLowPrice,
      'CLastPrice': instance.cLastPrice,
      'CRefPrice': instance.cRefPrice,
      'CCeilPrice': instance.cCeilPrice,
      'CFloorPrice': instance.cFloorPrice,
      'SettlementPrice': instance.settlementPrice,
      'OpenInterest': instance.openInterest,
      'CDate': instance.cDate,
      'CTime': instance.cTime,
      'CTestTime': instance.cTestTime,
      'CDiff': instance.cDiff,
      'CDiffRate': instance.cDiffRate,
      'CAmpRate': instance.cAmpRate,
      'CBestBidPrice': instance.cBestBidPrice,
      'CBestAskPrice': instance.cBestAskPrice,
      'CBestBidSize': instance.cBestBidSize,
      'CBestAskSize': instance.cBestAskSize,
      'CTestPrice': instance.cTestPrice,
      'CTestVolume': instance.cTestVolume,
    };

TxfRequest _$TxfRequestFromJson(Map<String, dynamic> json) => TxfRequest(
      marketType: json['MarketType'] as String,
      symbolType: json['SymbolType'] as String,
      kindID: json['KindID'] as String,
      cid: json['CID'] as String,
      expireMonth: json['ExpireMonth'] as String,
      rowSize: json['RowSize'] as String,
      pageNo: json['PageNo'] as String,
      sortColumn: json['SortColumn'] as String,
      ascDesc: json['AscDesc'] as String,
    );

Map<String, dynamic> _$TxfRequestToJson(TxfRequest instance) =>
    <String, dynamic>{
      'MarketType': instance.marketType,
      'SymbolType': instance.symbolType,
      'KindID': instance.kindID,
      'CID': instance.cid,
      'ExpireMonth': instance.expireMonth,
      'RowSize': instance.rowSize,
      'PageNo': instance.pageNo,
      'SortColumn': instance.sortColumn,
      'AscDesc': instance.ascDesc,
    };

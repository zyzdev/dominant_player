// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartDataResponse _$ChartDataResponseFromJson(Map<String, dynamic> json) =>
    ChartDataResponse(
      rtCode: json['RtCode'] as String,
      rtMsg: json['RtMsg'] as String,
      rtData: RtData.fromJson(json['RtData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChartDataResponseToJson(ChartDataResponse instance) =>
    <String, dynamic>{
      'RtCode': instance.rtCode,
      'RtMsg': instance.rtMsg,
      'RtData': instance.rtData.toJson(),
    };

RtData _$RtDataFromJson(Map<String, dynamic> json) => RtData(
      spotID: json['SpotID'] as String,
      symbolID: json['SymbolID'] as String,
      dispCName: json['DispCName'] as String,
      dispEName: json['DispEName'] as String,
      info: Info.fromJson(json['Info'] as Map<String, dynamic>),
      quote: Quote.fromJson(json['Quote'] as Map<String, dynamic>),
      field: (json['Field'] as List<dynamic>).map((e) => e as String).toList(),
      ticks: (json['Ticks'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );

Map<String, dynamic> _$RtDataToJson(RtData instance) => <String, dynamic>{
      'SpotID': instance.spotID,
      'SymbolID': instance.symbolID,
      'DispCName': instance.dispCName,
      'DispEName': instance.dispEName,
      'Info': instance.info.toJson(),
      'Quote': instance.quote.toJson(),
      'Field': instance.field,
      'Ticks': instance.ticks,
    };

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
      status: json['Status'] as String,
      sessions: (json['Sessions'] as List<dynamic>)
          .map((e) => Session.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'Status': instance.status,
      'Sessions': instance.sessions.map((e) => e.toJson()).toList(),
    };

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      start: json['Start'] as String,
      end: json['End'] as String,
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'Start': instance.start,
      'End': instance.end,
    };

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      cOpenPrice: json['COpenPrice'] as String,
      cHighPrice: json['CHighPrice'] as String,
      cLowPrice: json['CLowPrice'] as String,
      cLastPrice: json['CLastPrice'] as String,
      cSingleVolume: json['CSingleVolume'] as String,
      cTestPrice: json['CTestPrice'] as String,
      cTotalVolume: json['CTotalVolume'] as String,
      openInterest: json['OpenInterest'] as String,
      cRefPrice: json['CRefPrice'] as String,
      cCeilPrice: json['CCeilPrice'] as String,
      cFloorPrice: json['CFloorPrice'] as String,
      cBidCount: json['CBidCount'] as String,
      cAskCount: json['CAskCount'] as String,
      cBidUnit: json['CBidUnit'] as String,
      cAskUnit: json['CAskUnit'] as String,
      cDate: json['CDate'] as String,
      cBidPrice1: json['CBidPrice1'] as String,
      cBidPrice2: json['CBidPrice2'] as String,
      cBidPrice3: json['CBidPrice3'] as String,
      cBidPrice4: json['CBidPrice4'] as String,
      cBidPrice5: json['CBidPrice5'] as String,
      cAskPrice1: json['CAskPrice1'] as String,
      cAskPrice2: json['CAskPrice2'] as String,
      cAskPrice3: json['CAskPrice3'] as String,
      cAskPrice4: json['CAskPrice4'] as String,
      cAskPrice5: json['CAskPrice5'] as String,
      cBidSize1: json['CBidSize1'] as String,
      cBidSize2: json['CBidSize2'] as String,
      cBidSize3: json['CBidSize3'] as String,
      cBidSize4: json['CBidSize4'] as String,
      cBidSize5: json['CBidSize5'] as String,
      cAskSize1: json['CAskSize1'] as String,
      cAskSize2: json['CAskSize2'] as String,
      cAskSize3: json['CAskSize3'] as String,
      cAskSize4: json['CAskSize4'] as String,
      cAskSize5: json['CAskSize5'] as String,
      cExtBidPrice: json['CExtBidPrice'] as String,
      cExtAskPrice: json['CExtAskPrice'] as String,
      cExtBidSize: json['CExtBidSize'] as String,
      cExtAskSize: json['CExtAskSize'] as String,
    );

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'COpenPrice': instance.cOpenPrice,
      'CHighPrice': instance.cHighPrice,
      'CLowPrice': instance.cLowPrice,
      'CLastPrice': instance.cLastPrice,
      'CSingleVolume': instance.cSingleVolume,
      'CTestPrice': instance.cTestPrice,
      'CTotalVolume': instance.cTotalVolume,
      'OpenInterest': instance.openInterest,
      'CRefPrice': instance.cRefPrice,
      'CCeilPrice': instance.cCeilPrice,
      'CFloorPrice': instance.cFloorPrice,
      'CBidCount': instance.cBidCount,
      'CAskCount': instance.cAskCount,
      'CBidUnit': instance.cBidUnit,
      'CAskUnit': instance.cAskUnit,
      'CDate': instance.cDate,
      'CBidPrice1': instance.cBidPrice1,
      'CBidPrice2': instance.cBidPrice2,
      'CBidPrice3': instance.cBidPrice3,
      'CBidPrice4': instance.cBidPrice4,
      'CBidPrice5': instance.cBidPrice5,
      'CAskPrice1': instance.cAskPrice1,
      'CAskPrice2': instance.cAskPrice2,
      'CAskPrice3': instance.cAskPrice3,
      'CAskPrice4': instance.cAskPrice4,
      'CAskPrice5': instance.cAskPrice5,
      'CBidSize1': instance.cBidSize1,
      'CBidSize2': instance.cBidSize2,
      'CBidSize3': instance.cBidSize3,
      'CBidSize4': instance.cBidSize4,
      'CBidSize5': instance.cBidSize5,
      'CAskSize1': instance.cAskSize1,
      'CAskSize2': instance.cAskSize2,
      'CAskSize3': instance.cAskSize3,
      'CAskSize4': instance.cAskSize4,
      'CAskSize5': instance.cAskSize5,
      'CExtBidPrice': instance.cExtBidPrice,
      'CExtAskPrice': instance.cExtAskPrice,
      'CExtBidSize': instance.cExtBidSize,
      'CExtAskSize': instance.cExtAskSize,
    };

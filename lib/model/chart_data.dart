import 'package:json_annotation/json_annotation.dart';

part 'chart_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ChartDataResponse {
  @JsonKey(name: 'RtCode')
  final String rtCode;
  @JsonKey(name: 'RtMsg')
  final String rtMsg;
  @JsonKey(name: 'RtData')
  final RtData rtData;

  ChartDataResponse({
    required this.rtCode,
    required this.rtMsg,
    required this.rtData,
  });

  factory ChartDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ChartDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChartDataResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RtData with ChartUtil{
  @JsonKey(name: 'SpotID')
  final String? spotID;
  @JsonKey(name: 'SymbolID')
  final String symbolID;
  @JsonKey(name: 'DispCName')
  final String dispCName;
  @JsonKey(name: 'DispEName')
  final String dispEName;
  @JsonKey(name: 'Info')
  final Info info;
  @JsonKey(name: 'Quote')
  final Quote quote;
  @JsonKey(name: 'Field')
  final List<String> field;
  @JsonKey(name: 'Ticks')
  final List<List<String>> ticks;
  RtData({
    required this.spotID,
    required this.symbolID,
    required this.dispCName,
    required this.dispEName,
    required this.info,
    required this.quote,
    required this.field,
    required this.ticks,
  });

  factory RtData.fromJson(Map<String, dynamic> json) => _$RtDataFromJson(json);

  Map<String, dynamic> toJson() => _$RtDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Info {
  @JsonKey(name: 'Status')
  final String status;
  @JsonKey(name: 'Sessions')
  final List<Session> sessions;

  Info({
    required this.status,
    required this.sessions,
  });

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

  Map<String, dynamic> toJson() => _$InfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Session {
  @JsonKey(name: 'Start')
  final String start;
  @JsonKey(name: 'End')
  final String end;

  Session({
    required this.start,
    required this.end,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Quote {
  @JsonKey(name: 'COpenPrice')
  final String cOpenPrice;
  @JsonKey(name: 'CHighPrice')
  final String cHighPrice;
  @JsonKey(name: 'CLowPrice')
  final String cLowPrice;
  @JsonKey(name: 'CLastPrice')
  final String cLastPrice;
  @JsonKey(name: 'CSingleVolume')
  final String cSingleVolume;
  @JsonKey(name: 'CTestPrice')
  final String cTestPrice;
  @JsonKey(name: 'CTotalVolume')
  final String cTotalVolume;
  @JsonKey(name: 'OpenInterest')
  final String openInterest;
  @JsonKey(name: 'CRefPrice')
  final String cRefPrice;
  @JsonKey(name: 'CCeilPrice')
  final String cCeilPrice;
  @JsonKey(name: 'CFloorPrice')
  final String cFloorPrice;
  @JsonKey(name: 'CBidCount')
  final String cBidCount;
  @JsonKey(name: 'CAskCount')
  final String cAskCount;
  @JsonKey(name: 'CBidUnit')
  final String cBidUnit;
  @JsonKey(name: 'CAskUnit')
  final String cAskUnit;
  @JsonKey(name: 'CDate')
  final String cDate;
  @JsonKey(name: 'CBidPrice1')
  final String cBidPrice1;
  @JsonKey(name: 'CBidPrice2')
  final String cBidPrice2;
  @JsonKey(name: 'CBidPrice3')
  final String cBidPrice3;
  @JsonKey(name: 'CBidPrice4')
  final String cBidPrice4;
  @JsonKey(name: 'CBidPrice5')
  final String cBidPrice5;
  @JsonKey(name: 'CAskPrice1')
  final String cAskPrice1;
  @JsonKey(name: 'CAskPrice2')
  final String cAskPrice2;
  @JsonKey(name: 'CAskPrice3')
  final String cAskPrice3;
  @JsonKey(name: 'CAskPrice4')
  final String cAskPrice4;
  @JsonKey(name: 'CAskPrice5')
  final String cAskPrice5;
  @JsonKey(name: 'CBidSize1')
  final String cBidSize1;
  @JsonKey(name: 'CBidSize2')
  final String cBidSize2;
  @JsonKey(name: 'CBidSize3')
  final String cBidSize3;
  @JsonKey(name: 'CBidSize4')
  final String cBidSize4;
  @JsonKey(name: 'CBidSize5')
  final String cBidSize5;
  @JsonKey(name: 'CAskSize1')
  final String cAskSize1;
  @JsonKey(name: 'CAskSize2')
  final String cAskSize2;
  @JsonKey(name: 'CAskSize3')
  final String cAskSize3;
  @JsonKey(name: 'CAskSize4')
  final String cAskSize4;
  @JsonKey(name: 'CAskSize5')
  final String cAskSize5;
  @JsonKey(name: 'CExtBidPrice')
  final String cExtBidPrice;
  @JsonKey(name: 'CExtAskPrice')
  final String cExtAskPrice;
  @JsonKey(name: 'CExtBidSize')
  final String cExtBidSize;
  @JsonKey(name: 'CExtAskSize')
  final String cExtAskSize;

  Quote({
    required this.cOpenPrice,
    required this.cHighPrice,
    required this.cLowPrice,
    required this.cLastPrice,
    required this.cSingleVolume,
    required this.cTestPrice,
    required this.cTotalVolume,
    required this.openInterest,
    required this.cRefPrice,
    required this.cCeilPrice,
    required this.cFloorPrice,
    required this.cBidCount,
    required this.cAskCount,
    required this.cBidUnit,
    required this.cAskUnit,
    required this.cDate,
    required this.cBidPrice1,
    required this.cBidPrice2,
    required this.cBidPrice3,
    required this.cBidPrice4,
    required this.cBidPrice5,
    required this.cAskPrice1,
    required this.cAskPrice2,
    required this.cAskPrice3,
    required this.cAskPrice4,
    required this.cAskPrice5,
    required this.cBidSize1,
    required this.cBidSize2,
    required this.cBidSize3,
    required this.cBidSize4,
    required this.cBidSize5,
    required this.cAskSize1,
    required this.cAskSize2,
    required this.cAskSize3,
    required this.cAskSize4,
    required this.cAskSize5,
    required this.cExtBidPrice,
    required this.cExtAskPrice,
    required this.cExtBidSize,
    required this.cExtAskSize,
  });

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteToJson(this);
}


mixin ChartUtil {
  String tickTime(List<String> tick) => tick[0];
  String tickOpen(List<String> tick) => tick[1].split('.')[0];
  String tickHigh(List<String> tick) => tick[2].split('.')[0];
  String tickLow(List<String> tick) => tick[3].split('.')[0];
  String tickClose(List<String> tick) => tick[4].split('.')[0];
  String tickVolume(List<String> tick) => tick[5];


  /// 比對Tick value是否不同
  /// 不包含時間
  bool tickValuesDiff(List<String> tickA, List<String> tickB) {
    if(tickA.length != tickB.length) return true;
    int length = tickA.length;
    if(tickTimeDiff(tickA, tickB)) return true;
    for(int i = 1; i < length; i++) {
      if(tickA[i] != tickB[i]) return true;
    }
    return false;
  }

  bool tickTimeDiff(List<String> tickA, List<String> tickB) {
    String timeA = tickTime(tickA);
    String timeB = tickTime(tickB);
    int ha = double.parse(timeA.substring(0, 2)).toInt();
    int ma = double.parse(timeA.substring(2, 4)).toInt();
    int sa = double.parse(timeA.substring(4)).toInt();
    int minuteA = ha * 60 + ma;
    int hb = double.parse(timeB.substring(0, 2)).toInt();
    int mb = double.parse(timeB.substring(2, 4)).toInt();
    int sb = double.parse(timeB.substring(4)).toInt();
    int minuteB = hb * 60 + mb;
    if (minuteB > minuteA) return true;
    return sa != sb;
  }

  bool? addOrReplace(List<List<String>> allTicks, List<String> newTick) {
    if(allTicks.isEmpty) return null;
    String timeA = tickTime(allTicks.last);
    String timeB = tickTime(newTick);
    int ha = double.parse(timeA.substring(0, 2)).toInt();
    int ma = double.parse(timeA.substring(2, 4)).toInt();
    int sa = double.parse(timeA.substring(4)).toInt();
    int minuteA = ha * 60 + ma;
    int hb = double.parse(timeB.substring(0, 2)).toInt();
    int mb = double.parse(timeB.substring(2, 4)).toInt();
    int sb = double.parse(timeB.substring(4)).toInt();
    int minuteB = hb * 60 + mb;
    // 分鐘比較大，要新增
    if (minuteB > minuteA) return true;
    // 秒數不同，要取代
    if(sb > sa) return false;
    // 數值不同，要取代
    if(tickValuesDiff(allTicks.last, newTick)) return false;

    return null;
  }
}
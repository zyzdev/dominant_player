import 'package:json_annotation/json_annotation.dart';

part 'product_months_info.g.dart'; // 生成代码的文件

@JsonSerializable(explicitToJson: true)
class ProductMonthsInfoResponse {
  @JsonKey(name: 'RtCode')
  final String rtCode;

  @JsonKey(name: 'RtMsg')
  final String rtMsg;

  @JsonKey(name: 'RtData')
  final RtData rtData;

  ProductMonthsInfoResponse({
    required this.rtCode,
    required this.rtMsg,
    required this.rtData,
  });

  factory ProductMonthsInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductMonthsInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductMonthsInfoResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RtData {
  @JsonKey(name: 'Items')
  final List<Item> items;

  RtData({
    required this.items,
  });

  factory RtData.fromJson(Map<String, dynamic> json) =>
      _$RtDataFromJson(json);

  Map<String, dynamic> toJson() => _$RtDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Item {
  @JsonKey(name: 'item')
  final String item;

  Item({
    required this.item,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

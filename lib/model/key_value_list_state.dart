
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'key_value_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class KeyValueListState {

  KeyValueListState({
    this.current,
    this.autoNotice = true,
    this.noticeDis = 10,
  });


  /// 現價
  final int? current;

  /// 接近關鍵價，自動提醒
  @JsonKey(defaultValue: true)
  final bool autoNotice;

  /// 接近關鍵價[noticeDis]，自動提醒
  @JsonKey(defaultValue: 10)
  final int noticeDis;

  factory KeyValueListState.fromJson(Map<String, dynamic> json) =>
      _$KeyValueListStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KeyValueListStateToJson(this);
}
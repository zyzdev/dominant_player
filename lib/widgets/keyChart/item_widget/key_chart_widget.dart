import 'dart:math';

import 'package:dominant_player/model/chart_info.dart';
import 'package:dominant_player/model/real_time_chart_info.dart';
import 'package:dominant_player/provider/real_time_chart_info_provider.dart';
import 'package:dominant_player/provider/is_add_new_tick_provider.dart';
import 'package:dominant_player/widgets/keyChart/item_widget/key_chart_state.dart';
import 'package:dominant_player/widgets/keyChart/key_chart_main_provider.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:dominant_player/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeyChartWidget extends ConsumerStatefulWidget {
  final int index;

  const KeyChartWidget({required this.index, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KeyChartWidgetState();
}

class _KeyChartWidgetState extends ConsumerState<KeyChartWidget> {
  KeyChartState get _state =>
      ref.read(keyChartMainWidgetProvider)[widget.index];

  KeyChartMainWidgetNotifier get _notifier =>
      ref.read(keyChartMainWidgetProvider.notifier);

  RealTimeChartInfo get _realTimeChartInfo =>
      ref.read(realTimeChartInfoProvider(_state.kPeriod!));

  bool get _dataIsReady {
    return _state.kPeriod != null && _realTimeChartInfo.allTicks.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (_state.kPeriod != null)
      ref.watch(realTimeChartInfoProvider(_state.kPeriod!));
    ref.listen(isAddNewTickProvider, (previous, next) {
      print(previous);
      print(next);
      _state.shouldNotice(_realTimeChartInfo.getLastFinishChartInfo());
    });

    _kChartSizeFactor = 5 / (_state.kPeriod ?? 1);
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                confirmDialog(_state.title, context).then((remove) {
                  if (remove == true) {
                    _notifier.removeKeyChart(_state);
                  }
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.delete_forever,
                  size: 20,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Stack(
                    children: [
                      // 留下最小寬度
                      SizedBox(width: infoW),
                      // 用Text把widget的寬度長出來
                      // 以讓textField可以到最寬
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          _state.title,
                          style: titleST.copyWith(
                              color: Colors.black12.withOpacity(0.01)),
                        ),
                      ),
                      Positioned.fill(
                          child: textField(
                              init: _state.title,
                              onChanged: (value) {
                                _notifier.setTitle(value, _state);
                              },
                              keyboardType: TextInputType.text,
                              error: _notifier.isKeyChartTitleDuplicate(
                                      _state.title, _state)
                                  ? '名稱請不要重複！'
                                  : null))
                    ],
                  ),
                  const SizedBox(width: 12),
                  textField(
                    init: _state.kPeriod,
                    hint: '請輸入分鐘',
                    onChanged: (value) {
                      _notifier.setPeriod(value, _state);
                    },
                    keyboardType: TextInputType.number,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '分K',
                      style: infoST.copyWith(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            if (_dataIsReady) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: valuesInfo(_realTimeChartInfo.allChartInfo.last),
              ),
              const SizedBox(height: 16),
              chart(_realTimeChartInfo.allChartInfo.last),
              //charts,
              //const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: valuesInfo(_realTimeChartInfo
                    .allChartInfo[_realTimeChartInfo.allChartInfo.length - 2]),
              ),
              chart(_realTimeChartInfo
                  .allChartInfo[_realTimeChartInfo.allChartInfo.length - 2]),
              Wrap(
                spacing: 16,
                children: [
                  considerVolume,
                  considerCloseWithLongUpperShadow,
                  considerCloseWithLongLowerShadow,
                ],
              )
            ],
          ],
        ),
      ],
    );

    content = Stack(
      children: [
        Positioned(
            right: 0,
            child: Switch(
              value: _state.notice,
              onChanged: (notice) {
                _notifier.setNotice(notice, _state);
              },
            )),
        content
      ],
    );
    return Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        )),
        child: content);
  }

  /// K棒最高的高度
  static const double _kChartMaxH = 201;

  /// k棒高度的倍數
  double _kChartSizeFactor = 0;
  static const double _kChartWidth = 30;

  Widget valuesInfo(ChartInfo chartInfo) {
    int closeToOpen = chartInfo.closeToOpen;
    Color valueColor = closeToOpen > 0
        ? winColor
        : closeToOpen < 0
            ? loseColor
            : Colors.black;

    Widget tile(String title, String value) {
      return Row(
        children: [
          Text(
            '$title：',
            style: captionST,
          ),
          Text(
            value,
            style: captionST.copyWith(color: valueColor),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 8,
      children: [
        tile('開', chartInfo.open.toString()),
        tile('高', chartInfo.high.toString()),
        tile('中', chartInfo.middle.toString()),
        tile('低', chartInfo.low.toString()),
        tile('收', chartInfo.close.toString()),
        tile('量', chartInfo.volume.toString()),
      ],
    );
  }

  Widget get charts {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250, maxWidth: 400),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: _realTimeChartInfo.allChartInfo.map((e) => chart(e)).toList(),
      ),
    );
  }

  Widget chart(ChartInfo chartInfo) {
    int highToOpenDis = chartInfo.highToOpenDis;
    int lowToOpenDis = chartInfo.lowToOpenDis;
    // +1是因為open位置的高度
    double kChartHeight =
        max(highToOpenDis, lowToOpenDis).abs() * _kChartSizeFactor * 2 + 1;
    int closeToOpen = chartInfo.closeToOpen;

    late double kChartUpperHeight;
    late double kChartLowerHeight;
    // 為了讓close維持在中間，close以上的部分和以下的部分都要等高
    // 也就是說，上下最多都是100
    // 如果超過，就要用比例來給
    if (kChartHeight > _kChartMaxH) {
      if (highToOpenDis > lowToOpenDis) {
        kChartUpperHeight =
            (_kChartMaxH - 1) * highToOpenDis / chartInfo.distance;
        kChartLowerHeight = (_kChartMaxH - 1) - kChartUpperHeight;
      } else {
        kChartLowerHeight =
            (_kChartMaxH - 1) * lowToOpenDis / chartInfo.distance;
        kChartUpperHeight = (_kChartMaxH - 1) - kChartLowerHeight;
      }
      kChartHeight = _kChartMaxH;
    } else {
      kChartUpperHeight = highToOpenDis * _kChartSizeFactor;
      kChartLowerHeight = kChartUpperHeight;
    }

    double kChartUpperSquareHeight = closeToOpen > 0
        ? kChartUpperHeight * closeToOpen.abs() / highToOpenDis
        : 0;
    double kChartLowerSquareHeight = closeToOpen < 0
        ? kChartLowerHeight * closeToOpen.abs() / lowToOpenDis
        : 0;
    double kChartUpperShadowHeight =
        kChartUpperHeight - kChartUpperSquareHeight;
    double kChartLowerShadowHeight =
        kChartLowerHeight - kChartLowerSquareHeight;
    Color kChartColor = closeToOpen > 0
        ? winColor
        : closeToOpen < 0
            ? loseColor
            : Colors.black;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _kChartWidth,
          height: kChartUpperHeight,
          child: Column(
            children: [
              Container(
                height: kChartUpperShadowHeight,
                width: 1,
                color: kChartColor,
              ),
              Container(
                height: kChartUpperSquareHeight,
                width: _kChartWidth,
                color: kChartColor,
              )
            ],
          ),
        ),
        Container(
          width: _kChartWidth,
          height: 1,
          color: kChartColor,
        ),
        SizedBox(
          width: _kChartWidth,
          height: kChartLowerHeight,
          child: Column(
            children: [
              Container(
                height: kChartLowerSquareHeight,
                width: _kChartWidth,
                color: kChartColor,
              ),
              Container(
                height: kChartLowerShadowHeight,
                width: 1,
                color: kChartColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get considerVolume {
    return Row(
      children: [
        _checkbox(
          _state.considerVolume,
          (notice) {
            if (notice == null) return;
            _notifier.setVolume(notice, _state);
          },
        ),
        Text(
          '成交量:',
          style: infoST,
        ),
        textField(
          keyboardType: const TextInputType.numberWithOptions(),
          onChanged: (value) {
            _notifier.setVolumeValue(double.parse(value).toInt(), _state);
          },
        ),
      ],
    );
  }

  Widget get considerCloseWithLongUpperShadow {
    return Row(
      children: [
        _checkbox(
          _state.closeWithLongUpperShadow,
          (notice) {
            if (notice == null) return;
            _notifier.setCloseWithLongUpperShadow(notice, _state);
          },
        ),
        Text(
          '收長上影:',
          style: infoST,
        ),
      ],
    );
  }

  Widget get considerCloseWithLongLowerShadow {
    return Row(
      children: [
        _checkbox(
          _state.closeWithLongLowerShadow,
          (notice) {
            if (notice == null) return;
            _notifier.setCloseWithLongLowerShadow(notice, _state);
          },
        ),
        Text(
          '收長下影:',
          style: infoST,
        ),
      ],
    );
  }

  Widget _checkbox(bool? selected, ValueChanged<bool?>? onChanged) {
    Widget content = Checkbox(
      activeColor: Colors.blue,
      side: const BorderSide(
        color: Colors.grey,
        width: 1,
      ),
      value: selected,
      onChanged: onChanged,
    );
    return Transform.scale(scale: 0.7, child: content);
  }
}

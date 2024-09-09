import 'dart:math';

import 'package:dominant_player/model/chart_info.dart';
import 'package:dominant_player/provider/chart_info_provider.dart';
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

  ChartInfo get _chartInfo => ref.read(chartInfoProvider(_state.kPeriod!));

  bool get _dataIsReady {
    return _state.kPeriod != null && _chartInfo.allTicks.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (_state.kPeriod != null) ref.watch(chartInfoProvider(_state.kPeriod!));
    ref.listen(isAddNewTickProvider, (previous, next) {
      print(previous);
      print(next);
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
                child: valuesInfo,
              ),
              const SizedBox(height: 16),
              chart,
              const SizedBox(height: 16),
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

  Widget get valuesInfo {
    int closeToOpenDis = _chartInfo.closeToOpenDis;
    Color valueColor = closeToOpenDis > 0
        ? winColor
        : closeToOpenDis < 0
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
        tile('開', _chartInfo.open.toString()),
        tile('高', _chartInfo.high.toString()),
        tile('低', _chartInfo.low.toString()),
        tile('收', _chartInfo.close.toString()),
        tile('量', _chartInfo.volume.toString()),
      ],
    );
  }

  Widget get chart {
    int highToOpenDis = _chartInfo.high - _chartInfo.open;
    int  lowToOpenDis = _chartInfo.open - _chartInfo.low;
    // +1是因為open位置的高度
    double kChartHeight =
        max(highToOpenDis, lowToOpenDis).abs() * _kChartSizeFactor * 2 + 1;
    int closeToOpenDis = _chartInfo.closeToOpenDis;

    late double kChartUpperHeight;
    late double kChartLowerHeight;
    // 為了讓close維持在中間，close以上的部分和以下的部分都要等高
    // 也就是說，上下最多都是100
    // 如果超過，就要用比例來給
    if (kChartHeight > _kChartMaxH) {
      if (highToOpenDis > lowToOpenDis) {
        kChartUpperHeight = (_kChartMaxH - 1) * highToOpenDis / _chartInfo.distance;
        kChartLowerHeight =(_kChartMaxH - 1) - kChartUpperHeight;
      } else {
        kChartLowerHeight =(_kChartMaxH - 1) * lowToOpenDis / _chartInfo.distance;
        kChartUpperHeight = (_kChartMaxH - 1)  - kChartLowerHeight;
      }
      print('highToCloseDis:$highToOpenDis, lowToCloseDis:$lowToOpenDis');
      print('kChartUpperHeight:$kChartUpperHeight, kChartLowerHeight:$kChartLowerHeight');
      kChartHeight = _kChartMaxH;
    } else {
      kChartUpperHeight = _chartInfo.distance.abs() * _kChartSizeFactor;
      kChartLowerHeight = kChartUpperHeight;
    }


    double kChartUpperSquareHeight = closeToOpenDis > 0
        ? kChartUpperHeight * closeToOpenDis / highToOpenDis
        : 0;
    double kChartLowerSquareHeight = closeToOpenDis < 0
        ? kChartLowerHeight * closeToOpenDis.abs() / lowToOpenDis
        : 0;
    double kChartUpperShadowHeight =
        kChartUpperHeight - kChartUpperSquareHeight;
    double kChartLowerShadowHeight =
        kChartLowerHeight - kChartLowerSquareHeight;

    Color kChartColor = closeToOpenDis > 0
        ? winColor
        : closeToOpenDis < 0
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
}

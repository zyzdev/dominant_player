import 'dart:math';

import 'package:dominant_player/model/candle_info.dart';
import 'package:dominant_player/model/real_time_chart_info.dart';
import 'package:dominant_player/provider/real_time_chart_info_provider.dart';
import 'package:dominant_player/provider/is_add_new_tick_provider.dart';
import 'package:dominant_player/widgets/keyCandle/item_widget/key_candle_controller.dart';
import 'package:dominant_player/widgets/keyCandle/key_candle_main_provider.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:dominant_player/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'key_candle_state.dart';

class KeyCandleWidget extends ConsumerStatefulWidget {
  final int index;

  const KeyCandleWidget({required this.index, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _KeyCandleWidgetState();
}

class _KeyCandleWidgetState extends ConsumerState<KeyCandleWidget> {
  KeyCandleState get _state =>
      ref.read(keyCandleMainWidgetProvider)[widget.index];

  KeyCandleMainWidgetNotifier get _notifier =>
      ref.read(keyCandleMainWidgetProvider.notifier);

  RealTimeChartInfo get _realTimeChartInfo =>
      ref.read(realTimeChartInfoProvider(_state.kPeriod!));

  bool get _dataIsReady {
    return _state.kPeriod != null && _realTimeChartInfo.allTicks.isNotEmpty;
  }

  late final TextEditingController volumeController =
      TextEditingController(text: _state.keyVolume?.toString() ?? '');
  late final TextEditingController aTurnInPeriodController =
      TextEditingController(text: _state.aTurnInPeriod?.toString() ?? '');
  late final TextEditingController vTurnInPeriodController =
      TextEditingController(text: _state.vTurnInPeriod?.toString() ?? '');

  late final TextEditingController longAttackPointController =
      TextEditingController(text: _state.longAttackPoint?.toString() ?? '');
  late final TextEditingController shortAttackPointController =
      TextEditingController(text: _state.shortAttackPoint?.toString() ?? '');

  @override
  Widget build(BuildContext context) {
    if (_state.kPeriod != null) {
      ref.watch(realTimeChartInfoProvider(_state.kPeriod!));
    }
    ref.listen(isAddNewTickProvider, (previous, next) {
      if (_state.notice) {
        _state.shouldNotice(
          _realTimeChartInfo,
          context,
          ref,
        );
      }
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
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 12),
                  textField(
                    init: _state.kPeriod,
                    hint: '請輸入分鐘',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                child: valuesInfo(_realTimeChartInfo.allCandleInfo.last),
              ),
              const SizedBox(height: 16),
              //chart(_realTimeChartInfo.allChartInfo.last),
              //charts,
              //const SizedBox(height: 16),
/*              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: valuesInfo(_realTimeChartInfo
                    .allChartInfo[_realTimeChartInfo.allChartInfo.length - 2]),
              ),
              chart(_realTimeChartInfo
                  .allChartInfo[_realTimeChartInfo.allChartInfo.length - 2]),*/
              Wrap(
                spacing: 16,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  considerVolume,
                  considerATurn,
                  considerValley,
                ],
              ),
              Wrap(
                spacing: 16,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  considerLongAttack,
                  considerShortAttack,
                  considerCloseWithLongUpperShadow,
                  considerCloseWithLongLowerShadow,
                ],
              ),
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
        padding: const EdgeInsets.all(16),
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

  Widget valuesInfo(CandleInfo candleInfo) {
    int closeToOpen = candleInfo.closeToOpen;
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
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      children: [
        tile('開', candleInfo.open.toString()),
        tile('高', candleInfo.high.toString()),
        tile('中', candleInfo.middle.toString()),
        tile('低', candleInfo.low.toString()),
        tile('收', candleInfo.close.toString()),
        tile('量', candleInfo.volume.toString()),
        Row(
          children: [
            candleInfo.closeToOpen < 0
                ? Icon(
                    Icons.arrow_drop_down,
                    color: loseColor,
                    size: 20,
                  )
                : candleInfo.closeToOpen > 0
                    ? Icon(
                        Icons.arrow_drop_up,
                        color: winColor,
                        size: 20,
                      )
                    : const SizedBox(),
            Text(
              '${candleInfo.closeToOpen > 0 ? '+' : ''}${candleInfo.closeToOpen}',
              style: captionST.copyWith(
                  color: closeToOpen > 0
                      ? winColor
                      : closeToOpen < 0
                          ? loseColor
                          : Colors.black),
            )
          ],
        )
      ],
    );
  }

  Widget get charts {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250, maxWidth: 400),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children:
            _realTimeChartInfo.allCandleInfo.map((e) => chart(e)).toList(),
      ),
    );
  }

  Widget chart(CandleInfo candleInfo) {
    int highToOpenDis = candleInfo.highToOpenDis;
    int lowToOpenDis = candleInfo.lowToOpenDis;
    // +1是因為open位置的高度
    double kChartHeight =
        max(highToOpenDis, lowToOpenDis).abs() * _kChartSizeFactor * 2 + 1;
    int closeToOpen = candleInfo.closeToOpen;

    late double kChartUpperHeight;
    late double kChartLowerHeight;
    // 為了讓close維持在中間，close以上的部分和以下的部分都要等高
    // 也就是說，上下最多都是100
    // 如果超過，就要用比例來給
    if (kChartHeight > _kChartMaxH) {
      if (highToOpenDis > lowToOpenDis) {
        kChartUpperHeight =
            (_kChartMaxH - 1) * highToOpenDis / candleInfo.distance;
        kChartLowerHeight = (_kChartMaxH - 1) - kChartUpperHeight;
      } else {
        kChartLowerHeight =
            (_kChartMaxH - 1) * lowToOpenDis / candleInfo.distance;
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
      mainAxisSize: MainAxisSize.min,
      children: [
        _checkbox(
          _state.considerVolume,
          (notice) {
            if (notice == null) return;
            _notifier.setVolume(notice, _state);
          },
        ),
        GestureDetector(
          onTap: () {
            _notifier.setVolume(!_state.considerVolume, _state);
          },
          child: Text(
            '成交量:',
            style: infoST,
          ),
        ),
        textField(
          controller: volumeController,
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            _notifier.setVolumeValue(double.tryParse(value)?.toInt(), _state);
          },
        ),
      ],
    );
  }

  Widget get considerCloseWithLongUpperShadow {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _checkbox(
          _state.closeWithLongUpperShadow,
          (notice) {
            if (notice == null) return;
            _notifier.setCloseWithLongUpperShadow(notice, _state);
          },
        ),
        GestureDetector(
          onTap: () {
            _notifier.setCloseWithLongUpperShadow(
                !_state.closeWithLongUpperShadow, _state);
          },
          child: Text(
            '收長上影',
            style: infoST,
          ),
        ),
      ],
    );
  }

  Widget get considerCloseWithLongLowerShadow {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _checkbox(
          _state.closeWithLongLowerShadow,
          (notice) {
            if (notice == null) return;
            _notifier.setCloseWithLongLowerShadow(notice, _state);
          },
        ),
        GestureDetector(
          onTap: () {
            _notifier.setCloseWithLongLowerShadow(
                !_state.closeWithLongLowerShadow, _state);
          },
          child: Text(
            '收長下影',
            style: infoST,
          ),
        ),
      ],
    );
  }

  Widget get considerATurn {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _checkbox(
          _state.aTurn,
          (notice) {
            if (notice == null) return;
            _notifier.setATurn(notice, _state);
          },
        ),
        GestureDetector(
          onTap: () {
            _notifier.setATurn(!_state.aTurn, _state);
          },
          child: Text(
            'A轉:',
            style: infoST,
          ),
        ),
        textField(
          controller: aTurnInPeriodController,
          hint: 'K棒數量',
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            _notifier.setATurnInPeriod(double.tryParse(value)?.toInt(), _state);
          },
        )
      ],
    );
  }

  Widget get considerValley {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _checkbox(
          _state.vTurn,
          (notice) {
            if (notice == null) return;
            _notifier.setVTurn(notice, _state);
          },
        ),
        GestureDetector(
          onTap: () {
            _notifier.setVTurn(!_state.vTurn, _state);
          },
          child: Text(
            'V轉:',
            style: infoST,
          ),
        ),
        textField(
          controller: vTurnInPeriodController,
          hint: 'K棒數量',
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            _notifier.setVTurnInPeriod(double.tryParse(value)?.toInt(), _state);
          },
        )
      ],
    );
  }

  Widget get considerLongAttack {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _checkbox(
          _state.longAttack,
          (notice) {
            if (notice == null) return;
            _notifier.setLongAttack(notice, _state);
          },
        ),
        GestureDetector(
          onTap: () {
            _notifier.setLongAttack(!_state.longAttack, _state);
          },
          child: Text(
            '多方攻擊:',
            style: infoST,
          ),
        ),
        textField(
          controller: longAttackPointController,
          hint: '攻擊點數',
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            _notifier.setLongAttackPoint(
                double.tryParse(value)?.toInt(), _state);
          },
        )
      ],
    );
  }

  Widget get considerShortAttack {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _checkbox(
          _state.shortAttack,
          (notice) {
            if (notice == null) return;
            _notifier.setShortAttack(notice, _state);
          },
        ),
        GestureDetector(
          onTap: () {
            _notifier.setShortAttack(!_state.shortAttack, _state);
          },
          child: Text(
            '空方攻擊:',
            style: infoST,
          ),
        ),
        textField(
          controller: shortAttackPointController,
          hint: '攻擊點數',
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            _notifier.setShortAttackPoint(
                double.tryParse(value)?.toInt(), _state);
          },
        )
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
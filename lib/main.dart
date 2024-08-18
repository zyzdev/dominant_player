import 'package:cross_scroll/cross_scroll.dart';
import 'package:dominant_player/main_provider.dart';
import 'package:dominant_player/model/spy_state.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:dominant_player/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/key_value.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState {
  SpyState get _state => ref.read(mainProvider);

  MainNotifier get _mainNotifier => ref.read(mainProvider.notifier);

  @override
  Widget build(BuildContext context) {
    ref.watch(mainProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('絕對主力邏輯計算器'),
          backgroundColor: const Color(0xff4d2bab),
        ),
        body: CrossScroll(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spy,
              Column(
                children: [
                  _daySensitivitySpace,
                  _nightSensitivitySpace,
                ],
              ),
              keyValueList
            ],
          ),
        ),
      ),
    );
  }

  Widget get spy {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            title('日期'),
            info(_state.today),
          ],
        ),
        ..._mainNotifier.spyValues.map((e) {
          if (e.key == KeyValue.current ||
              e.key == KeyValue.high ||
              e.key == KeyValue.low) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                title(e.key.title, color: e.key.bg, rightLine: true),
                textField(e.value, (value) {
                  if (e.key == KeyValue.current) {
                    _mainNotifier.current = value;
                  } else if (e.key == KeyValue.high) {
                    _mainNotifier.high = value;
                  } else if (e.key == KeyValue.low) {
                    _mainNotifier.low = value;
                  }
                }),
              ],
            );
          } else {
            return ColoredBox(
              color: e.key.bg,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  title(e.key.title, rightLine: true),
                  info(e.value),
                ],
              ),
            );
          }
        })
      ],
    );
  }

  Widget get _daySensitivitySpace {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title('日盤靈敏度空間', leftLine: false, bottomLine: false),
        sensitivitySpace(
            direction: Direction.long15,
            bg: winColor.withOpacity(0.2),
            sensitivitySpace: _state.daySensitivitySpace15,
            highOnChange: _mainNotifier.daySensitivitySpaceLongHigh15,
            lowOnChange: _mainNotifier.daySensitivitySpaceLongLow15),
        sensitivitySpace(
            direction: Direction.long30,
            bg: winColor.withOpacity(0.2),
            sensitivitySpace: _state.daySensitivitySpace30,
            highOnChange: _mainNotifier.daySensitivitySpaceLongHigh30,
            lowOnChange: _mainNotifier.daySensitivitySpaceLongLow30),
        sensitivitySpace(
            direction: Direction.short15,
            bg: loseColor.withOpacity(0.2),
            sensitivitySpace: _state.daySensitivitySpace15,
            highOnChange: _mainNotifier.daySensitivitySpaceShortHigh15,
            lowOnChange: _mainNotifier.daySensitivitySpaceShortLow15),
        sensitivitySpace(
            direction: Direction.short30,
            bg: loseColor.withOpacity(0.2),
            sensitivitySpace: _state.daySensitivitySpace30,
            highOnChange: _mainNotifier.daySensitivitySpaceShortHigh30,
            lowOnChange: _mainNotifier.daySensitivitySpaceShortLow30)
      ],
    );
    return ColoredBox(
      color: Colors.yellow,
      child: content,
    );
  }

  Widget get _nightSensitivitySpace {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title('夜盤靈敏度空間', leftLine: false, bottomLine: false),
        sensitivitySpace(
            direction: Direction.long15,
            bg: winColor.withOpacity(0.2),
            sensitivitySpace: _state.nightSensitivitySpace15,
            highOnChange: _mainNotifier.nightSensitivitySpaceLongHigh15,
            lowOnChange: _mainNotifier.nightSensitivitySpaceLongLow15),
        sensitivitySpace(
            direction: Direction.long30,
            bg: winColor.withOpacity(0.2),
            sensitivitySpace: _state.nightSensitivitySpace30,
            highOnChange: _mainNotifier.nightSensitivitySpaceLongHigh30,
            lowOnChange: _mainNotifier.nightSensitivitySpaceLongLow30),
        sensitivitySpace(
            direction: Direction.short15,
            bg: loseColor.withOpacity(0.2),
            sensitivitySpace: _state.nightSensitivitySpace15,
            highOnChange: _mainNotifier.nightSensitivitySpaceShortHigh15,
            lowOnChange: _mainNotifier.nightSensitivitySpaceShortLow15),
        sensitivitySpace(
            direction: Direction.short30,
            bg: loseColor.withOpacity(0.2),
            sensitivitySpace: _state.nightSensitivitySpace30,
            highOnChange: _mainNotifier.nightSensitivitySpaceShortHigh30,
            lowOnChange: _mainNotifier.nightSensitivitySpaceShortLow30)
      ],
    );
    return ColoredBox(
      color: Colors.yellow,
      child: content,
    );
  }

  Widget get keyValueList {
    Size textSize(String text, TextStyle style) {
      final TextPainter textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: double.infinity);
      return textPainter.size;
    }

    double maxW = 0;
    for (MapEntry<KeyValue, num> element in _mainNotifier.keyValues) {
      double w = textSize(element.key.title, infoST).width;
      if (w > maxW) maxW = w;
    }
    maxW += 16;

    int indexOfCurrent = _mainNotifier.keyValues
        .indexWhere((element) => element.key == KeyValue.current);
    Map<int, Color> noticeColor = {
      2: winColor.withOpacity(0.2),
      1: winColor.withOpacity(0.1),
      0: noteColor.withOpacity(0.1),
      -1: loseColor.withOpacity(0.1),
      -2: loseColor.withOpacity(0.2),
    };
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title('關鍵價位列表', leftLine: false, bottomLine: false),
        ColoredBox(
          color: const Color(0xFFFAFAFA),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_mainNotifier.keyValues.isEmpty)
                const Center(
                  child: Text(
                    '請先填入關鍵價位（現價、高點、低點、靈敏度空間高低點）',
                    style: titleST,
                  ),
                ),
              ..._mainNotifier.keyValues.map((e) {
                int index = _mainNotifier.keyValues.indexWhere(
                  (element) => element.key == e.key,
                );
                Color? noticeBg;
                bool shouldNotice = false;
                num? valueDis;
                int indexDis = indexOfCurrent - index;
                if (indexOfCurrent != -1) {
                  shouldNotice = indexDis.abs() < 3;

                  if (shouldNotice) {
                    noticeBg = noticeColor[indexDis];
                    valueDis =
                        _mainNotifier.keyValues[indexOfCurrent].value - e.value;
                  }
                }

                Widget content = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: maxW,
                      child: Center(
                        child: title(e.key.title),
                      ),
                    ),
                    info(e.value, topLine: true, rightLine: true),
                    if (shouldNotice) ...[
                      indexDis == 0
                          ? Container(
                              constraints: const BoxConstraints(
                                  minWidth: infoW, minHeight: textH),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: loseColor,
                                  ),
                                  const Text(
                                    '價差',
                                    style: infoST,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_up,
                                    color: winColor,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              width: 86,
                              child: info(
                                '${valueDis! > 0 ? '+' : ''}$valueDis',
                                color: valueDis > 0
                                    ? winColor
                                    : valueDis < 0
                                        ? loseColor
                                        : Colors.transparent,
                                topLine: true,
                                rightLine: true,
                              ),
                            ),
                    ],
                  ],
                );
                return ColoredBox(
                  color: noticeBg ?? const Color(0xFFFAFAFA),
                  child: content,
                );
              }).toList()
            ],
          ),
        ),
      ],
    );
    return ColoredBox(
      color: Colors.lightBlueAccent.shade100,
      child: content,
    );
  }

  Widget sensitivitySpace({
    required Direction direction,
    required Color bg,
    required SensitivitySpace sensitivitySpace,
    required ValueChanged<String> highOnChange,
    required ValueChanged<String> lowOnChange,
  }) {
    Widget hAndL({
      required int? high,
      required int? low,
      required ValueChanged<String> highOnChange,
      required ValueChanged<String> lowOnChange,
    }) =>
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                title('高點', rightLine: true),
                textField(high, highOnChange)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                title('低點', rightLine: true),
                textField(low, lowOnChange)
              ],
            ),
          ],
        );

    // 攻擊、中關、防守
    Widget amd({
      required int? attack,
      required double? middle,
      required int? defense,
    }) =>
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [title('攻擊', rightLine: true), info(attack)],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [title('中關', rightLine: true), info(middle)],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [title('防守', rightLine: true), info(defense)],
            ),
          ],
        );
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1)),
      child: ColoredBox(
        color: bg,
        child: Row(
          children: [
            title(direction.typeName,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                line: false),
            hAndL(
              high: direction.isLong
                  ? sensitivitySpace.longHigh
                  : sensitivitySpace.shortHigh,
              low: direction.isLong
                  ? sensitivitySpace.longLow
                  : sensitivitySpace.shortLow,
              highOnChange: highOnChange,
              lowOnChange: lowOnChange,
            ),
            amd(
                attack: direction.isLong
                    ? sensitivitySpace.longAttack
                    : sensitivitySpace.maxShortAttack,
                middle: direction.isLong
                    ? sensitivitySpace.longMiddle
                    : sensitivitySpace.shortMiddle,
                defense: direction.isLong
                    ? sensitivitySpace.longDefense
                    : sensitivitySpace.shortDefense)
          ],
        ),
      ),
    );
  }

  Widget textField(dynamic init, ValueChanged<String> onChanged) {
    final controller = TextEditingController(text: init?.toString() ?? '');
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
    return Container(
      width: infoW,
      height: textH,
      alignment: Alignment.bottomCenter,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: infoST,
        textInputAction: TextInputAction.next,
        onChanged: onChanged,
      ),
    );
  }
}

extension KeyValueBackgroundColor on KeyValue {
  Color get bg {
    switch (this) {
      case KeyValue.current:
        return noteColor;
      case KeyValue.high:
        return winColor;
      case KeyValue.low:
        return loseColor;
      case KeyValue.highCost:
        return winColor.withOpacity(0.2);
      case KeyValue.middleCost:
        return noteColor.withOpacity(0.2);
      case KeyValue.lowCost:
        return loseColor.withOpacity(0.2);
      case KeyValue.superPress:
        return winColor.withOpacity(0.5);
      case KeyValue.absolutePress:
        return winColor.withOpacity(0.3);
      case KeyValue.nestPress:
        return winColor.withOpacity(0.1);
      case KeyValue.nestSupport:
        return loseColor.withOpacity(0.1);
      case KeyValue.absoluteSupport:
        return loseColor.withOpacity(0.3);
      case KeyValue.superSupport:
        return loseColor.withOpacity(0.5);
      default:
        return Colors.transparent;
    }
  }
}

enum Direction {
  long15,
  long30,
  short15,
  short30,
}

extension DirectionName on Direction {
  bool get isLong => this == Direction.long15 || this == Direction.long30;

  String get typeName {
    switch (this) {
      case Direction.long15:
        return '15分多方最大邏輯';
      case Direction.long30:
        return '30分多方最大邏輯';
      case Direction.short15:
        return '15分空方最大邏輯';
      case Direction.short30:
        return '30分空方最大邏輯';
    }
  }
}

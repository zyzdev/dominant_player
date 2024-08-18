import 'dart:math';

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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical, // 垂直滾動
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // 水平滾動
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
                _keyValueList
              ],
            ),
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
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              )),
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      child: Opacity(
                        opacity: 0,
                        child: _checkbox(null),
                      )),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      title('日期', line: false)
                    ],
                  ),
                ],
              ),
            ),
            info(_state.today),
          ],
        ),
        ..._mainNotifier.spyValues.map((e) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (_state.considerKeyValue[e.key] != null) {
                    _mainNotifier.considerKeyValue(
                        e.key, !_state.considerKeyValue[e.key]!);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  )),
                  child: Stack(
                    children: [
                      if (e.key != KeyValue.current &&
                          e.key != KeyValue.range &&
                          e.key != KeyValue.rangeDiv4)
                        Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            child: _checkbox(e.key)),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          title(e.key.title,
                              color: e.key == KeyValue.current ||
                                      e.key == KeyValue.high ||
                                      e.key == KeyValue.low
                                  ? e.key.bg
                                  : null,
                              line: false)
                        ],
                      )
                    ],
                  ),
                ),
              ),
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
          lowOnChange: _mainNotifier.daySensitivitySpaceLongLow15,
          attackKeyValue: KeyValue.dayLongAttack15,
          middleKeyValue: KeyValue.dayLongMiddle15,
          defenseKeyValue: KeyValue.dayLongDefense15,
          topLine: true,
        ),
        sensitivitySpace(
          direction: Direction.long30,
          bg: winColor.withOpacity(0.2),
          sensitivitySpace: _state.daySensitivitySpace30,
          highOnChange: _mainNotifier.daySensitivitySpaceLongHigh30,
          lowOnChange: _mainNotifier.daySensitivitySpaceLongLow30,
          attackKeyValue: KeyValue.dayLongAttack30,
          middleKeyValue: KeyValue.dayLongMiddle30,
          defenseKeyValue: KeyValue.dayLongDefense30,
        ),
        sensitivitySpace(
          direction: Direction.short15,
          bg: loseColor.withOpacity(0.2),
          sensitivitySpace: _state.daySensitivitySpace15,
          highOnChange: _mainNotifier.daySensitivitySpaceShortHigh15,
          lowOnChange: _mainNotifier.daySensitivitySpaceShortLow15,
          attackKeyValue: KeyValue.dayShortAttack15,
          middleKeyValue: KeyValue.dayShortMiddle15,
          defenseKeyValue: KeyValue.dayShortDefense15,
        ),
        sensitivitySpace(
          direction: Direction.short30,
          bg: loseColor.withOpacity(0.2),
          sensitivitySpace: _state.daySensitivitySpace30,
          highOnChange: _mainNotifier.daySensitivitySpaceShortHigh30,
          lowOnChange: _mainNotifier.daySensitivitySpaceShortLow30,
          attackKeyValue: KeyValue.dayShortAttack30,
          middleKeyValue: KeyValue.dayShortMiddle30,
          defenseKeyValue: KeyValue.dayShortDefense30,
        )
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
          lowOnChange: _mainNotifier.nightSensitivitySpaceLongLow15,
          attackKeyValue: KeyValue.nightLongAttack15,
          middleKeyValue: KeyValue.nightLongMiddle15,
          defenseKeyValue: KeyValue.nightLongDefense15,
        ),
        sensitivitySpace(
          direction: Direction.long30,
          bg: winColor.withOpacity(0.2),
          sensitivitySpace: _state.nightSensitivitySpace30,
          highOnChange: _mainNotifier.nightSensitivitySpaceLongHigh30,
          lowOnChange: _mainNotifier.nightSensitivitySpaceLongLow30,
          attackKeyValue: KeyValue.nightLongAttack30,
          middleKeyValue: KeyValue.nightLongMiddle30,
          defenseKeyValue: KeyValue.nightLongDefense30,
        ),
        sensitivitySpace(
          direction: Direction.short15,
          bg: loseColor.withOpacity(0.2),
          sensitivitySpace: _state.nightSensitivitySpace15,
          highOnChange: _mainNotifier.nightSensitivitySpaceShortHigh15,
          lowOnChange: _mainNotifier.nightSensitivitySpaceShortLow15,
          attackKeyValue: KeyValue.nightShortAttack15,
          middleKeyValue: KeyValue.nightShortMiddle15,
          defenseKeyValue: KeyValue.nightShortDefense15,
        ),
        sensitivitySpace(
          direction: Direction.short30,
          bg: loseColor.withOpacity(0.2),
          sensitivitySpace: _state.nightSensitivitySpace30,
          highOnChange: _mainNotifier.nightSensitivitySpaceShortHigh30,
          lowOnChange: _mainNotifier.nightSensitivitySpaceShortLow30,
          attackKeyValue: KeyValue.nightShortAttack30,
          middleKeyValue: KeyValue.nightShortMiddle30,
          defenseKeyValue: KeyValue.nightShortDefense30,
        )
      ],
    );
    return ColoredBox(
      color: Colors.yellow,
      child: content,
    );
  }

  Widget get _keyValueList {
    double maxW = 0;
    for (MapEntry<KeyValue, num> element in _mainNotifier.keyValues) {
      double w = textSize(element.key.title, infoST).width;
      if (w > maxW) maxW = w;
    }
    maxW += 16;

    int indexOfCurrent = _mainNotifier.keyValues
        .indexWhere((element) => element.key == KeyValue.current);
    int largeDis = indexOfCurrent;
    int smallDis = _mainNotifier.keyValues.length - indexOfCurrent;
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title('關鍵價位列表', leftLine: false, bottomLine: false),
        ColoredBox(
          color: const Color(0xFFFAFAFA),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_mainNotifier.keyValues.isEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '請先輸入關鍵價位（現價、高點、低點、靈敏度空間高低點）',
                    style: titleST,
                  ),
                ),
              ..._mainNotifier.keyValues.map((e) {
                int index = _mainNotifier.keyValues.indexWhere(
                  (element) => element.key == e.key,
                );
                num valueDis =
                    e.value - _mainNotifier.keyValues[indexOfCurrent].value;
                int indexDis = indexOfCurrent - index;
                Color noticeBg = indexDis == 0
                    ? noteColor.withOpacity(0.5)
                    : indexDis.abs() < 4
                        ? indexDis > 0
                            ? winColor.withOpacity(0.4 - indexDis.abs() * 0.1)
                            : loseColor.withOpacity(0.4 - indexDis.abs() * 0.1)
                        : Colors.transparent;

                Widget content = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: maxW,
                      child: Center(
                        child: title(e.key.title),
                      ),
                    ),
                    title(e.value),
                    ...[
                      indexDis == 0
                          ? Container(
                              width: infoW,
                              height: textH,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: loseColor,
                                    size: 20,
                                  ),
                                  Text(
                                    '價差',
                                    style: infoST,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_up,
                                    color: winColor,
                                    size: 20,
                                  ),
                                ],
                              ),
                            )
                          : info(
                              '${valueDis! > 0 ? '+' : ''}$valueDis',
                              color: valueDis > 0
                                  ? winColor
                                  : valueDis < 0
                                      ? loseColor
                                      : Colors.transparent,
                              topLine: true,
                              rightLine: true,
                              leftLine: true,
                              bottomLine: e != _mainNotifier.keyValues.last,
                            ),
                    ]
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
    required KeyValue attackKeyValue,
    required KeyValue middleKeyValue,
    required KeyValue defenseKeyValue,
    bool topLine = false,
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
      bool long = true,
      required int? attack,
      required double? middle,
      required int? defense,
      required KeyValue attackKeyValue,
      required KeyValue middleKeyValue,
      required KeyValue defenseKeyValue,
      required double infoW,
    }) {
      List<Widget> children = [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                if (_state.considerKeyValue[attackKeyValue] != null) {
                  _mainNotifier.considerKeyValue(attackKeyValue,
                      !_state.considerKeyValue[attackKeyValue]!);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                )),
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        child: _checkbox(attackKeyValue)),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        title('攻擊', line: false)
                      ],
                    )
                  ],
                ),
              ),
            ),
            info(attack, width: infoW),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                if (_state.considerKeyValue[middleKeyValue] != null) {
                  _mainNotifier.considerKeyValue(middleKeyValue,
                      !_state.considerKeyValue[middleKeyValue]!);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                )),
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        child: _checkbox(middleKeyValue)),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        title('中關', line: false)
                      ],
                    )
                  ],
                ),
              ),
            ),
            info(middle, width: infoW),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                if (_state.considerKeyValue[defenseKeyValue] != null) {
                  _mainNotifier.considerKeyValue(defenseKeyValue,
                      !_state.considerKeyValue[defenseKeyValue]!);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                )),
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        child: _checkbox(defenseKeyValue)),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        title('防守', line: false)
                      ],
                    )
                  ],
                ),
              ),
            ),
            info(defense, width: infoW),
          ],
        ),
      ];
      return Column(
        children: long ? children : children.reversed.toList(),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: topLine
            ? Border.all(color: Colors.grey.shade300, width: 1)
            : Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                left: BorderSide(color: Colors.grey.shade300, width: 1),
                right: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
      ),
      child: ColoredBox(
        color: bg,
        child: Row(
          children: [
            title(direction.typeName,
                padding: const EdgeInsets.symmetric(horizontal: 8),
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
                long: direction.isLong,
                attack: direction.isLong
                    ? sensitivitySpace.longAttack
                    : sensitivitySpace.shortAttack,
                middle: direction.isLong
                    ? sensitivitySpace.longMiddle
                    : sensitivitySpace.shortMiddle,
                defense: direction.isLong
                    ? sensitivitySpace.longDefense
                    : sensitivitySpace.shortDefense,
                attackKeyValue: attackKeyValue,
                middleKeyValue: middleKeyValue,
                defenseKeyValue: defenseKeyValue,
                infoW: infoW * 1.15)
          ],
        ),
      ),
    );
  }

  Widget textField(dynamic init, ValueChanged<String> onChanged,
      [String? hint = '請輸入']) {
    final controller = TextEditingController(text: init?.toString() ?? '');
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
    return Container(
      constraints: BoxConstraints(maxWidth: infoW, maxHeight: textH),
      alignment: Alignment.bottomCenter,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: infoST,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: infoST.copyWith(
                fontSize: max(1, infoST.fontSize! - 4),
                color: Colors.grey.withOpacity(0.75))),
        onChanged: onChanged,
      ),
    );
  }

  Widget _checkbox(KeyValue? keyValue) {
    Widget content = Checkbox(
      activeColor: Colors.blue,
      side: const BorderSide(
        color: Colors.grey,
        width: 1,
      ),
      value:
          keyValue != null ? _state.considerKeyValue[keyValue] ?? true : false,
      onChanged: (bool? enable) {
        if (keyValue == null) return;
        if (enable == null) return;
        _mainNotifier.considerKeyValue(keyValue, enable);
      },
    );
    return Transform.scale(scale: 0.7, child: content);
  }

  Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
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

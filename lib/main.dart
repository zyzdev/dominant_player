import 'dart:math';

import 'package:dominant_player/main_provider.dart';
import 'package:dominant_player/model/spy_state.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:dominant_player/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'model/key_value.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: MyApp(),
      ),
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

  final ValueNotifier<double> _sensitivitySpaceWidth = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    ref.watch(mainProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('絕對主力邏輯計算器'),
        backgroundColor: const Color(0xff4d2bab),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, // 垂直滾動
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, //
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _spy,
              ValueListenableBuilder(
                valueListenable: _sensitivitySpaceWidth,
                builder: (context, width, child) {
                  Widget content = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _daySensitivitySpace,
                      _nightSensitivitySpace,
                      _customizeSensitivitySpace
                    ],
                  );
                  if (width == 0) {
                    return MeasureSize(
                      child: content,
                      onChange: (size) {
                        if (size.width > width) {
                          _sensitivitySpaceWidth.value = size.width * 1.1;
                        }
                      },
                    );
                  }
                  return Container(
                    constraints: BoxConstraints(minWidth: width),
                    child: content,
                  );
                },
              ),
              _keyValueList
            ],
          ),
        ),
      ),
    );
  }

  Widget get _spy {
    Widget content = Column(
      children: [
        title('SPY', line: false),
        ColoredBox(
          color: const Color(0xFFFAFAFA),
          child: Column(
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
                        if (e.key == KeyValue.range ||
                            e.key == KeyValue.rangeDiv4) return;

                        _mainNotifier.considerKeyValue(e.key.title,
                            !(_state.considerKeyValue[e.key.title] ?? false));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: e.key == KeyValue.high ||
                                    e.key == KeyValue.low ||
                                    e.key == KeyValue.range ||
                                    e.key == KeyValue.rangeDiv4
                                ? Colors.white
                                : e.key.bg,
                            border: e == _mainNotifier.spyValues.last
                                ? Border.all(
                                    color: Colors.grey.shade400, width: 1)
                                : Border(
                                    top: BorderSide(
                                        color: Colors.grey.shade400, width: 1),
                                    left: BorderSide(
                                        color: Colors.grey.shade400, width: 1),
                                    right: BorderSide(
                                        color: Colors.grey.shade400, width: 1),
                                  )),
                        child: Stack(
                          children: [
                            if (e.key != KeyValue.range &&
                                e.key != KeyValue.rangeDiv4)
                              Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  child: _checkbox(e.key.title)),
                            Row(
                              children: [
                                const SizedBox(width: 16),
                                title(e.key.title,
                                    color: e.key == KeyValue.high ||
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
                    e.key == KeyValue.current ||
                            e.key == KeyValue.high ||
                            e.key == KeyValue.low
                        ? textField(
                            init: e.value,
                            onChanged: (value) {
                              if (e.key == KeyValue.high) {
                                _mainNotifier.high = value;
                              } else if (e.key == KeyValue.low) {
                                _mainNotifier.low = value;
                              }
                            })
                        : info(e.value),
                  ],
                );
              })
            ],
          ),
        )
      ],
    );
    return ColoredBox(
      color: Colors.lightGreen,
      child: content,
    );
  }

  Widget get _daySensitivitySpace {
    Widget content = AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: SizedBox(
        height: _state.daySensitivitySpaceExpend ? null : 0,
        child: Column(
          children: [
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
        ),
      ),
    );

    content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [title('日盤靈敏度空間', line: false), content],
    );

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), color: Colors.yellow),
      constraints: BoxConstraints(minWidth: _sensitivitySpaceWidth.value),
      alignment: Alignment.center,
      child: Stack(
        children: [
          SizedBox(width: _sensitivitySpaceWidth.value),
          content,
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () {
                _mainNotifier.daySensitivitySpaceExpend(
                    !_state.daySensitivitySpaceExpend);
              },
              icon: Icon(_state.daySensitivitySpaceExpend
                  ? Icons.arrow_drop_down
                  : Icons.arrow_drop_up),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _nightSensitivitySpace {
    Widget content = AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: SizedBox(
        height: _state.nightSensitivitySpaceExpend ? null : 0,
        child: Column(
          children: [
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
        ),
      ),
    );

    content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [title('夜盤靈敏度空間', line: false), content],
    );

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), color: Colors.yellow),
      constraints: BoxConstraints(
        minWidth: _sensitivitySpaceWidth.value,
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          SizedBox(width: _sensitivitySpaceWidth.value),
          content,
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () {
                _mainNotifier.nightSensitivitySpaceExpend(
                    !_state.nightSensitivitySpaceExpend);
              },
              icon: Icon(_state.nightSensitivitySpaceExpend
                  ? Icons.arrow_drop_down
                  : Icons.arrow_drop_up),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _customizeSensitivitySpace {
    Widget content = AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: SizedBox(
        height: _state.customizeSensitivitySpaceExpend ? null : 0,
        child: Column(
          children: [
            ..._state.customizeSensitivitySpaces.map((e) =>
                customizeSensitivitySpace(
                  bg: e.direction.isLong
                      ? winColor.withOpacity(0.2)
                      : loseColor.withOpacity(0.2),
                  customizeSensitivitySpace: e,
                  highOnChange: _mainNotifier.setCustomizeSensitivitySpaceHigh,
                  lowOnChange: _mainNotifier.setCustomizeSensitivitySpaceLow,
                )),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _mainNotifier.addCustomizeSensitivitySpace();
              },
              child: const Row(
                children: [Icon(Icons.add), Text('新增自定義')],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title('自定義靈敏度空間', line: false),
        content,
      ],
    );

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), color: Colors.blueGrey),
      constraints: BoxConstraints(minWidth: _sensitivitySpaceWidth.value),
      child: Stack(
        children: [
          SizedBox(width: _sensitivitySpaceWidth.value),
          content,
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () {
                _mainNotifier.customizeSensitivitySpaceExpend(
                    !_state.customizeSensitivitySpaceExpend);
              },
              icon: Icon(_state.customizeSensitivitySpaceExpend
                  ? Icons.arrow_drop_down
                  : Icons.arrow_drop_up),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _keyValueList {
    double maxW = 0;
    for (MapEntry<String, num> element in _mainNotifier.keyValues) {
      double w = textSize(element.key, infoST).width;
      if (w > maxW) maxW = w;
    }
    maxW += 16;
    int indexOfCurrent = _mainNotifier.keyValues
        .indexWhere((element) => element.key == KeyValue.current.title);
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title('關鍵價位列表', line: false),
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
                num valueDis = indexOfCurrent == -1 || _state.current == null
                    ? 0
                    : e.value - _mainNotifier.keyValues[indexOfCurrent].value;
                int indexDis = indexOfCurrent - index;
                Color noticeBg = indexOfCurrent == -1
                    ? Colors.transparent
                    : indexDis == 0
                        ? noteColor.withOpacity(0.5)
                        : indexDis.abs() < 4
                            ? indexDis > 0
                                ? winColor
                                    .withOpacity(0.4 - indexDis.abs() * 0.1)
                                : loseColor
                                    .withOpacity(0.4 - indexDis.abs() * 0.1)
                            : Colors.transparent;

                Widget content = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: maxW,
                      child: Center(
                        child: title(e.key),
                      ),
                    ),
                    indexDis == 0
                        ? textField(
                            init: e.value > 0 ? e.value : null,
                            onChanged: (value) {
                              _mainNotifier.current = value;
                            },
                          )
                        : title(e.value),
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
                              '${valueDis > 0 ? '+' : ''}$valueDis',
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
                  color: noticeBg,
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
                textField(init: high, onChanged: highOnChange)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                title('低點', rightLine: true),
                textField(init: low, onChanged: lowOnChange)
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
                if (_state.considerKeyValue[attackKeyValue.title] != null) {
                  _mainNotifier.considerKeyValue(attackKeyValue.title,
                      !_state.considerKeyValue[attackKeyValue.title]!);
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
                        child: _checkbox(attackKeyValue.title)),
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
                if (_state.considerKeyValue[middleKeyValue.title] != null) {
                  _mainNotifier.considerKeyValue(middleKeyValue.title,
                      !_state.considerKeyValue[middleKeyValue.title]!);
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
                        child: _checkbox(middleKeyValue.title)),
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
                if (_state.considerKeyValue[defenseKeyValue.title] != null) {
                  _mainNotifier.considerKeyValue(defenseKeyValue.title,
                      !_state.considerKeyValue[defenseKeyValue.title]!);
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
                        child: _checkbox(defenseKeyValue.title)),
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
            ? Border.all(color: Colors.grey.shade400, width: 1)
            : Border(
                bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                left: BorderSide(color: Colors.grey.shade400, width: 1),
                right: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
      ),
      child: Container(
        constraints: BoxConstraints(minWidth: _sensitivitySpaceWidth.value),
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

  Widget customizeSensitivitySpace({
    required Color bg,
    required CustomizeSensitivitySpace customizeSensitivitySpace,
    required Function(
            CustomizeSensitivitySpace customizeSensitivitySpace, String value)
        highOnChange,
    required Function(
            CustomizeSensitivitySpace customizeSensitivitySpace, String value)
        lowOnChange,
    bool topLine = false,
  }) {
    Widget hAndL({
      required int? high,
      required int? low,
      required Function(
              CustomizeSensitivitySpace customizeSensitivitySpace, String value)
          highOnChange,
      required Function(
              CustomizeSensitivitySpace customizeSensitivitySpace, String value)
          lowOnChange,
    }) =>
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                title('高點', rightLine: true),
                textField(
                  init: high,
                  onChanged: (value) {
                    highOnChange(customizeSensitivitySpace, value);
                  },
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                title('低點', rightLine: true),
                textField(
                  init: low,
                  onChanged: (value) {
                    lowOnChange(customizeSensitivitySpace, value);
                  },
                )
              ],
            ),
          ],
        );

    // 攻擊、中關、防守
    Widget amd({
      required CustomizeSensitivitySpace customizeSensitivitySpace,
      required double infoW,
    }) {
      List<Widget> children = [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                _mainNotifier.considerKeyValue(
                    customizeSensitivitySpace.attackKeyTitle,
                    !(_state.considerKeyValue[
                            customizeSensitivitySpace.attackKeyTitle] ??
                        true));
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
                        child: _checkbox(
                            customizeSensitivitySpace.attackKeyTitle)),
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
            info(customizeSensitivitySpace.attack, width: infoW),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                _mainNotifier.considerKeyValue(
                    customizeSensitivitySpace.middleKeyTitle,
                    !(_state.considerKeyValue[
                            customizeSensitivitySpace.middleKeyTitle] ??
                        true));
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
                        child: _checkbox(
                            customizeSensitivitySpace.middleKeyTitle)),
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
            info(customizeSensitivitySpace.middle, width: infoW),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                _mainNotifier.considerKeyValue(
                    customizeSensitivitySpace.defenseKeyTitle,
                    !(_state.considerKeyValue[
                            customizeSensitivitySpace.defenseKeyTitle] ??
                        true));
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
                        child: _checkbox(
                            customizeSensitivitySpace.defenseKeyTitle)),
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
            info(customizeSensitivitySpace.defense, width: infoW),
          ],
        ),
      ];
      return Column(
        children: customizeSensitivitySpace.direction.isLong
            ? children
            : children.reversed.toList(),
      );
    }

    Size nameSize = textSize(customizeSensitivitySpace.title, infoST);
    return Container(
      constraints: BoxConstraints(minWidth: _sensitivitySpaceWidth.value),
      decoration: BoxDecoration(
        color: Colors.white,
        border: topLine
            ? Border.all(color: Colors.grey.shade400, width: 1)
            : Border(
                bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                left: BorderSide(color: Colors.grey.shade400, width: 1),
                right: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
      ),
      child: ColoredBox(
        color: bg,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: max(infoW, nameSize.width * 1.1) + 16,
                  alignment: Alignment.centerLeft,
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _confirmDialog(customizeSensitivitySpace.title)
                              .then((remove) {
                            if (remove == true) {
                              _mainNotifier.removeCustomizeSensitivitySpace(
                                  customizeSensitivitySpace);
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
                ),
                Column(
                  children: [
                    SizedBox(
                      width: max(infoW * 1.8, nameSize.width * 1.1) + 16,
                      child: textField(
                          init: customizeSensitivitySpace.title,
                          onChanged: (value) {
                            _mainNotifier.setCustomizeSensitivitySpaceTitle(
                                customizeSensitivitySpace, value);
                          },
                          keyboardType: TextInputType.text,
                          error: _mainNotifier
                                  .isCustomizeSensitivitySpaceTitleDuplicate(
                                      customizeSensitivitySpace.title,
                                      customizeSensitivitySpace)
                              ? '名稱請不要重複！'
                              : null),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: ToggleSwitch(
                        initialLabelIndex:
                            customizeSensitivitySpace.direction.isLong ? 0 : 1,
                        totalSwitches: 2,
                        cornerRadius: 20.0,
                        fontSize: 12,
                        minWidth: 50,
                        minHeight: 30,
                        labels: const ["多方", "空方"],
                        activeBgColors: const [
                          [Colors.red],
                          [Colors.green]
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey.shade400,
                        inactiveFgColor: Colors.black54,
                        onToggle: (index) {
                          _mainNotifier.setCustomizeSensitivitySpaceDirection(
                              customizeSensitivitySpace,
                              index == 0
                                  ? Direction.customizeLong
                                  : Direction.customizeShort);
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
            hAndL(
              high: customizeSensitivitySpace.high,
              low: customizeSensitivitySpace.low,
              highOnChange: highOnChange,
              lowOnChange: lowOnChange,
            ),
            amd(
                customizeSensitivitySpace: customizeSensitivitySpace,
                infoW: infoW * 1.15)
          ],
        ),
      ),
    );
  }

  Widget textField({
    dynamic init,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType = TextInputType.number,
    String? hint = '請輸入',
    String? error,
  }) {
    final controller = TextEditingController(text: init?.toString() ?? '');
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
    return Container(
      constraints: BoxConstraints(maxWidth: infoW, maxHeight: textH),
      alignment: Alignment.bottomCenter,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.text,
        style: infoST,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            errorText: error,
            hintText: hint,
            hintStyle: infoST.copyWith(
                fontSize: max(1, infoST.fontSize! - 4),
                color: Colors.grey.withOpacity(0.75))),
        onChanged: onChanged,
      ),
    );
  }

  Widget _checkbox(String? keyValue) {
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

  Future<bool?> _confirmDialog(String title) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "再次確認",
            style: titleST,
          ),
          content: Text.rich(
            TextSpan(style: infoST, children: [
              const TextSpan(text: '您確定要刪除"'),
              TextSpan(
                  text: title,
                  style: infoST.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  )),
              const TextSpan(text: '"嗎？'),
            ]),
            style: infoST,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "取消",
                style: infoST,
              ),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            TextButton(
              child: Text(
                "刪除",
                style: infoST.copyWith(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
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

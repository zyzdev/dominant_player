import 'package:dominant_player/model/key_value.dart';
import 'package:dominant_player/model/sensitivity_space_state.dart';
import 'package:dominant_player/widgets/sensitivity_space/sensitivity_space_state_provider.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:dominant_player/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SensitivitySpaceWidget extends ConsumerStatefulWidget {
  const SensitivitySpaceWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SensitivitySpaceWidgetState();
}

class _SensitivitySpaceWidgetState extends ConsumerState {
  SensitivitySpaceState get _state =>
      ref.read(sensitivitySpaceStateNotifierProvider);

  SensitivitySpaceMainNotifier get _notifier =>
      ref.read(sensitivitySpaceStateNotifierProvider.notifier);

  final ValueNotifier<double> _sensitivitySpaceWidth = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    ref.watch(sensitivitySpaceStateNotifierProvider);
    Widget content = ValueListenableBuilder<double>(
      valueListenable: _sensitivitySpaceWidth,
      builder: (context, width, child) {
        Widget content = _sensitivitySpaceWidth.value == 0
            ? Column(
                children: [
                  for (int i = 0;
                      i < _state.sensitivitySpaceWidgetIndex.length;
                      i++)
                    _sensitivitySpaceWidget(
                        i, _state.sensitivitySpaceWidgetIndex[i])
                ],
              )
            : ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: _sensitivitySpaceWidth.value),
                child: ReorderableListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  buildDefaultDragHandles: false,
                  onReorder: _notifier.exchangeSensitivitySpaceWidgetIndex,
                  children: [
                    for (int i = 0;
                        i < _state.sensitivitySpaceWidgetIndex.length;
                        i++)
                      _sensitivitySpaceWidget(
                          i, _state.sensitivitySpaceWidgetIndex[i])
                  ],
                ),
              );
        if (width == 0) {
          return MeasureSize(
            child: content,
            onChange: (size) {
              if (size.width > width) {
                _sensitivitySpaceWidth.value = size.width;
              }
            },
          );
        }
        return Container(
          constraints: BoxConstraints(minWidth: width),
          child: content,
        );
      },
    );

    content = Column(
      children: [title('靈敏度空間', line: false), content],
    );
    content = Stack(
      children: [
        // 標題的底色
        Positioned(
            left: 0,
            right: 0,
            child: ColoredBox(
              color: Colors.purple.shade300,
              child: SizedBox(
                height: textH,
                width: double.infinity,
              ),
            )),
        content
      ],
    );

    return content;
  }

  Widget _sensitivitySpaceWidget(
      int index, SensitivitySpaceType sensitivitySpaceType) {
    Widget content;
    switch (sensitivitySpaceType) {
      case SensitivitySpaceType.day:
        content = _daySensitivitySpace(index);
        break;
      case SensitivitySpaceType.night:
        content = _nightSensitivitySpace(index);
        break;
      case SensitivitySpaceType.customize:
        content = _customizeSensitivitySpace(index);
        break;
      case SensitivitySpaceType.value:
        content = _customizeValues(index);
        break;
    }
    content = SizedBox(
      key: ValueKey(sensitivitySpaceType),
      child: content,
    );
    return content;
  }

  Widget _daySensitivitySpace(int index) {
    Widget content = AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: SizedBox(
        height: _state.daySensitivitySpaceExpand ? null : 0,
        child: Column(
          children: [
            sensitivitySpace(
              direction: Direction.long15,
              bg: winColor.withOpacity(0.2),
              sensitivitySpace: _state.daySensitivitySpace15,
              highOnChange: _notifier.daySensitivitySpaceLongHigh15,
              lowOnChange: _notifier.daySensitivitySpaceLongLow15,
              attackKeyValue: KeyValue.dayLongAttack15,
              middleKeyValue: KeyValue.dayLongMiddle15,
              defenseKeyValue: KeyValue.dayLongDefense15,
              topLine: true,
            ),
            sensitivitySpace(
              direction: Direction.long30,
              bg: winColor.withOpacity(0.2),
              sensitivitySpace: _state.daySensitivitySpace30,
              highOnChange: _notifier.daySensitivitySpaceLongHigh30,
              lowOnChange: _notifier.daySensitivitySpaceLongLow30,
              attackKeyValue: KeyValue.dayLongAttack30,
              middleKeyValue: KeyValue.dayLongMiddle30,
              defenseKeyValue: KeyValue.dayLongDefense30,
            ),
            sensitivitySpace(
              direction: Direction.short15,
              bg: loseColor.withOpacity(0.2),
              sensitivitySpace: _state.daySensitivitySpace15,
              highOnChange: _notifier.daySensitivitySpaceShortHigh15,
              lowOnChange: _notifier.daySensitivitySpaceShortLow15,
              attackKeyValue: KeyValue.dayShortAttack15,
              middleKeyValue: KeyValue.dayShortMiddle15,
              defenseKeyValue: KeyValue.dayShortDefense15,
            ),
            sensitivitySpace(
              direction: Direction.short30,
              bg: loseColor.withOpacity(0.2),
              sensitivitySpace: _state.daySensitivitySpace30,
              highOnChange: _notifier.daySensitivitySpaceShortHigh30,
              lowOnChange: _notifier.daySensitivitySpaceShortLow30,
              attackKeyValue: KeyValue.dayShortAttack30,
              middleKeyValue: KeyValue.dayShortMiddle30,
              defenseKeyValue: KeyValue.dayShortDefense30,
              bottomLine: false,
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
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      constraints: BoxConstraints(minWidth: _sensitivitySpaceWidth.value),
      alignment: Alignment.center,
      child: Stack(
        children: [
          SizedBox(width: _sensitivitySpaceWidth.value),
          // 標題的底色
          Positioned(
              left: 0,
              right: 0,
              child: ColoredBox(
                color: Colors.amber.shade100,
                child: SizedBox(
                  height: textH,
                  width: double.infinity,
                ),
              )),
          content,
          Positioned(
            left: 0,
            top: 0,
            child: ReorderableDragStartListener(
              index: index,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.drag_handle),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () {
                _notifier.daySensitivitySpaceExpand(
                    !_state.daySensitivitySpaceExpand);
              },
              icon: Icon(!_state.daySensitivitySpaceExpand
                  ? Icons.arrow_drop_down
                  : Icons.arrow_drop_up),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nightSensitivitySpace(int index) {
    Widget content = AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: SizedBox(
        height: _state.nightSensitivitySpaceExpand ? null : 0,
        child: Column(
          children: [
            sensitivitySpace(
              direction: Direction.long15,
              bg: winColor.withOpacity(0.2),
              sensitivitySpace: _state.nightSensitivitySpace15,
              highOnChange: _notifier.nightSensitivitySpaceLongHigh15,
              lowOnChange: _notifier.nightSensitivitySpaceLongLow15,
              attackKeyValue: KeyValue.nightLongAttack15,
              middleKeyValue: KeyValue.nightLongMiddle15,
              defenseKeyValue: KeyValue.nightLongDefense15,
              topLine: true,
            ),
            sensitivitySpace(
              direction: Direction.long30,
              bg: winColor.withOpacity(0.2),
              sensitivitySpace: _state.nightSensitivitySpace30,
              highOnChange: _notifier.nightSensitivitySpaceLongHigh30,
              lowOnChange: _notifier.nightSensitivitySpaceLongLow30,
              attackKeyValue: KeyValue.nightLongAttack30,
              middleKeyValue: KeyValue.nightLongMiddle30,
              defenseKeyValue: KeyValue.nightLongDefense30,
            ),
            sensitivitySpace(
              direction: Direction.short15,
              bg: loseColor.withOpacity(0.2),
              sensitivitySpace: _state.nightSensitivitySpace15,
              highOnChange: _notifier.nightSensitivitySpaceShortHigh15,
              lowOnChange: _notifier.nightSensitivitySpaceShortLow15,
              attackKeyValue: KeyValue.nightShortAttack15,
              middleKeyValue: KeyValue.nightShortMiddle15,
              defenseKeyValue: KeyValue.nightShortDefense15,
            ),
            sensitivitySpace(
              direction: Direction.short30,
              bg: loseColor.withOpacity(0.2),
              sensitivitySpace: _state.nightSensitivitySpace30,
              highOnChange: _notifier.nightSensitivitySpaceShortHigh30,
              lowOnChange: _notifier.nightSensitivitySpaceShortLow30,
              attackKeyValue: KeyValue.nightShortAttack30,
              middleKeyValue: KeyValue.nightShortMiddle30,
              defenseKeyValue: KeyValue.nightShortDefense30,
              bottomLine: false,
            )
          ],
        ),
      ),
    );

    // 字體顏色為標題底色的互補色
    content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [title('夜盤靈敏度空間', line: false), content],
    );

    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      constraints: BoxConstraints(
        minWidth: _sensitivitySpaceWidth.value,
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          SizedBox(width: _sensitivitySpaceWidth.value),
          // 標題的底色
          Positioned(
              left: 0,
              right: 0,
              child: ColoredBox(
                color: Colors.amber.shade100,
                child: SizedBox(
                  height: textH,
                  width: double.infinity,
                ),
              )),
          content,
          Positioned(
            left: 0,
            top: 0,
            child: ReorderableDragStartListener(
              index: index,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.drag_handle),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () {
                _notifier.nightSensitivitySpaceExpand(
                    !_state.nightSensitivitySpaceExpand);
              },
              icon: Icon(!_state.nightSensitivitySpaceExpand
                  ? Icons.arrow_drop_down
                  : Icons.arrow_drop_up),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customizeSensitivitySpace(int index) {
    Widget content = AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: SizedBox(
        height: _state.customizeSensitivitySpaceExpand ? null : 0,
        child: Column(
          children: [
            SizedBox(width: _sensitivitySpaceWidth.value),
            ..._state.customizeSensitivitySpaces
                .map((e) => customizeSensitivitySpace(
                      bg: e.direction.isLong
                          ? winColor.withOpacity(0.2)
                          : loseColor.withOpacity(0.2),
                      customizeSensitivitySpace: e,
                      highOnChange: _notifier.setCustomizeSensitivitySpaceHigh,
                      lowOnChange: _notifier.setCustomizeSensitivitySpaceLow,
                      topLine: _state.customizeSensitivitySpaces.first == e,
                      bottomLine: _state.customizeSensitivitySpaces.last != e,
                    )),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: winColor,
                    size: 20,
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(width: 1.5, color: winColor),
                  ),
                  label: Text(
                    '新增自定義多方邏輯',
                    style: TextStyle(color: winColor),
                  ),
                  onPressed: () {
                    _notifier.addCustomizeSensitivitySpace();
                  },
                ),
                const SizedBox(width: 32),
                OutlinedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: loseColor,
                    size: 20,
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(width: 1.5, color: loseColor),
                  ),
                  onPressed: () {
                    _notifier
                        .addCustomizeSensitivitySpace(Direction.customizeShort);
                  },
                  label: Text(
                    '新增自定義空方邏輯',
                    style: TextStyle(color: loseColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      constraints: BoxConstraints(minWidth: _sensitivitySpaceWidth.value),
      child: Stack(
        children: [
          SizedBox(width: _sensitivitySpaceWidth.value),
          // 標題的底色
          Positioned(
              left: 0,
              right: 0,
              child: ColoredBox(
                color: Colors.amber.shade100,
                child: SizedBox(
                  height: textH,
                  width: double.infinity,
                ),
              )),
          content,
          Positioned(
            left: 0,
            top: 0,
            child: ReorderableDragStartListener(
              index: index,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.drag_handle),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () {
                _notifier.customizeSensitivitySpaceExpand(
                    !_state.customizeSensitivitySpaceExpand);
              },
              icon: Icon(!_state.customizeSensitivitySpaceExpand
                  ? Icons.arrow_drop_down
                  : Icons.arrow_drop_up),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customizeValues(int index) {
    Widget content = AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: SizedBox(
        height: _state.customizeValuesExpand ? null : 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: _sensitivitySpaceWidth.value),
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: _sensitivitySpaceWidth.value),
                  ..._state.customizeValues.map((e) {
                    Widget content = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                confirmDialog(e.title, context).then((remove) {
                                  if (remove == true) {
                                    _notifier.removeCustomizeValue(e);
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
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Stack(
                                children: [
                                  // 留下最小寬度
                                  SizedBox(width: infoW),
                                  // 用Text把widget的寬度長出來
                                  // 以讓textField可以到最寬
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      e.title,
                                      style: titleST.copyWith(
                                          color:
                                              Colors.black.withOpacity(0.01)),
                                    ),
                                  ),
                                  Positioned.fill(
                                      child: textField(
                                    init: e.title,
                                    onChanged: (value) {
                                      _notifier.setCustomizeValueTitle(
                                          e, value);
                                    },
                                    keyboardType: TextInputType.text,
                                  ))
                                ],
                              ),
                            ),
                            _checkbox(e.title),
                            textField(
                              init: e.value,
                              onChanged: (value) {
                                _notifier.setCustomizeValueValue(e, value);
                              },
                            )
                          ],
                        )
                      ],
                    );
                    return Container(
                        constraints: BoxConstraints(
                            minWidth: _sensitivitySpaceWidth.value),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                        )),
                        child: content);
                  }).toList()
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(
                Icons.add,
                size: 20,
              ),
              onPressed: () {
                _notifier.addCustomizeValue();
              },
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.lightBlueAccent)),
              label: const Text('新增自定義關鍵價'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title('自定義關鍵價', line: false),
        content,
      ],
    );

    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      constraints: BoxConstraints(minWidth: _sensitivitySpaceWidth.value),
      child: Stack(
        children: [
          SizedBox(width: _sensitivitySpaceWidth.value),
          // 標題的底色
          Positioned(
              left: 0,
              right: 0,
              child: ColoredBox(
                color: Colors.amber.shade100,
                child: SizedBox(
                  height: textH,
                  width: double.infinity,
                ),
              )),
          content,
          Positioned(
            left: 0,
            top: 0,
            child: ReorderableDragStartListener(
              index: index,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.drag_handle),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () {
                _notifier.customizeValueExpand(!_state.customizeValuesExpand);
              },
              icon: Icon(!_state.customizeValuesExpand
                  ? Icons.arrow_drop_down
                  : Icons.arrow_drop_up),
            ),
          ),
        ],
      ),
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
    bool bottomLine = true,
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
                  _notifier.considerKeyValue(attackKeyValue.title,
                      !_state.considerKeyValue[attackKeyValue.title]!);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(color: Colors.grey.shade300, width: 1),
                  right: BorderSide(color: Colors.grey.shade300, width: 1),
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
            info(attack, width: infoW, leftLine: false, rightLine: false),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                if (_state.considerKeyValue[middleKeyValue.title] != null) {
                  _notifier.considerKeyValue(middleKeyValue.title,
                      !_state.considerKeyValue[middleKeyValue.title]!);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1)),
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
            info(middle, width: infoW, leftLine: false, rightLine: false),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                if (_state.considerKeyValue[defenseKeyValue.title] != null) {
                  _notifier.considerKeyValue(defenseKeyValue.title,
                      !_state.considerKeyValue[defenseKeyValue.title]!);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(color: Colors.grey.shade300, width: 1),
                  right: BorderSide(color: Colors.grey.shade300, width: 1),
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
            info(defense, width: infoW, leftLine: false, rightLine: false),
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
        border: Border(
          bottom: bottomLine
              ? BorderSide(color: Colors.grey.shade300, width: 1)
              : BorderSide.none,
          top: topLine
              ? BorderSide(color: Colors.grey.shade300, width: 1)
              : BorderSide.none,
        ),
      ),
      child: Container(
        constraints: BoxConstraints(minWidth: _sensitivitySpaceWidth.value),
        color: bg,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: title(direction.typeName, line: false),
            ),
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
    bool bottomLine = true,
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
                _notifier.considerKeyValue(
                    customizeSensitivitySpace.attackKeyTitle,
                    !(_state.considerKeyValue[
                            customizeSensitivitySpace.attackKeyTitle] ??
                        true));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(color: Colors.grey.shade300, width: 1),
                  right: BorderSide(color: Colors.grey.shade300, width: 1),
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
            info(customizeSensitivitySpace.attack,
                width: infoW, leftLine: false, rightLine: false),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                _notifier.considerKeyValue(
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
            info(customizeSensitivitySpace.middle,
                width: infoW, leftLine: false, rightLine: false),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                _notifier.considerKeyValue(
                    customizeSensitivitySpace.defenseKeyTitle,
                    !(_state.considerKeyValue[
                            customizeSensitivitySpace.defenseKeyTitle] ??
                        true));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(color: Colors.grey.shade300, width: 1),
                  right: BorderSide(color: Colors.grey.shade300, width: 1),
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
            info(customizeSensitivitySpace.defense,
                width: infoW, leftLine: false, rightLine: false),
          ],
        ),
      ];
      return Column(
        children: customizeSensitivitySpace.direction.isLong
            ? children
            : children.reversed.toList(),
      );
    }

    return Container(
      constraints: BoxConstraints(minWidth: _sensitivitySpaceWidth.value),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: topLine
              ? BorderSide(color: Colors.grey.shade300, width: 1)
              : BorderSide.none,
          bottom: bottomLine
              ? BorderSide(color: Colors.grey.shade300, width: 1)
              : BorderSide.none,
        ),
      ),
      child: ColoredBox(
        color: bg,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        confirmDialog(customizeSensitivitySpace.title, context)
                            .then((remove) {
                          if (remove == true) {
                            _notifier.removeCustomizeSensitivitySpace(
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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        children: [
                          // 留下最小寬度
                          SizedBox(width: infoW),
                          // 用Text把widget的寬度長出來
                          // 以讓textField可以到最寬
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              customizeSensitivitySpace.title,
                              style: titleST.copyWith(
                                  color: Colors.black12.withOpacity(0.01)),
                            ),
                          ),
                          Positioned.fill(
                              child: textField(
                            init: customizeSensitivitySpace.title,
                            onChanged: (value) {
                              _notifier.setCustomizeSensitivitySpaceTitle(
                                  customizeSensitivitySpace, value);
                            },
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              return _notifier
                                      .isCustomizeSensitivitySpaceTitleDuplicate(
                                          customizeSensitivitySpace.title,
                                          customizeSensitivitySpace)
                                  ? '名稱勿重複！'
                                  : null;
                            },
                          ))
                        ],
                      ),
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
                        inactiveBgColor: Colors.grey.shade300,
                        inactiveFgColor: Colors.black54,
                        onToggle: (index) {
                          _notifier.setCustomizeSensitivitySpaceDirection(
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
        _notifier.considerKeyValue(keyValue, enable);
      },
    );
    return Transform.scale(scale: 0.7, child: content);
  }
}

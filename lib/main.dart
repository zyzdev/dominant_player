import 'package:dominant_player/main_provider.dart';
import 'package:dominant_player/model/spy_state.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:dominant_player/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        appBar: AppBar(title: const Text('Example')),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spy,
            _daySensitivitySpace,
            _nightSensitivitySpace,
          ],
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            title('高點', color: winColor, rightLine: true),
            textField(_state.high, (value) {
              _mainNotifier.high = value;
            }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            title('低點', color: loseColor, rightLine: true),
            textField(_state.low, (value) {
              _mainNotifier.low = value;
            }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            title('點差', rightLine: true),
            info(_state.dis),
          ],
        ),
        ColoredBox(
          color: winColor.withOpacity(0.2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              title('高成本', rightLine: true),
              info(_state.hCost),
            ],
          ),
        ),
        ColoredBox(
          color: noteColor.withOpacity(0.2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              title('中成本', rightLine: true),
              info(_state.mCost),
            ],
          ),
        ),
        ColoredBox(
          color: loseColor.withOpacity(0.2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              title('低成本', rightLine: true),
              info(_state.lCost),
            ],
          ),
        ),
        ColoredBox(
          color: winColor.withOpacity(0.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              title('超漲', rightLine: true),
              info(_state.superPress),
            ],
          ),
        ),
        ColoredBox(
          color: winColor.withOpacity(0.3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              title('壓二', rightLine: true),
              info(_state.press2),
            ],
          ),
        ),
        ColoredBox(
          color: winColor.withOpacity(0.1),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              title('壓一', rightLine: true),
              info(_state.press1),
            ],
          ),
        ),
        ColoredBox(
          color: loseColor.withOpacity(0.1),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              title('撐一', rightLine: true),
              info(_state.support1),
            ],
          ),
        ),
        ColoredBox(
          color: loseColor.withOpacity(0.3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              title('撐二', rightLine: true),
              info(_state.support2),
            ],
          ),
        ),
        ColoredBox(
          color: loseColor.withOpacity(0.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              title('超跌', rightLine: true),
              info(_state.superSupport),
            ],
          ),
        ),
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
            maxHighOnChange: _mainNotifier.daySensitivitySpaceLongHigh15,
            maxLowOnChange: _mainNotifier.daySensitivitySpaceLongLow15),
        sensitivitySpace(
            direction: Direction.long30,
            bg: winColor.withOpacity(0.2),
            sensitivitySpace: _state.daySensitivitySpace30,
            maxHighOnChange: _mainNotifier.daySensitivitySpaceLongHigh30,
            maxLowOnChange: _mainNotifier.daySensitivitySpaceLongLow30),
        sensitivitySpace(
            direction: Direction.short15,
            bg: loseColor.withOpacity(0.2),
            sensitivitySpace: _state.daySensitivitySpace15,
            maxHighOnChange: _mainNotifier.daySensitivitySpaceShortHigh15,
            maxLowOnChange: _mainNotifier.daySensitivitySpaceShortLow15),
        sensitivitySpace(
            direction: Direction.short30,
            bg: loseColor.withOpacity(0.2),
            sensitivitySpace: _state.daySensitivitySpace30,
            maxHighOnChange: _mainNotifier.daySensitivitySpaceShortHigh30,
            maxLowOnChange: _mainNotifier.daySensitivitySpaceShortLow30)
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
            maxHighOnChange: _mainNotifier.nightSensitivitySpaceLongHigh15,
            maxLowOnChange: _mainNotifier.nightSensitivitySpaceLongLow15),
        sensitivitySpace(
            direction: Direction.long30,
            bg: winColor.withOpacity(0.2),
            sensitivitySpace: _state.nightSensitivitySpace30,
            maxHighOnChange: _mainNotifier.nightSensitivitySpaceLongHigh30,
            maxLowOnChange: _mainNotifier.nightSensitivitySpaceLongLow30),
        sensitivitySpace(
            direction: Direction.short15,
            bg: loseColor.withOpacity(0.2),
            sensitivitySpace: _state.nightSensitivitySpace15,
            maxHighOnChange: _mainNotifier.nightSensitivitySpaceShortHigh15,
            maxLowOnChange: _mainNotifier.nightSensitivitySpaceShortLow15),
        sensitivitySpace(
            direction: Direction.short30,
            bg: loseColor.withOpacity(0.2),
            sensitivitySpace: _state.nightSensitivitySpace30,
            maxHighOnChange: _mainNotifier.nightSensitivitySpaceShortHigh30,
            maxLowOnChange: _mainNotifier.nightSensitivitySpaceShortLow30)
      ],
    );
    return ColoredBox(
      color: Colors.yellow,
      child: content,
    );
  }

  Widget sensitivitySpace({
    required Direction direction,
    required Color bg,
    required SensitivitySpace sensitivitySpace,
    required ValueChanged<String> maxHighOnChange,
    required ValueChanged<String> maxLowOnChange,
  }) {
    Widget hAndL({
      required int high,
      required int low,
      required ValueChanged<String> maxHighOnChange,
      required ValueChanged<String> maxLowOnChange,
    }) =>
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                title('高點', rightLine: true),
                textField(high, maxHighOnChange)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                title('低點', rightLine: true),
                textField(low, maxLowOnChange)
              ],
            ),
          ],
        );

    // 攻擊、中關、防守
    Widget amd({
      required int attack,
      required int middle,
      required int defense,
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
                  ? sensitivitySpace.maxLongHigh
                  : sensitivitySpace.maxShortHigh,
              low: direction.isLong
                  ? sensitivitySpace.maxLongLow
                  : sensitivitySpace.maxShortLow,
              maxHighOnChange: maxHighOnChange,
              maxLowOnChange: maxLowOnChange,
            ),
            amd(
                attack: direction.isLong
                    ? sensitivitySpace.maxLongAttack
                    : sensitivitySpace.maxShortAttack,
                middle: direction.isLong
                    ? sensitivitySpace.maxLongMiddle
                    : sensitivitySpace.maxShortMiddle,
                defense: direction.isLong
                    ? sensitivitySpace.maxLongDefense
                    : sensitivitySpace.maxShortDefense)
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
        onChanged: onChanged,
      ),
    );
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
        break;
      case Direction.long30:
        return '30分多方最大邏輯';
        break;
      case Direction.short15:
        return '15分空方最大邏輯';
        break;
      case Direction.short30:
        return '30分空方最大邏輯';
        break;
    }
  }
}

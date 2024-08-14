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
          children: [spy, _daySensitivitySpace],
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
    Widget hAndL({
      required int high,
      required int low,
      required ValueChanged<String> maxLongHighOnChange,
      required ValueChanged<String> maxLongLowOnChange,
    }) =>
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                title('高點', rightLine: true),
                textField(high, maxLongHighOnChange)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                title('低點', rightLine: true),
                textField(low, maxLongLowOnChange)
              ],
            ),
          ],
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title('日盤靈敏度空間', leftLine: false, bottomLine: false),
        Row(
          children: [
            title('15分多方最大邏輯',
                padding: const EdgeInsets.symmetric(horizontal: 16),
                line: false),
            hAndL(
              high: _state.daySensitivitySpace15.maxLongLow,
              low: _state.daySensitivitySpace15.maxLongLow,
              maxLongHighOnChange: _mainNotifier.daySensitivitySpaceLongHigh15,
              maxLongLowOnChange: _mainNotifier.daySensitivitySpaceLongLow15,
            )
          ],
        )
      ],
    );
  }

  Widget textField(dynamic init, ValueChanged<String> onChanged) {
    return Container(
      width: infoW,
      height: textH,
      alignment: Alignment.bottomCenter,
      child: TextField(
        controller: TextEditingController(text: init?.toString() ?? ''),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: infoST,
        onChanged: onChanged,
      ),
    );
  }
}

import 'package:dominant_player/model/key_value.dart';
import 'package:dominant_player/model/spy_state.dart';
import 'package:dominant_player/widgets/spy/spy_state_provider.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:dominant_player/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpyWidget extends ConsumerStatefulWidget {
  const SpyWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SpyWidgetState();
}

class _SpyWidgetState extends ConsumerState {
  SpyState get _state => ref.read(spyStateNotifierProvider);

  SpyMainNotifier get _notifier =>
      ref.read(spyStateNotifierProvider.notifier);

  @override
  Widget build(BuildContext context) {
    ref.watch(spyStateNotifierProvider);
    return _spy;
  }

  Widget get _spy {
    // 計算數值最大寬度
    double valueMaxWidth =
        _notifier.spyValues(_state.daySpy).map((e) => e.value).fold<double>(
              infoW,
              (previousValue, element) {
                double width = textSize(element.toString(), titleST).width;
                if (previousValue < width) return width;
                return previousValue;
              },
            ) +
            16;

    Widget spyWidget(Spy spy) {
      final spyValues = _notifier.spyValues(spy);

      Widget sypDate() => Row(
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
              info(spy.spyDate, width: valueMaxWidth),
            ],
          );
      List<Widget> values = spyValues.map((e) {
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                if (e.key == KeyValue.range || e.key == KeyValue.rangeDiv4) {
                  return;
                }
                String title = '${spy.isDay ? '日' : '夜'}盤，${e.key.title}';
                _notifier.considerKeyValue(
                    title, !(_state.considerKeyValue[title] ?? true));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: e.key == KeyValue.high ||
                            e.key == KeyValue.low ||
                            e.key == KeyValue.range ||
                            e.key == KeyValue.rangeDiv4
                        ? Colors.white
                        : e.key.bg,
                    border: e == spyValues.last
                        ? Border.all(color: Colors.grey.shade300, width: 1)
                        : Border(
                            top: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                            left: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                            right: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                          )),
                child: Stack(
                  children: [
                    if (e.key != KeyValue.range && e.key != KeyValue.rangeDiv4)
                      Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          child: _checkbox(
                              '${spy.isDay ? '日' : '夜'}盤，${e.key.title}')),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        title(e.key.title,
                            color:
                                e.key == KeyValue.high || e.key == KeyValue.low
                                    ? e.key.bg
                                    : null,
                            line: false)
                      ],
                    )
                  ],
                ),
              ),
            ),
            e.key == KeyValue.high || e.key == KeyValue.low
                ? textField(
                    controller: e.key == KeyValue.high
                        ? spy.isDay
                            ? _notifier.daySpyHighController
                            : _notifier.nightSpyHighController
                        : e.key == KeyValue.low
                            ? spy.isDay
                                ? _notifier.daySpyLowController
                                : _notifier.nightSpyLowController
                            : null,
                    width: valueMaxWidth,
                    onChanged: (value) {
                      if (e.key == KeyValue.high) {
                        _notifier.setSpyHigh(spy, value);
                      } else if (e.key == KeyValue.low) {
                        _notifier.setSpyLow(spy, value);
                      }
                    },
                  )
                : info(
                    e.value,
                    width: valueMaxWidth,
                    leftLine: false,
                    rightLine: false,
                    topLine: false,
                  ),
          ],
        );
      }).toList();
      return Column(
        children: [
          Container(
            width: titleW + valueMaxWidth + 16,
            color: Colors.yellow,
            child: title(spy.isDay ? '日盤' : '夜盤', line: false),
          ),
          sypDate(),
          ...values,
        ],
      );
    }

    Widget content = Column(
      children: [
        title('SPY', line: false),
        ColoredBox(
          color: const Color(0xFFFAFAFA),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              spyWidget(_state.daySpy),
              spyWidget(_state.nightSpy),
            ],
          ),
        )
      ],
    );
    content = ColoredBox(color: Colors.lightGreen.shade300, child: content);
    return content;
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


import 'package:dominant_player/model/key_value.dart';
import 'package:dominant_player/model/key_value_list_state.dart';
import 'package:dominant_player/widgets/key_value_list/key_value_list_state_provider.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:dominant_player/widgets/widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeyValueListWidget extends ConsumerStatefulWidget {
  const KeyValueListWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _KeyValueListWidgetState();
}

class _KeyValueListWidgetState extends ConsumerState {
  KeyValueListState get _state =>
      ref.read(keyValueListNotifierProvider);

  KeyValueListMainNotifier get _notifier =>
      ref.read(keyValueListNotifierProvider.notifier);

  @override
  Widget build(BuildContext context) {
    ref.watch(keyValueListNotifierProvider);

    final keyValues = _notifier.keyValues;
    String maxLengthTitle = keyValues.fold('', (previousValue, element) {
      return element.key.length > previousValue.length
          ? element.key
          : previousValue;
    });

    double maxValueWidth = keyValues
        .map(
          (e) => e.value,
    )
        .fold<double>(
      titleW,
          (previousValue, element) {
        double width = textSize(element.toString(), titleST).width;
        if (width > previousValue) return width;
        return previousValue;
      },
    ) +
        16;

    double maxDisWidth = keyValues
        .map(
          (e) => e.value - (_state.current ?? 0),
    )
        .fold<double>(
      infoW,
          (previousValue, element) {
        double width = textSize(element.toString(), infoST).width;
        if (width > previousValue) return width;
        return previousValue;
      },
    ) +
        16;
    int indexOfCurrent = keyValues
        .indexWhere((element) => element.key == KeyValue.current.title);
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title('關鍵價位列表', line: false),
        if (!kIsWeb)
          Row(
            children: [
              Checkbox(
                value: _state.autoNotice,
                onChanged: (enable) {
                  if (enable == null) return;
                  _notifier.setAutoNotice(enable);
                },
              ),
              Text(
                "現價接近關鍵價自動提醒",
                style: infoST,
              ),
              textField(
                controller: _notifier.noticeDisController,
                hint: '價差',
                onChanged: (value) {
                  _notifier.noticeDis = value;
                },
              ),
            ],
          ),
        ColoredBox(
          color: const Color(0xFFFAFAFA),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (keyValues.isEmpty)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '請先輸入關鍵價位（現價、高點、低點、靈敏度空間高低點）',
                    style: titleST,
                  ),
                ),
              ...keyValues.map((e) {
                int index = keyValues.indexWhere(
                      (element) => element.key == e.key,
                );
                num valueDis = indexOfCurrent == -1 || _state.current == null
                    ? 0
                    : e.value - keyValues[indexOfCurrent].value;
                bool currentIsNull = keyValues[indexOfCurrent].value <= 0;
                int indexDis = indexOfCurrent - index;
                Color noticeBg = indexOfCurrent == -1
                    ? Colors.transparent
                    : indexDis == 0
                    ? noteColor.withOpacity(0.5)
                    : indexDis.abs() < 4
                    ? currentIsNull
                    ? Colors.transparent
                    : indexDis > 0
                    ? winColor
                    .withOpacity(0.4 - indexDis.abs() * 0.1)
                    : loseColor
                    .withOpacity(0.4 - indexDis.abs() * 0.1)
                    : Colors.transparent;

                Widget content = Row(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 16),
                          child: title(
                            maxLengthTitle,
                            color: Colors.black.withOpacity(0.01),
                            line: false,
                          ),
                        ),
                        Positioned.fill(
                          child: title(e.key, rightLine: true),
                        )
                      ],
                    ),
                    indexDis == 0
                        ? textField(
                      controller: _notifier.currentController,
                      onChanged: (value) {
                        _notifier.current = value;
                      },
                      width: maxValueWidth,
                    )
                        : title(e.value, width: maxValueWidth, leftLine: false),
                    ...[
                      indexDis == 0
                          ? Container(
                        width: maxDisWidth,
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
                        _state.current == null
                            ? ''
                            : '${valueDis > 0 ? '+' : ''}$valueDis',
                        color: valueDis > 0
                            ? winColor
                            : valueDis < 0
                            ? loseColor
                            : Colors.black,
                        topLine: true,
                        rightLine: true,
                        leftLine: true,
                        bottomLine: e != keyValues.last,
                        width: maxDisWidth,
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
    content = Stack(
      children: [
        // 標題的底色
        Positioned(
            left: 0,
            right: 0,
            child: ColoredBox(
              color: Colors.lightBlueAccent.shade100,
              child: SizedBox(
                height: textH,
                width: double.infinity,
              ),
            )),
        content,
      ],
    );

    return content;
  }
}

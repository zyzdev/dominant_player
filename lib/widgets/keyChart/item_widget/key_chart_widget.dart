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

  @override
  Widget build(BuildContext context) {
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
        )
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        )),
        child: content);
  }
}

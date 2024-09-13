import 'package:dominant_player/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'item_widget/key_candle_widget.dart';
import 'key_candle_main_provider.dart';

class KeyCandleMainWidget extends ConsumerStatefulWidget {
  const KeyCandleMainWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _KeyCandleMainWidgetState();
}

class _KeyCandleMainWidgetState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(keyCandleMainWidgetProvider);
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (state.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '請先輸入關鍵價位（現價、高點、低點、靈敏度空間高低點）',
              style: titleST,
            ),
          ),
        ...[for(int i = 0; i < state.length; i++) KeyCandleWidget(index: i)],
        const SizedBox(height: 16),
        OutlinedButton.icon(
          icon: const Icon(
            Icons.add,
            size: 20,
          ),
          onPressed: () {
            ref.read(keyCandleMainWidgetProvider.notifier).addKeyChart();
          },
          style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.lightBlueAccent)),
          label: const Text('新增自定義關鍵價'),
        ),
        const SizedBox(height: 16),
      ],
    );

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1)
      ),
      child: content,);
  }
}

import 'package:dominant_player/widgets/keyChart/item_widget/key_chart_state.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:dominant_player/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'key_chart_provider.dart';

class KeyChartWidget extends ConsumerStatefulWidget {
  final KeyChartState state;

  const KeyChartWidget({required this.state, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KeyChartWidgetState();
}

class _KeyChartWidgetState extends ConsumerState<KeyChartWidget> {

  KeyChartState get _state => ref.read(keyChartProvider(widget.state));

  KeyChartStateNotifier get _notifier => ref.read(keyChartProvider(widget.state).notifier);

  @override
  Widget build(BuildContext context) {
    ref.watch(keyChartProvider(widget.state));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                confirmDialog(_state.title, context).then((remove) {
                  if (remove == true) {
                    _notifier.removeKeyChart();
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
        textField(
          onChanged: (value) {
            _notifier.setTitle(value);
          },
          init: _state.title,
          width: infoW * 2,
        )
      ],
    );
  }
}

import 'package:dominant_player/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_wall_provider.dart';

class NotificationWallWidget extends ConsumerStatefulWidget {
  const NotificationWallWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationWallWidgetState();
}

class _NotificationWallWidgetState extends ConsumerState {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  Map<NotificationState, bool> _showHint = {};
  @override
  Widget build(BuildContext context) {
    ref.listen<List<NotificationState>>(notificationWallStateProvider,
        (previous, next) {
      int diffLength = next.length - (previous?.length ?? 0);
      for (int i = diffLength - 1; i >= 0; i--) {
        _listKey.currentState?.insertItem(i);
      }
    });
    final state = ref.watch(notificationWallStateProvider);
    for (var element in state) {
      _showHint[element] ??= true;
    }
    Widget content = state.isEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '請先輸入關鍵價位（現價、高點、低點、靈敏度空間高低點）',
              style: titleST,
            ),
          )
        : AnimatedList(
            key: _listKey,
            initialItemCount: state.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index, animation) {
              Widget content = _notificationInfo(
                state[index],
                index == state.length - 1,
              );
              animation = Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                      curve: const Interval(0.5, 1,
                          curve: Curves.fastLinearToSlowEaseIn),
                      parent: animation));
              return FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(animation),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: const Offset(0, 0),
                  ).animate(animation),
                  child: content,
                ),
              );
            },
          );

    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1)),
      child: content,
    );
  }

  Widget _notificationInfo(NotificationState notificationState, bool last) {
    Widget info(String message) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade100),
        padding: const EdgeInsets.all(4),
        child: Text(
          message,
          style: infoST.copyWith(fontSize: 14),
        ),
      );
    }

    Widget content = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: !last ? const EdgeInsets.symmetric(vertical: 8) : EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(notificationState.title, style: titleST),
                const Spacer(),
                Text(notificationState.time, style: captionST),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: notificationState.messages.map((e) => info(e)).toList(),
            )
          ],
        ),
      ),
    );
    bool showHint = _showHint[notificationState] ?? true;
    return StatefulBuilder(builder: (context, setState) {
      if(showHint) {
        Future.delayed(const Duration(seconds: 60), () {
          setState(() {
            _showHint[notificationState] = false;
            showHint = false;
          });
        });
      }
      return Badge(
        label: const Text('New!'),
        isLabelVisible: showHint,
        backgroundColor: Colors.lightBlueAccent,
        child: content,
      );
    });
  }
}

import 'package:dominant_player/service/notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final notificationWallStateProvider = StateNotifierProvider<
    NotificationWallStateNotifier, List<NotificationState>>((ref) {
  return NotificationWallStateNotifier([]);
});

class NotificationWallStateNotifier
    extends StateNotifier<List<NotificationState>> {
  NotificationWallStateNotifier(super.state);

  Future<void> pushNotification(
      String subtitle, List<String> messages) async {
    String message = messages.fold('', (previousValue, element) {
      previousValue += '$element\n';
      return previousValue;
    });
    sendNotification(subtitle, message);
    state = List.from(
        [NotificationState(title: subtitle, messages: messages), ...state]);
  }
}

class NotificationState {
  final String time = DateFormat('HH:mm:ss')
      .format(DateTime.now().toUtc().add(const Duration(hours: 8)));
  final String title;
  final List<String> messages;

  NotificationState({
    required this.title,
    required this.messages,
    String? shortMsg,
  });
}

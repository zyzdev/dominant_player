import 'package:dominant_player/model/index_statistics.dart';
import 'package:dominant_player/service/holiday_info.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final indexStatisticsResponseProvider =
    StateProvider<IndexStatisticsResponse>(
  (ref) => IndexStatisticsResponse.init(),
);

final TaiexClient _restClient = TaiexClient.instance;

int errorRetry = 0;

/// 取得指數統計
/// 每五秒一次
Future<void> fetchIndexStatistics(StateNotifierProviderRef ref) async {
  try {
    final response = await _restClient.getIndexStatistics();
    if (!isHoliday()) {
      Future.delayed(const Duration(seconds: 5), () {
        fetchIndexStatistics(ref);
      });
    }

    // 更新
    ref
        .read(indexStatisticsResponseProvider.notifier)
        .update((state) => response);
  } catch (error, stack) {
    debugPrint(error.toString());
    debugPrint(stack.toString());
    errorRetry++;
    if (errorRetry < 10) fetchIndexStatistics(ref);
  }
}

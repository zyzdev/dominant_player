import 'package:dominant_player/model/transaction_statistics.dart';
import 'package:dominant_player/service/holiday_info.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:dominant_player/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionStatisticsResponseProvider =
    StateProvider<TransactionStatisticsResponse>(
  (ref) => TransactionStatisticsResponse.init(),
);

final TaiexClient _restClient = TaiexClient.instance;

int errorRetry = 0;

/// 取得交易統計
/// 每五秒一次
Future<void> fetchTransactionStatistics(StateNotifierProviderRef ref) async {
  try {
    final response = await _restClient.getTransactionStatistics();
    if (inTrade()) {
      Future.delayed(const Duration(seconds: 5), () {
        fetchTransactionStatistics(ref);
      });
    }
    // 更新
    ref
        .read(transactionStatisticsResponseProvider.notifier)
        .update((state) => response);
  } catch (error, stack) {
    debugPrint(error.toString());
    debugPrint(stack.toString());
    errorRetry++;
    if (errorRetry < 10) fetchTransactionStatistics(ref);
  }
}

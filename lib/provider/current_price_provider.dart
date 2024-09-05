import 'package:dominant_player/provider/current_chart_data_provider.dart';
import 'package:dominant_player/provider/current_month_symbol_id_provider.dart';
import 'package:dominant_player/service/holiday_info.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentPriceProvider = StateProvider<int?>((ref) => null);

final RestClient _restClient = RestClient.instance;

/// 取得現價
Future<void> fetchCurrentPrice(StateNotifierProviderRef ref) async {
  String currentMonthSymbolID = ref.read(currentMonthSymbolIdProvider);
  final response = await _restClient.getCurrentPrice(currentMonthSymbolID);
  int? price = double.tryParse(response.rtData.curClose)?.toInt();
  if (!isHoliday(DateTime.now().toUtc().add(const Duration(hours: 8)))) {
    Future.delayed(const Duration(seconds: 1), () {
      fetchCurrentPrice(ref);
    });
  }
  int? oldPrice = ref.read(currentPriceProvider);
  if (oldPrice != price) {
    ref.read(currentPriceProvider.notifier).update((state) => price);
    // 更新走勢資料
    final newState =
        ref.read(currentChartProvider).updateTick(response.rtData.ticks[1]);
    if (newState != null) {
      ref.read(currentChartProvider.notifier).update((state) {
        return newState;
      });
    }
  }
}

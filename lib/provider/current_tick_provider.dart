import 'package:dominant_player/model/tick.dart';
import 'package:dominant_player/provider/current_chart_data_provider.dart';
import 'package:dominant_player/provider/current_month_symbol_id_provider.dart';
import 'package:dominant_player/provider/is_add_new_tick_provider.dart';
import 'package:dominant_player/service/holiday_info.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_price_provider.dart';

final currentTickProvider = StateProvider<Tick>((ref) => Tick());

final RestClient _restClient = RestClient.instance;

/// 取得現價
Future<void> fetchCurrentTick(StateNotifierProviderRef ref) async {
  String currentMonthSymbolID = ref.read(currentMonthSymbolIdProvider);
  final response = await _restClient.getCurrentPrice(currentMonthSymbolID);
  if (!isHoliday(DateTime.now().toUtc().add(const Duration(hours: 8)))) {
    Future.delayed(const Duration(seconds: 1), () {
      fetchCurrentTick(ref);
    });
  }
  Tick oldTick = ref.read(currentTickProvider);
  Tick newTick = Tick(response.rtData.ticks);

  // 不同才需要更新
  if (oldTick.compareDiff(newTick)) {
    // 更新現價
    int? price = double.tryParse(response.rtData.curClose)?.toInt();
    ref.read(currentPriceProvider.notifier).update((state) => price);

    // 更新走勢資料
    // 先判斷是新增還是取代
    bool? addOrReplace = ref
        .read(currentChartProvider)
        .addOrReplace(ref.read(currentChartProvider).allTicks, response.rtData.ticks[1]);
    final newState = ref.read(currentChartProvider).updateTick(response.rtData.ticks[1]);
    if (newState != null) {
      ref.read(currentChartProvider.notifier).update((state) {
        return newState;
      });
    }
    if (addOrReplace == true) {
      ref.read(isAddNewTickProvider.notifier).update((state) => response.rtData.curTime);
    }

    // 更新現在tick
    ref.read(currentTickProvider.notifier).update((state) => newTick);
  }
}

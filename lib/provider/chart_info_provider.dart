import 'package:dominant_player/model/chart_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_chart_data_provider.dart';
import 'is_add_new_tick_provider.dart';

final chartInfoProvider = StateProviderFamily<ChartInfo, int>((ref, xPeriod) {
  final allTicks = ref.watch(currentChartProvider).allTicks;
  final chartInfo = ChartInfo(xPeriod, allTicks);
  return chartInfo;
});

import 'package:dominant_player/model/chart_info.dart';
import 'package:dominant_player/provider/current_tick_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_chart_data_provider.dart';

final chartInfoProvider = StateProviderFamily<ChartInfo, int>((ref, xPeriod) {
  final curTick = ref.watch(currentTickProvider);
  final chartInfo = ChartInfo(xPeriod);
  chartInfo.updateCurrentTick(curTick);
  return chartInfo;
});

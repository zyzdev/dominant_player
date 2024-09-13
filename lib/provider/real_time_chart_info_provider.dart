import 'package:dominant_player/model/real_time_chart_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_chart_data_provider.dart';

final realTimeChartInfoProvider = StateProviderFamily<RealTimeChartInfo, int>((ref, xPeriod) {
  final allTicks = ref.watch(currentChartProvider).allTicks;
  final realTimeChartInfo = RealTimeChartInfo(xPeriod, allTicks);
  return realTimeChartInfo;
});

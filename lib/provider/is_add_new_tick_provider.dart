import 'package:dominant_player/model/tick.dart';
import 'package:dominant_player/model/ticks.dart';
import 'package:dominant_player/provider/current_chart_data_provider.dart';
import 'package:dominant_player/provider/current_month_symbol_id_provider.dart';
import 'package:dominant_player/service/holiday_info.dart';
import 'package:dominant_player/service/rest_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_price_provider.dart';

/// 提供監聽者一個訊息，目前剛開始新的一分K
final isAddNewTickProvider = StateProvider<String>((ref) => '');

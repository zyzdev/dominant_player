import 'package:dominant_player/model/market_potential_state.dart';
import 'package:dominant_player/widgets/market_potential/market_potential_state_provider.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:dominant_player/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketPotentialWidget extends ConsumerStatefulWidget {
  const MarketPotentialWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MarketPotentialWidgetState();
}

class _MarketPotentialWidgetState extends ConsumerState {
  MarketPotentialState get _state => ref.read(marketPotentialStateProvider);

  MarketPotentialNotifier get _notifier =>
      ref.read(marketPotentialStateProvider.notifier);

  @override
  Widget build(BuildContext context) {
    ref.watch(marketPotentialStateProvider);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title('盤勢判斷', line: false),
        _summary(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _openWidget(),
            _cumulativeTransactionAmountInfo(),
          ],
        ),
      ],
    );

    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
      child: Stack(
        children: [
          // 標題的底色
          Positioned(
              left: 0,
              right: 0,
              child: ColoredBox(
                color: Colors.yellowAccent.shade100,
                child: SizedBox(
                  height: textH,
                  width: double.infinity,
                ),
              )),
          content,
        ],
      ),
    );
  }

  Widget _openWidget() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._notifier.openInfo.map((e) => Text(e)).toList(),
          Text(
            '${_notifier.openInfoMayTrend ? '趨勢' : '盤整'}盤+1',
            style: captionST.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _cumulativeTransactionAmountInfo() {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('開盤第一根5K成交量'),
        ..._notifier.cumulativeTransactionAmountInfo
            .map((e) => Text(e))
            .toList(),
        Text(
          '${_notifier.openInfoMayTrend ? '趨勢' : '盤整'}盤+1',
          style: captionST.copyWith(fontSize: 14),
        ),
      ],
    );
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: content,
    );
  }

  Widget _summary() {
    final up = _state.open > _state.preHigh;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            '今日較可能為',
            style: captionST.copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            _notifier.mayTrend ? '趨勢盤' : '盤整盤',
            style: captionST.copyWith(color: Colors.redAccent),
          ),
          Text(
            '!',
            style: captionST.copyWith(fontWeight: FontWeight.normal),
          ),
          Icon(
            _notifier.mayTrend
                ? up
                ? Icons.trending_up
                : Icons.trending_down
                : Icons.trending_flat,
            color: _notifier.mayTrend
                ? up
                ? winColor
                : loseColor
                : null,
          ),
        ],
      ),
    );
  }
}

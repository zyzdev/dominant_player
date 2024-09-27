import 'dart:io';

import 'package:dominant_player/main_provider.dart';
import 'package:dominant_player/model/main_state.dart';
import 'package:dominant_player/service/notification.dart';
import 'package:dominant_player/widgets/key_candle/key_candle_main_widget.dart';
import 'package:dominant_player/widgets/key_value_list/key_value_list_widget.dart';
import 'package:dominant_player/widgets/market_potential/market_potential_state_provider.dart';
import 'package:dominant_player/widgets/notification_wall/notification_wall_widgat.dart';
import 'package:dominant_player/widgets/sensitivity_space/sensitivity_space_widget.dart';
import 'package:dominant_player/widgets/spy/spy_widget.dart';
import 'package:dominant_player/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'widgets/market_potential/market_potential_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) {
    // Must add this line.
    await windowManager.ensureInitialized();
  }
  if (Platform.isAndroid || Platform.isIOS) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
  await init();
  runApp(
    const ProviderScope(
      child: MaterialApp(
        title: '絕對主力邏輯助手',
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState
    with TickerProviderStateMixin, WindowListener {
  MainState get _state => ref.read(mainProvider);

  MainNotifier get _mainNotifier => ref.read(mainProvider.notifier);

  late final AnimationController _marketPotentialAnimationController =
      AnimationController(
    value: _state.marketPotentialExpand ? 1 : 0,
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final ReverseAnimation _marketPotentialExpandAnimation =
      ReverseAnimation(_marketPotentialCollapseAnimation);
  late final Animation<double> _marketPotentialCollapseAnimation =
      CurvedAnimation(
    parent: _marketPotentialAnimationController,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  late final AnimationController _spyAnimationController = AnimationController(
    value: _state.spyExpand ? 1 : 0,
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final ReverseAnimation _spyExpandAnimation =
      ReverseAnimation(_spyCollapseAnimation);
  late final Animation<double> _spyCollapseAnimation = CurvedAnimation(
    parent: _spyAnimationController,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  late final AnimationController _sensitivitySpaceAnimationController =
      AnimationController(
    value: _state.sensitivitySpaceExpand ? 1 : 0,
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final ReverseAnimation _sensitivitySpaceExpandAnimation =
      ReverseAnimation(_sensitivitySpaceCollapseAnimation);
  late final Animation<double> _sensitivitySpaceCollapseAnimation =
      CurvedAnimation(
    parent: _sensitivitySpaceAnimationController,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  late final AnimationController _keyValuesAnimationController =
      AnimationController(
    value: _state.keyValuesExpand ? 1 : 0,
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final ReverseAnimation _keyValuesExpandAnimation =
      ReverseAnimation(_keyValuesAnimationController);
  late final Animation<double> _keyValuesCollapseAnimation = CurvedAnimation(
    parent: _keyValuesAnimationController,
    curve: Curves.fastLinearToSlowEaseIn,
  );
  late final AnimationController _keyChartNoticeAnimationController =
      AnimationController(
    value: _state.keyChartNoticeExpand ? 1 : 0,
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final ReverseAnimation _keyChartNoticeExpandAnimation =
      ReverseAnimation(_keyChartNoticeAnimationController);
  late final Animation<double> _keyChartNoticeCollapseAnimation =
      CurvedAnimation(
    parent: _keyChartNoticeAnimationController,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  late final AnimationController _notificationWallAnimationController =
      AnimationController(
    value: _state.notificationWallExpand ? 1 : 0,
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final ReverseAnimation _notificationWallExpandAnimation =
      ReverseAnimation(_notificationWallAnimationController);
  late final Animation<double> _notificationWallCollapseAnimation =
      CurvedAnimation(
    parent: _notificationWallAnimationController,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  @override
  void initState() {
    notificationInit();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) {
      windowManager.addListener(this);
      windowManager.waitUntilReadyToShow(
        WindowOptions(
          fullScreen: _state.fullScreen,
          size: _state.screenWidth != null && _state.screenHeight != null
              ? Size(_state.screenWidth!, _state.screenHeight!)
              : null,
        ),
        () {
          windowManager.setTitle('絕對主力邏輯助手');
          if (_state.screenX != null && _state.screenY != null) {
            windowManager.setPosition(
              Offset(_state.screenX!, _state.screenY!),
              animate: true,
            );
          }
        },
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    _marketPotentialAnimationController.dispose();
    _spyAnimationController.dispose();
    _sensitivitySpaceAnimationController.dispose();
    _keyValuesAnimationController.dispose();
    _keyChartNoticeAnimationController.dispose();
    _notificationWallAnimationController.dispose();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(mainProvider);

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, // 垂直滾動
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, //
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _collectedList,
              _marketPotential,
              _spy,
              _sensitivitySpace,
              _keyValueList,
              _keyChartNotice,
              _notificationWall,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _collectedList {
    Widget verticalText(String text) {
      Widget content = Column(
        children: text.runes
            .toList()
            .map((e) => Text(
                  String.fromCharCode(e),
                  style: titleST,
                ))
            .toList(),
      );
      content = Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
            child: content,
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: RotatedBox(
                quarterTurns: 1,
                child: Icon(Icons.expand),
              ),
            ),
          )
        ],
      );
      return SizedBox(
        width: 48,
        child: Center(
          child: content,
        ),
      );
    }

    return Column(
      children: [
        InkWell(
          child: SizeTransition(
            sizeFactor: _marketPotentialExpandAnimation,
            axis: Axis.vertical,
            child: SizeTransition(
              sizeFactor: _marketPotentialExpandAnimation,
              axis: Axis.horizontal,
              child: ColoredBox(
                color: Colors.yellowAccent.shade100,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final state = ref.watch(marketPotentialStateProvider);
                          final notifier =
                              ref.read(marketPotentialStateProvider.notifier);
                          final up = state.open > state.preHigh;
                          return Tooltip(
                            message:
                                '今日較可能為${notifier.mayTrend ? '趨勢' : '盤整'}盤！',
                            child: Icon(
                              notifier.mayTrend
                                  ? up
                                      ? Icons.trending_up
                                      : Icons.trending_down
                                  : Icons.trending_flat,
                              color: notifier.mayTrend
                                  ? up
                                      ? winColor
                                      : loseColor
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    verticalText('盤勢判斷'),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            _mainNotifier.marketPotentialExpand(!_state.marketPotentialExpand);
            _marketPotentialAnimationController.forward();
          },
        ),
        InkWell(
          child: SizeTransition(
            sizeFactor: _spyExpandAnimation,
            axis: Axis.vertical,
            child: SizeTransition(
              sizeFactor: _spyExpandAnimation,
              axis: Axis.horizontal,
              child: ColoredBox(
                color: Colors.lightGreen.shade300,
                child: verticalText('SPY'),
              ),
            ),
          ),
          onTap: () {
            _mainNotifier.spyExpand(!_state.spyExpand);
            _spyAnimationController.forward();
          },
        ),
        InkWell(
          child: SizeTransition(
            sizeFactor: _sensitivitySpaceExpandAnimation,
            axis: Axis.vertical,
            child: SizeTransition(
              sizeFactor: _sensitivitySpaceExpandAnimation,
              axis: Axis.horizontal,
              child: ColoredBox(
                color: Colors.purple.shade300,
                child: verticalText('靈敏度空間'),
              ),
            ),
          ),
          onTap: () {
            _mainNotifier
                .sensitivitySpaceExpand(!_state.sensitivitySpaceExpand);
            _sensitivitySpaceAnimationController.forward();
          },
        ),
        InkWell(
          child: SizeTransition(
            sizeFactor: _keyValuesExpandAnimation,
            axis: Axis.vertical,
            child: SizeTransition(
              sizeFactor: _keyValuesExpandAnimation,
              axis: Axis.horizontal,
              child: ColoredBox(
                color: Colors.lightBlueAccent.shade100,
                child: verticalText('關鍵價位列表'),
              ),
            ),
          ),
          onTap: () {
            _mainNotifier.keyValuesExpand(!_state.keyValuesExpand);
            _keyValuesAnimationController.forward();
          },
        ),
        InkWell(
          child: SizeTransition(
            sizeFactor: _keyChartNoticeExpandAnimation,
            axis: Axis.vertical,
            child: SizeTransition(
              sizeFactor: _keyChartNoticeExpandAnimation,
              axis: Axis.horizontal,
              child: ColoredBox(
                color: Colors.orange.shade300,
                child: verticalText('關鍵K棒'),
              ),
            ),
          ),
          onTap: () {
            _mainNotifier.keyChartNoticeExpand(!_state.keyChartNoticeExpand);
            _keyChartNoticeAnimationController.forward();
          },
        ),
        InkWell(
          child: SizeTransition(
            sizeFactor: _notificationWallExpandAnimation,
            axis: Axis.vertical,
            child: SizeTransition(
              sizeFactor: _notificationWallExpandAnimation,
              axis: Axis.horizontal,
              child: ColoredBox(
                color: Colors.redAccent.shade200,
                child: verticalText('推播提醒牆'),
              ),
            ),
          ),
          onTap: () {
            _mainNotifier
                .notificationWallExpand(!_state.notificationWallExpand);
            _notificationWallAnimationController.forward();
          },
        ),
      ],
    );
  }

  Widget get _marketPotential {
    Widget content = Stack(
      children: [
        const MarketPotentialWidget(),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () {
              _mainNotifier
                  .marketPotentialExpand(!_state.marketPotentialExpand);
              _marketPotentialAnimationController.reverse();
            },
            icon:
                const RotatedBox(quarterTurns: 1, child: Icon(Icons.compress)),
          ),
        )
      ],
    );

    return SizeTransition(
      sizeFactor: _marketPotentialCollapseAnimation,
      axis: Axis.horizontal,
      child: content,
    );
  }

  Widget get _spy {
    Widget content = Stack(
      children: [
        const SpyWidget(),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () {
              _mainNotifier.spyExpand(!_state.spyExpand);
              _spyAnimationController.reverse();
            },
            icon:
                const RotatedBox(quarterTurns: 1, child: Icon(Icons.compress)),
          ),
        )
      ],
    );

    return SizeTransition(
      sizeFactor: _spyCollapseAnimation,
      axis: Axis.horizontal,
      child: content,
    );
  }

  Widget get _sensitivitySpace {
    Widget content = Stack(
      children: [
        const SensitivitySpaceWidget(),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () {
              _mainNotifier
                  .sensitivitySpaceExpand(!_state.sensitivitySpaceExpand);
              _sensitivitySpaceAnimationController.reverse();
            },
            icon:
                const RotatedBox(quarterTurns: 1, child: Icon(Icons.compress)),
          ),
        )
      ],
    );

    return SizeTransition(
      sizeFactor: _sensitivitySpaceCollapseAnimation,
      axis: Axis.horizontal,
      child: content,
    );
  }

  Widget get _keyValueList {
    Widget content = Stack(
      children: [
        const KeyValueListWidget(),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () {
              _mainNotifier.keyValuesExpand(!_state.keyValuesExpand);
              _keyValuesAnimationController.reverse();
            },
            icon:
                const RotatedBox(quarterTurns: 1, child: Icon(Icons.compress)),
          ),
        )
      ],
    );
    return SizeTransition(
      sizeFactor: _keyValuesCollapseAnimation,
      axis: Axis.horizontal,
      child: content,
    );
  }

  Widget get _keyChartNotice {
    if (kIsWeb) return const SizedBox();

    Widget content = Container(
      constraints: BoxConstraints(minWidth: infoW * 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          title('關鍵K棒提醒', line: false),
          const KeyCandleMainWidget(),
        ],
      ),
    );
    content = Stack(
      children: [
        // 標題的底色
        Positioned(
            left: 0,
            right: 0,
            child: ColoredBox(
              color: Colors.orange.shade300,
              child: SizedBox(
                height: textH,
                width: double.infinity,
              ),
            )),
        content,
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () {
              _mainNotifier.keyValuesExpand(!_state.keyChartNoticeExpand);
              _keyChartNoticeAnimationController.reverse();
            },
            icon:
                const RotatedBox(quarterTurns: 1, child: Icon(Icons.compress)),
          ),
        )
      ],
    );
    return SizeTransition(
      sizeFactor: _keyChartNoticeCollapseAnimation,
      axis: Axis.horizontal,
      child: content,
    );
  }

  Widget get _notificationWall {
    if (kIsWeb) return const SizedBox();

    Widget content = Container(
      constraints: BoxConstraints(minWidth: infoW * 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          title('推播牆', line: false),
          const NotificationWallWidget(),
        ],
      ),
    );
    content = Stack(
      children: [
        // 標題的底色
        Positioned(
            left: 0,
            right: 0,
            child: ColoredBox(
              color: Colors.redAccent.shade200,
              child: SizedBox(
                height: textH,
                width: double.infinity,
              ),
            )),
        content,
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () {
              _mainNotifier
                  .notificationWallExpand(!_state.notificationWallExpand);
              _notificationWallAnimationController.reverse();
            },
            icon:
                const RotatedBox(quarterTurns: 1, child: Icon(Icons.compress)),
          ),
        )
      ],
    );
    return SizeTransition(
      sizeFactor: _notificationWallCollapseAnimation,
      axis: Axis.horizontal,
      child: content,
    );
  }

  @override
  void onWindowResized() {
    windowManager.getSize().then(_mainNotifier.setScreenSize);
    super.onWindowResized();
  }

  @override
  void onWindowEnterFullScreen() {
    _mainNotifier.setFullScreen(true);
    super.onWindowEnterFullScreen();
  }

  @override
  void onWindowLeaveFullScreen() {
    _mainNotifier.setFullScreen(false);
    super.onWindowLeaveFullScreen();
  }

  @override
  void onWindowMoved() {
    windowManager.getPosition().then(_mainNotifier.setScreenPosition);
    super.onWindowMoved();
  }
}

import 'dart:io';

import 'package:dominant_player/main_provider.dart';
import 'package:dominant_player/model/main_state.dart';
import 'package:dominant_player/service/notification.dart';
import 'package:dominant_player/widgets/keyCandle/key_candle_main_widget.dart';
import 'package:dominant_player/widgets/notification_wall/notification_wall_widgat.dart';
import 'package:dominant_player/widgets/sensitivity_space/sensitivity_space_widget.dart';
import 'package:dominant_player/widgets/spy/spy_widget.dart';
import 'package:dominant_player/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderables/reorderables.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:window_manager/window_manager.dart';
import 'model/key_value.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) {
    // Must add this line.
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow(
      const WindowOptions(),
      () {
        windowManager.setTitle('絕對主力邏輯助手');
      },
    );
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

class _MyAppState extends ConsumerState with TickerProviderStateMixin {
  MainState get _state => ref.read(mainProvider);

  MainNotifier get _mainNotifier => ref.read(mainProvider.notifier);

  final ValueNotifier<double> _sensitivitySpaceWidth = ValueNotifier(0);

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
    super.initState();
  }

  @override
  void dispose() {
    _spyAnimationController.dispose();
    _sensitivitySpaceAnimationController.dispose();
    _keyValuesAnimationController.dispose();
    _keyChartNoticeAnimationController.dispose();
    _notificationWallAnimationController.dispose();
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
    final keyValues = _mainNotifier.keyValues;
    String maxLengthTitle = keyValues.fold('', (previousValue, element) {
      return element.key.length > previousValue.length
          ? element.key
          : previousValue;
    });

    double maxValueWidth = keyValues
            .map(
          (e) => e.value,
        )
            .fold<double>(
          titleW,
          (previousValue, element) {
            double width = textSize(element.toString(), titleST).width;
            if (width > previousValue) return width;
            return previousValue;
          },
        ) +
        16;

    double maxDisWidth = keyValues
            .map(
          (e) => e.value - (_state.current ?? 0),
        )
            .fold<double>(
          infoW,
          (previousValue, element) {
            double width = textSize(element.toString(), infoST).width;
            if (width > previousValue) return width;
            return previousValue;
          },
        ) +
        16;
    int indexOfCurrent = keyValues
        .indexWhere((element) => element.key == KeyValue.current.title);
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title('關鍵價位列表', line: false),
        if (!kIsWeb)
          Row(
            children: [
              Checkbox(
                value: _state.autoNotice,
                onChanged: (enable) {
                  if (enable == null) return;
                  _mainNotifier.setAutoNotice(enable);
                },
              ),
              Text(
                "現價接近關鍵價自動提醒",
                style: infoST,
              ),
              textField(
                controller: _mainNotifier.noticeDisController,
                hint: '價差',
                onChanged: (value) {
                  _mainNotifier.noticeDis = value;
                },
              ),
            ],
          ),
        ColoredBox(
          color: const Color(0xFFFAFAFA),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (keyValues.isEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '請先輸入關鍵價位（現價、高點、低點、靈敏度空間高低點）',
                    style: titleST,
                  ),
                ),
              ...keyValues.map((e) {
                int index = keyValues.indexWhere(
                  (element) => element.key == e.key,
                );
                num valueDis = indexOfCurrent == -1 || _state.current == null
                    ? 0
                    : e.value - keyValues[indexOfCurrent].value;
                bool currentIsNull = keyValues[indexOfCurrent].value <= 0;
                int indexDis = indexOfCurrent - index;
                Color noticeBg = indexOfCurrent == -1
                    ? Colors.transparent
                    : indexDis == 0
                        ? noteColor.withOpacity(0.5)
                        : indexDis.abs() < 4
                            ? currentIsNull
                                ? Colors.transparent
                                : indexDis > 0
                                    ? winColor
                                        .withOpacity(0.4 - indexDis.abs() * 0.1)
                                    : loseColor
                                        .withOpacity(0.4 - indexDis.abs() * 0.1)
                            : Colors.transparent;

                Widget content = Row(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 16),
                          child: title(
                            maxLengthTitle,
                            color: Colors.black.withOpacity(0.01),
                            line: false,
                          ),
                        ),
                        Positioned.fill(
                          child: title(e.key, rightLine: true),
                        )
                      ],
                    ),
                    indexDis == 0
                        ? textField(
                            controller: _mainNotifier.currentController,
                            onChanged: (value) {
                              _mainNotifier.current = value;
                            },
                            width: maxValueWidth,
                          )
                        : title(e.value, width: maxValueWidth, leftLine: false),
                    ...[
                      indexDis == 0
                          ? Container(
                              width: maxDisWidth,
                              height: textH,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: loseColor,
                                    size: 20,
                                  ),
                                  Text(
                                    '價差',
                                    style: infoST,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_up,
                                    color: winColor,
                                    size: 20,
                                  ),
                                ],
                              ),
                            )
                          : info(
                              _state.current == null
                                  ? ''
                                  : '${valueDis > 0 ? '+' : ''}$valueDis',
                              color: valueDis > 0
                                  ? winColor
                                  : valueDis < 0
                                      ? loseColor
                                      : Colors.black,
                              topLine: true,
                              rightLine: true,
                              leftLine: true,
                              bottomLine: e != keyValues.last,
                              width: maxDisWidth,
                            ),
                    ]
                  ],
                );
                return ColoredBox(
                  color: noticeBg,
                  child: content,
                );
              }).toList()
            ],
          ),
        ),
      ],
    );
    content = Stack(
      children: [
        // 標題的底色
        Positioned(
            left: 0,
            right: 0,
            child: ColoredBox(
              color: Colors.lightBlueAccent.shade100,
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

}

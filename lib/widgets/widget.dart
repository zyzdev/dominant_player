import 'package:flutter/material.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:flutter/rendering.dart';

Widget title(
  dynamic text, {
  bool topLine = true,
  bool bottomLine = true,
  bool leftLine = true,
  bool rightLine = false,
  Color? color,
  Color? bg,
  String? toolTip,
  bool line = true,
  EdgeInsets padding = EdgeInsets.zero,
  double? width,
}) {
  Widget content = Container(
    constraints: BoxConstraints(minWidth: width ?? titleW, minHeight: textH),
    padding: padding,
    decoration: BoxDecoration(
      color: bg,
      border: Border(
        bottom: bottomLine && line
            ? BorderSide(color: Colors.grey.shade300, width: 1)
            : BorderSide.none,
        top: topLine && line
            ? BorderSide(color: Colors.grey.shade300, width: 1)
            : BorderSide.none,
        left: leftLine && line
            ? BorderSide(color: Colors.grey.shade300, width: 1)
            : BorderSide.none,
        right: rightLine && line
            ? BorderSide(color: Colors.grey.shade300, width: 1)
            : BorderSide.none,
      ),
    ),
    alignment: Alignment.center,
    child: Text(
      text?.toString() ?? '',
      style: titleST.copyWith(color: color),
      textAlign: TextAlign.center,
    ),
  );
  if (toolTip != null) {
    Tooltip(
      message: toolTip,
      child: content,
    );
  }
  return content;
}

Widget info(
  dynamic text, {
  bool leftLine = true,
  bool rightLine = false,
  bool topLine = false,
  bool bottomLine = true,
  double? width,
  bool bold = false,
  Color? color,
  bool line = true,
  String? toolTip,
  Alignment alignment = Alignment.center,
      EdgeInsets padding = EdgeInsets.zero,
}) {
  double fontSize = defFontSize;
  TextStyle ts = infoST;
  if (width != null) {
    while (_overFlow(width - 16, text.toString(), ts)) {
      ts = ts.copyWith(fontSize: fontSize--);
    }
  }
  Widget content = Container(
    constraints: BoxConstraints(minWidth: width ?? infoW, minHeight: textH),
    padding: padding,
    decoration: BoxDecoration(
      border: Border(
        bottom: bottomLine && line
            ? BorderSide(color: Colors.grey.shade300, width: 1)
            : BorderSide.none,
        top: topLine && line
            ? BorderSide(color: Colors.grey.shade300, width: 1)
            : BorderSide.none,
        left: leftLine && line
            ? BorderSide(color: Colors.grey.shade300, width: 1)
            : BorderSide.none,
        right: rightLine && line
            ? BorderSide(color: Colors.grey.shade300, width: 1)
            : BorderSide.none,
      ),
    ),
    alignment: alignment,
    child: Text(
      text?.toString() ?? '',
      style: ts.copyWith(
        color: color,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
  if (toolTip != null) {
    content = Tooltip(
      message: toolTip,
      child: content,
    );
  }
  return content;
}

Widget outline(Widget content,
        {EdgeInsets padding = const EdgeInsets.all(16),
        bool left = false,
        bool right = true}) =>
    Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            left: left
                ? BorderSide(color: Colors.grey.shade300, width: 1)
                : BorderSide.none,
            right: right
                ? BorderSide(color: Colors.grey.shade300, width: 1)
                : BorderSide.none),
      ),
      child: content,
    );

bool _overFlow(double width, String text, TextStyle ts) {
  final tp = TextPainter(
      text: TextSpan(text: text, style: ts), textDirection: TextDirection.rtl)
    ..layout();
  return tp.width > width;
}

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant MeasureSizeRenderObject renderObject) {
    renderObject.onChange = onChange;
  }
}

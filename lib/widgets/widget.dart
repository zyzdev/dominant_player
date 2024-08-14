import 'package:flutter/material.dart';
import 'package:dominant_player/widgets/style.dart';

Widget title(
  String text, {
  bool topLine = true,
  bool bottomLine = true,
  bool leftLine = true,
  bool rightLine = false,
  Color? color,
  Color? bg,
  String? toolTip,
  bool line = true,
  EdgeInsets padding = EdgeInsets.zero,
}) {
  Widget content = Container(
    constraints: const BoxConstraints(minWidth: titleW, maxHeight: textH),
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
      text,
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
  double width = infoW,
  bool bold = false,
  Color? color,
  String? toolTip,
}) {
  double fontSize = defFontSize;
  TextStyle ts = infoST;
  while (_overFlow(width - 16, text.toString(), ts)) {
    ts = ts.copyWith(fontSize: fontSize--);
  }
  Widget content = Container(
    constraints: const BoxConstraints(minWidth: infoW, maxHeight: textH),
    decoration: BoxDecoration(
      border: Border(
          top: topLine
              ? BorderSide(color: Colors.grey.shade300, width: 1)
              : BorderSide.none,
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          left: leftLine
              ? BorderSide(color: Colors.grey.shade300, width: 1)
              : BorderSide.none,
          right: rightLine
              ? BorderSide(color: Colors.grey.shade300, width: 1)
              : BorderSide.none),
    ),
    alignment: Alignment.center,
    child: Text(
      text.toString(),
      style: ts.copyWith(
        color: color,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: TextAlign.center,
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

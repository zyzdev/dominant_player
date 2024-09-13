import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dominant_player/widgets/style.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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

Widget textField({
  dynamic init,
  Key? key,
  required ValueChanged<String> onChanged,
  TextEditingController? controller,
  TextInputType? keyboardType = TextInputType.number,
  List<TextInputFormatter> inputFormatters = const [],
  double? width,
  String? hint = '請輸入',
  String? error,
  FormFieldValidator<String>? validator,
}) {
  return Container(
    key: key,
    constraints: BoxConstraints(maxWidth: width ?? infoW, maxHeight: textH),
    alignment: Alignment.bottomCenter,
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      inputFormatters: inputFormatters,
      initialValue: init?.toString(),
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: keyboardType,
      style: infoST,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          errorText: error,
          hintText: hint,
          hintStyle: infoST.copyWith(
              fontSize: max(1, infoST.fontSize! - 4),
              color: Colors.grey.withOpacity(0.75))),
      onChanged: onChanged,
    ),
  );
}


Future<bool?> confirmDialog(String title,BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "再次確認",
          style: titleST,
        ),
        content: Text.rich(
          TextSpan(style: infoST, children: [
            const TextSpan(text: '您確定要刪除"'),
            TextSpan(
                text: title,
                style: infoST.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                )),
            const TextSpan(text: '"嗎？'),
          ]),
          style: infoST,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "取消",
              style: infoST,
            ),
            onPressed: () => Navigator.of(context).pop(), // 关闭对话框
          ),
          TextButton(
            child: Text(
              "刪除",
              style: infoST.copyWith(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

Size textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}
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

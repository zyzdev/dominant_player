import 'package:flutter/material.dart';

const double _titleW = 80;
const double _infoW = 80;
const double _textH = 40;

double get titleW => _titleW * defFontSize / _defFontSize;
double get infoW => _infoW * defFontSize / _defFontSize;
double get textH => _textH * defFontSize / _defFontSize;

const double _defFontSize = 18;
double  defFontSize = _defFontSize;

TextStyle get titleST => TextStyle(fontWeight: FontWeight.bold, fontSize: defFontSize);
TextStyle get infoST => TextStyle(fontWeight: FontWeight.normal, fontSize: defFontSize);

Color winColor = Colors.red;
Color loseColor = Colors.green;
Color infoColor = Colors.grey;
Color noteColor = Colors.orange;


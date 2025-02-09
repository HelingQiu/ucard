import 'package:flutter/material.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  Size textSize(TextStyle style) {
    TextPainter textPainter = TextPainter(
        text: TextSpan(text: this, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  double textHeight(TextStyle style, double textWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: this, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 20,
    )..layout(minWidth: 0, maxWidth: textWidth);

    // final countLines = (textPainter.size.width / textWidth).ceil();
    // final height = countLines * textPainter.size.height;
    return textPainter.size.height;
  }

  String hideContent(int showPreNum, int showSufNum) {
    if (this.length <= showPreNum + showSufNum) {
      return "****";
    } else {
      return this.replaceRange(showPreNum, (this.length - showSufNum), "*");
    }
  }
}

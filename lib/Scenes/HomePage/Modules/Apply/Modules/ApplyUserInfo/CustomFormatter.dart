import 'package:flutter/services.dart';

class CustomFormatter extends TextInputFormatter {
  var _regExp = r"[\u4e00-\u9fa5]";
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (RegExp(_regExp).firstMatch(newValue.text) == null) {
        return newValue;
      }
      return oldValue;
    }
    return newValue;
  }
}

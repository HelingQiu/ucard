
import 'package:flutter/cupertino.dart';

class BaseRouter {
  void push(context, params, title) {}

  void pop(context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void popToRoot(context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
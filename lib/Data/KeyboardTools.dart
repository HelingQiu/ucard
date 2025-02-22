import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class KeyboardTools {
  static hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static Future<bool> isClipboardHasValue() async {
    try {
      // 获取剪切板数据（指定类型为纯文本）
      ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      // 检查数据是否存在且文本非空
      return data != null && data.text != null && data.text!.isNotEmpty;
    } catch (e) {
      // 处理可能的异常（如剪切板访问权限问题）
      print("检查剪切板出错: $e");
      return false;
    }
  }
}

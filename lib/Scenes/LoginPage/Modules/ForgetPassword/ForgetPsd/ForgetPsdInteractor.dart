import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../../../../../Network/Api.dart';

class ForgetPsdInteractor {
  Future<Map<String, dynamic>> resetPassword(
      String account, String code, String newPassword, int type) async {
    var result = await Api().post(
        "/api/resetPwd",
        {"account": account, "code": code, "newPwd": newPassword, "type": type},
        false);
    debugPrint("resetPassword = $result");
    var dic = json.decode(result);
    return dic;
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../../../../../Network/Api.dart';

class ChangePasswordInteractor {
  Future<String> loginVerify(List InfoDic) async {
    var result = await Api().post1("/api/user/secondVerify",
        {"data": InfoDic, "scene": 14}, true); //scene操作场景

    // var result = await Api().post("/api/user/secondVerify", {"account":account, "type":type, "code":verificationCode}, true);
    debugPrint("loginVerify = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {}
        return "Success";
      } else {
        String message = dic["message"];
        if (message != null) {
          debugPrint("message = $message");
          return message;
        }
      }
    }
    return "Error";
  }

  Future<Map<String, dynamic>> changePassword(String account, int accountType,
      String oldPassword, String newPassword) async {
    var result = await Api().post(
        "/api/user/changePwd",
        {
          "account": account,
          "accountType": accountType,
          "scene": 10,
          "oldPwd": oldPassword,
          "newPwd": newPassword,
          "type": 1
        },
        true);
    debugPrint("changePassword = $result");
    var dic = json.decode(result);
    return dic;
  }
}

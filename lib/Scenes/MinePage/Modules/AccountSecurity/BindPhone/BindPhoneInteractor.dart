import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../Network/Api.dart';

class BindPhoneInteractor {
  Future<String> loginVerify(List InfoDic) async {
    var result = await Api().post1("/api/user/secondVerify",
        {"data": InfoDic, "scene": 4}, true); //scene操作场景
    debugPrint("loginVerify = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          return "Success".tr();
        }else{
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
            return message;
          }
        }
      }
    }
    return "Error".tr();
  }
}

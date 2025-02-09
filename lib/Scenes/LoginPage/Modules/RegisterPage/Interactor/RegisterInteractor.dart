import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../Network/Api.dart';

class RegisterInteractor {
  Future<List> sendCode(String account, int scene, int type) async {
    debugPrint("send code {account:$account, scene:$scene, type:$type}");
    var result = await Api().post("/api/sendCode",
        {"account": account, "scene": scene, "type": type}, false);
    debugPrint("sendcode = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          Map data = dic["data"];
          if (data != null) {
            var remainTime = data["remainTime"];
            if (remainTime != null) {
              return [1, "Send success".tr()];
            }
          }
        } else {
          String message = dic["message"];
          return [0, message];
        }
      }
    }
    return [0, ""];
  }
}

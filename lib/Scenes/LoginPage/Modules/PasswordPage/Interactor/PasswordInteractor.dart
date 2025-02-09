import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../Network/Api.dart';

class PasswordInteractor {
  Future<List> register(String account, String password, String code, int type,
      String recommendCode) async {
    Map<String, dynamic> body = {
      "account": account,
      "passWord": password,
      "code": code,
      "type": type,
      "lang": AppStatus.shared.lang
    };
    if (recommendCode != "") {
      body["recommendCode"] = recommendCode;
    }
    var result = await Api().post("/api/register", body, false);
    debugPrint("register result = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          return [1, ""]; //success
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
            return [0, message];
          }
        }
      }
    }

    return [0, ""];
  }
}

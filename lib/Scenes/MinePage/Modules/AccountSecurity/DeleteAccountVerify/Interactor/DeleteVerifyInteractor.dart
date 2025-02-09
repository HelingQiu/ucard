import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../../../Network/Api.dart';

class DeleteVerifyInteractor {
  //用户注销
  Future deleteUser(String code) async {
    var result = await Api().post(
        "/api/user/delUser",
        {
          "code": code,
        },
        true);
    debugPrint("delUser = $result");
    if (result.isEmpty) {
      return [];
    }
    var dic = json.decode(result);
    return dic;
  }
}

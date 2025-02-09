import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../../../../../Network/Api.dart';

class SafetyPinInteractor {
  //设置安全码
  Future<Map<String, dynamic>> setSafetyPinCode(
      String pin, String confirmPin, String code) async {
    var result = await Api().post(
        "/api/user/changePin",
        {
          "pin": pin,
          "confirm_pin": confirmPin,
          "code": code,
        },
        true);
    debugPrint("changePin = $result");
    var dic = json.decode(result);
    return dic;
  }
}

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../Network/Api.dart';

class CardDeleteVerifyInteractor {
  //删除卡片
  Future<String> deleteCard(String card_order, String code) async {
    var dict = {
      'card_order': card_order,
      'code': code,
    };
    var result = await Api().post1("/api/card/close", dict, true);
    debugPrint("/api/card/close = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          return "";
        } else {
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

import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../Network/Api.dart';

class CardSettingInteractor {
  //我的卡片
  Future<List> fetchMycards() async {
    var result = await Api().post1(
        "/api/card/mycards", {"scene": 1, "lang": AppStatus.shared.lang}, true);
    debugPrint("mycards = $result");

    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["data"];
      if (code != null) {
        return code;
      }
    }
    return [];
  }

  //设置卡信息
  Future<String> setCard(
      String card_order, String new_card_name, int hide_name) async {
    var dict = {
      'card_order': card_order,
      'hide_name': hide_name,
    };
    if (new_card_name.isNotEmpty) {
      dict['new_card_name'] = new_card_name;
    }
    var result = await Api().post1("/api/card/setcard", dict, true);
    debugPrint("/api/card/setcard = $result");
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
    return "Error";
  }
}

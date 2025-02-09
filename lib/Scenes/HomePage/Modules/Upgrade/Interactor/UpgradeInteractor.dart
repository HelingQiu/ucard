import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../Network/Api.dart';
import '../Presenter/UpgradePresenter.dart';

class UpgradeInteractor {
  UpgradePresenter? presenter;

  //卡配置
  Future<List> fetchCardConfigsList() async {
    var result = await Api()
        .post1("/api/card/cards", {"lang": AppStatus.shared.lang}, true);
    debugPrint("cards = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["data"];
      if (code != null) {
        return code;
      }
    }
    return [];
  }

  //钱包余额
  Future<Map<String, dynamic>?> getWalletBalance() async {
    var result = await Api().post1("/api/user/mywallet", {}, true);
    debugPrint("fetchInitInfo = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["data"];
      if (code != null) {
        return code;
      }
    }
    return null;
  }

  //卡升级
  Future<String> upgradeCard(String card_order, int new_level) async {
    var result = await Api().post1(
        "/api/card/upgrade",
        {
          'card_order': card_order,
          'new_level': new_level,
        },
        true);
    debugPrint("/api/card/upgrade = $result");
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

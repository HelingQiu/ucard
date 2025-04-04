import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../Network/Api.dart';
import '../../Apply/Entity/CardInfoModel.dart';
import '../Presenter/TopupPresenter.dart';

class TopupInteractor {
  TopupPresenter? presenter;

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

  Future<CardInfoModel?> fetchPhycialData() async {
    var result = await Api().post1(
        "/api/card/physicalCards", {"lang": AppStatus.shared.lang}, true);
    debugPrint("physicalCards = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var data = dic["data"];
      if (data != null) {
        CardInfoModel model = CardInfoModel.parse(data);
        return model;
      }
    }
    return null;
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

  //充值
  Future<String> rechargeCard(String card_order, String money) async {
    var result = await Api().post1(
        "/api/card/recharge",
        {
          'card_order': card_order,
          'money': money,
        },
        true);
    debugPrint("/api/card/recharge = $result");
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

  //33卡充值
  Future<String> recharge33Card(String card_order, String money) async {
    var result = await Api().post1(
        "/api/card/recharge33",
        {
          'card_order': card_order,
          'money': money,
        },
        true);
    debugPrint("/api/card/recharge33 = $result");
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

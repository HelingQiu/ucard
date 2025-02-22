import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Entity/CardInfoModel.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../Network/Api.dart';
import '../Presenter/ApplyPresenter.dart';

class ApplyInteractor {
  ApplyPresenter? presenter;

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

  //申请卡
  Future<List> applyCard(
      String card_bin, int level, String card_type, String card_name) async {
    var result = await Api().post1(
        "/api/card/apply",
        {
          'card_bin': card_bin,
          'level': level,
          'card_type': card_type,
          'card_name': card_name,
        },
        true);
    debugPrint("/api//card/apply = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          return [1, dic['data']];
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
            return [0, message];
          }
        }
      }
    }
    return [0, "Error".tr()];
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

  //申请实体卡
  Future<List> applyPhycialCard(Map<String, dynamic> body) async {
    var result = await Api().post1("/api/card/physicalApply", body, true);
    debugPrint("/api/card/physicalApply = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          return [1, dic['data']];
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
            return [0, message];
          }
        }
      }
    }
    return [0, "Error".tr()];
  }
}

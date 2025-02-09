import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Network/Api.dart';
import '../../Entity/CardRechargeDetailModel.dart';
import '../../Entity/TransferDetailModel.dart';
import 'TopupDetailPresenter.dart';

class TopupDetailInteractor {
  TopupDetailPresenter? presenter;

  //卡充值
  Future<CardRechargeDetailModel?> fetchCardchargeinfo(int id) async {
    var result = await Api().post("/api/user/cardchargeinfo",
        {"id": id, "lang": AppStatus.shared.lang}, true);
    debugPrint("fetchCardchargeinfo = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          Map<String, dynamic> data = dic["data"];
          if (data != null && data.isNotEmpty) {
            var model = CardRechargeDetailModel.parse(data);
            return model;
          }
        }
      }
    }
    return null;
  }

}

import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Network/Api.dart';
import '../../Entity/TransferDetailModel.dart';
import 'WithdrwaDetailPresenter.dart';

class WithdrwaDetailInteractor {
  WithdrwaDetailPresenter? presenter;

  //充值
  Future<TransferDetailModel?> fetchDepositDetail(int id) async {
    var result = await Api().post("/api/user/chargeDetail",
        {"id": id, "lang": AppStatus.shared.lang}, true);
    debugPrint("fetchDepositDetail = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          Map<String, dynamic> data = dic["data"];
          if (data != null && data.isNotEmpty) {
            var model = TransferDetailModel.parse(0, data);
            return model;
          }
        }
      }
    }
    return null;
  }

  //提现
  Future<TransferDetailModel?> fetchWithdrawDetail(int id) async {
    var result = await Api().post("/api/user/withdrawDetail",
        {"id": id, "lang": AppStatus.shared.lang}, true);
    debugPrint("fetchWithdrawDetail = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          Map<String, dynamic> data = dic["data"];
          if (data != null && data.isNotEmpty) {
            var model = TransferDetailModel.parse(1, data);
            return model;
          }
        }
      }
    }
    return null;
  }
}

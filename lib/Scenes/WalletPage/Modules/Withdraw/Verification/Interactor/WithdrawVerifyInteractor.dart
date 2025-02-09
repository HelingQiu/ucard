import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../../../Data/AppStatus.dart';
import '../../../../../../Network/Api.dart';
import '../../Entity/WithdrawResultModel.dart';

class WithdrawVerifyInteractor {
  //提现
  Future<List> withdrawDo(
      String account,
      int accountType,
      String currency,
      String code,
      String blockchain,
      String address,
      double money,
      BuildContext context) async {
    var result = await Api().post(
        "/api/user/withdrawDo",
        {
          "account": account,
          "currency": currency,
          "accountType": accountType,
          "code": code,
          "agreement": blockchain,
          "address": address,
          "money": money,
          "lang": AppStatus.shared.lang
        },
        true,
        needShowTimeout: true,
        context: context);
    debugPrint("withdrawDo result = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          var data = dic["data"];
          if (data != null && data is Map<String, dynamic>) {
            WithdrawResultModel model = WithdrawResultModel.parse(data);
            if (model != null) {
              return [1, "", model]; //success
            }
          }
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

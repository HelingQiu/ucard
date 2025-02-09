import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Network/Api.dart';
import '../../Entity/AddressModel.dart';
import 'DepositPresenter.dart';

class DepositInteractor {
  DepositPresenter? presenter;

  Future<AddressModel?> fetchDepositAddress(
      String currency, String blockchain, int create) async {
    var result = await Api().post(
        "/api/user/chargeInit",
        {
          "currency": currency,
          "agreement": blockchain,
          "create": create,
          "lang": AppStatus.shared.lang
        },
        true);
    debugPrint("fetchDepositAddress = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          Map<String, dynamic> data = dic["data"];
          if (data != null) {
            return AddressModel.parse(currency, data);
          }
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
          }
        }
      }
    }
    return null;
  }
}

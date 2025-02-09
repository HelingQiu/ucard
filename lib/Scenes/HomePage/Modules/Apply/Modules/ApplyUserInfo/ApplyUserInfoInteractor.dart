import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../../../Network/Api.dart';
import 'ApplyUserInfoPresenter.dart';

class ApplyUserInfoInteractor {
  ApplyUserInfoPresenter? presenter;

  //提交持卡人信息
  Future<List> applyCardUser(String first_name, String last_name, String state,
      String city, String address, String zipcode) async {
    var result = await Api().post1(
        "/api/card/applycarduser",
        {
          'first_name': first_name,
          'last_name': last_name,
          'state': state,
          'city': city,
          'address': address,
          'zipcode': zipcode,
        },
        true);
    debugPrint("/api/card/applycarduser = $result");
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
    return [0, "Error"];
  }
}

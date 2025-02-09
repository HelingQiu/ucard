import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Network/Api.dart';
import 'TransactionPresenter.dart';

class TransactionInteractor {
  TransactionPresenter? presenter;

  //资金流水
  Future<Map<String, dynamic>?> fetchTransList(
    int currentPage,
  ) async {
    var result = await Api().post1(
      "/api/user/transList",
      {
        "lang": AppStatus.shared.lang,
        "page": currentPage,
        "pageSize": 10,
      },
      true,
    );
    debugPrint("cardchargeList = $result");

    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["data"];
      if (code != null) {
        return code;
      }
    }
    return null;
  }
}

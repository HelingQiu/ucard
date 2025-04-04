import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../Network/Api.dart';
import '../Presenter/BillPresenter.dart';

class BillInteractor {
  BillPresenter? presenter;

  //账单列表
  Future<Map<String, dynamic>?> fetchSettlements(
    String card_order,
    String settle_date,
    int currentPage,
    int service,
  ) async {
    var result = await Api().post1(
      "/api/card/settlements",
      {
        "lang": AppStatus.shared.lang,
        "card_order": card_order,
        "settle_date": settle_date,
        "page": currentPage,
        "pageSize": 10,
        "service": service,
      },
      true,
    );
    debugPrint("settlements = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["data"];
      if (code != null) {
        return code;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> downSettlements(
    String card_order,
    String settle_date,
    int currentPage,
  ) async {
    var result = await Api().post1(
      "/api/card/settlements",
      {
        "lang": AppStatus.shared.lang,
        "card_order": card_order,
        "settle_date": settle_date,
        "down": 1,
        "page": currentPage,
        "pageSize": 10,
      },
      true,
    );
    debugPrint("settlements = $result");
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

import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../Network/Api.dart';

class ExchangeInteractor {
  Future<Map<String, dynamic>> exchangeMoney(
      String currency_out, String currency_in, String amount) async {
    var result = await Api().post(
        "/api/user/exchange",
        {
          "currency_out": currency_out,
          "currency_in": currency_in,
          "amount": amount,
        },
        true);
    debugPrint("exchangeMoney = $result");
    var dic = json.decode(result);
    return dic;
  }
}

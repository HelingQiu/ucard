import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../../Network/Api.dart';

class SafeChainAddInteractor {
  Future<Map<String, dynamic>> addWhiteList(
      String agreement, String address, String alias, String code) async {
    var result = await Api().post(
        "/api/withdraw/addWhiteList",
        {
          "agreement": agreement,
          "address": address,
          "alias": alias,
          "code": code,
        },
        true);
    debugPrint("addWhiteList = $result");
    var dic = json.decode(result);
    return dic;
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../Network/Api.dart';

class SafeChainListInteractor {
  Future<Map<String, dynamic>?> fetchWhiteList() async {
    var result = await Api().post1(
      "/api/withdraw/getWhiteList",
      {
        "lang": AppStatus.shared.lang,
      },
      true,
    );
    debugPrint("getWhiteList = $result");

    var dic = json.decode(result);
    if (dic != null) {
      var code = dic;
      if (code != null) {
        return code;
      }
    }
    return null;
  }
}

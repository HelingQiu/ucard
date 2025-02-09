import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Network/Api.dart';
import '../Presenter/ReferralsPresenter.dart';

class ReferralsInteractor {
  ReferralsPresenter? presenter;

  //我的推荐人列表
  Future<Map<String, dynamic>?> fetchReferrals() async {
    var result = await Api().post1(
      "/api/user/myreferrals",
      {
        "lang": AppStatus.shared.lang,
        "currentPage": 1,
        "pageSize": 100,
      },
      true,
    );
    debugPrint("/api//user/myreferrals = $result");

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

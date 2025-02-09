import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../Data/AppStatus.dart';
import '../../../Network/Api.dart';
import '../Presenter/RewardPresenter.dart';

class RewardInteractor {
  RewardPresenter? presenter;

  //我的推荐奖励
  Future<Map<String, dynamic>?> getMyawards() async {
    var result = await Api().post1("/api/user/myawards", {}, true);
    debugPrint("/api//user/myawards = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var data = dic["data"];
      if (data != null) {
        return data;
      }
    }
    return null;
  }

  //我的奖励列表
  Future<Map<String, dynamic>?> fetchAwards() async {
    var result = await Api().post1(
      "/api/user/myawardslist",
      {
        "lang": AppStatus.shared.lang,
        "currentPage": 1,
        "pageSize": 100,
      },
      true,
    );
    debugPrint("/api//user/myawardslist = $result");

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

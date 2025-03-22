import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../Data/AppStatus.dart';
import '../../../Network/Api.dart';
import '../Presenter/MinePresenter.dart';

class MineInteractor {
  MinePresenter? presenter;

  Future<Map<String, dynamic>?> uploadSign(
    String sign,
  ) async {
    var result = await Api().post1(
      "/api/user/signSave",
      {
        "lang": AppStatus.shared.lang,
        "content": sign,
      },
      true,
    );
    debugPrint("/user/signSave = $result");
    var dic = json.decode(result);
    return dic;
  }

  Future<Map<String, dynamic>?> getKycToken() async {
    var result = await Api().post1(
      "/api/user/getKycToken",
      {
        "lang": AppStatus.shared.lang,
      },
      true,
    );
    debugPrint("/user/getKycToken = $result");
    var dic = json.decode(result);
    return dic;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import '../../../Data/AppStatus.dart';
import '../../../Network/Api.dart';

class MainInteractor {
  //更新
  Future<Map<String, dynamic>?> fetchAppVersionNeedUpdate() async {
    var response = await Api().post(
        "/api/update",
        {
          "os": Platform.isIOS ? 1 : 2,
          "appid": AppStatus.shared.identifier,
          "version": AppStatus.shared.versionNumber
        },
        false);
    debugPrint("fetchAppVersionNeedUpdate = $response");
    var dic = json.decode(response);
    if (dic != null && dic is Map<String, dynamic>) {
      return dic;
    }
    return null;
  }
}

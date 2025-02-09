import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Entity/AmericanStateModel.dart';

import '../../../../../../../Network/Api.dart';

class AmericanStateInteractor {
  Future<List<AmericanStateModel>> fetchAreaCodes() async {
    var result = await Api().post("/api/card/usastate", {'title': ""}, true);
    debugPrint("/api/card/usastate = $result");
    var dic = json.decode(result);
    List<AmericanStateModel> areaCodes = [];

    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          List data = dic["data"];
          if (data != null && data.isNotEmpty) {
            data.forEach((element) {
              var c = AmericanStateModel.parse(element as Map<String, dynamic>);
              areaCodes.add(c);
            });
          }
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
          }
        }
      }
    }
    return areaCodes;
  }
}

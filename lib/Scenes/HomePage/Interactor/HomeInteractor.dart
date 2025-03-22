import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import '../../../Data/AppStatus.dart';
import '../../../Network/Api.dart';
import '../Presenter/HomePresenter.dart';

class HomeInteractor {
  HomePresenter? presenter;

  //我的卡片
  Future<List> fetchMycards() async {
    var result = await Api()
        .post1("/api/card/mycards", {"lang": AppStatus.shared.lang}, true);
    // print("mycards = $result");
    final logger = Logger();
    logger.d(result);

    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["data"];
      if (code != null) {
        return code;
      }
    }
    return [];
  }

  //激活
  Future<Map<String, dynamic>?> activeCard(
    String card_order,
    String code,
    String safepin,
  ) async {
    var result = await Api().post1(
      "/api/card/activate33",
      {
        "lang": AppStatus.shared.lang,
        "card_order": card_order,
        "code": code,
        "safepin": safepin,
      },
      true,
    );
    debugPrint("/card/activate33 = $result");
    var dic = json.decode(result);
    return dic;
  }

  //冻结
  Future<Map<String, dynamic>?> freezeCard(
    String card_order,
  ) async {
    var result = await Api().post1(
      "/api/card/freeze",
      {
        "lang": AppStatus.shared.lang,
        "card_order": card_order,
      },
      true,
    );
    debugPrint("/card/freeze = $result");
    var dic = json.decode(result);
    return dic;
  }

  //姐冻结
  Future<Map<String, dynamic>?> unfreeze33Card(
    String card_order,
    String code,
    String safepin,
  ) async {
    var result = await Api().post1(
      "/api/card/unfreeze",
      {
        "lang": AppStatus.shared.lang,
        "card_order": card_order,
        "code": code,
        "safepin": safepin,
      },
      true,
    );
    debugPrint("/card/unfreeze = $result");
    var dic = json.decode(result);
    return dic;
  }

  //挂失
  Future<Map<String, dynamic>?> lost33Card(
    String card_order,
    String code,
    String cardpin,
  ) async {
    var result = await Api().post1(
      "/api/card/lost",
      {
        "lang": AppStatus.shared.lang,
        "card_order": card_order,
        "code": code,
        "card_pin": cardpin,
      },
      true,
    );
    debugPrint("/card/lost = $result");
    var dic = json.decode(result);
    return dic;
  }

  //姐挂失
  Future<Map<String, dynamic>?> unlost33Card(
    String card_order,
    String code,
    String cardpin,
  ) async {
    var result = await Api().post1(
      "/api/card/unlost",
      {
        "lang": AppStatus.shared.lang,
        "card_order": card_order,
        "code": code,
        "card_pin": cardpin,
      },
      true,
    );
    debugPrint("/card/unlost = $result");
    var dic = json.decode(result);
    return dic;
  }

  //modify pin
  Future<Map<String, dynamic>?> modpin33Card(String card_order, String code,
      String cardpin, String new_pin, String new_pin_c, String safepin) async {
    var result = await Api().post1(
      "/api/card/modpin",
      {
        "lang": AppStatus.shared.lang,
        "card_order": card_order,
        "code": code,
        "card_pin": cardpin,
        "new_pin": new_pin,
        "new_pin_c": new_pin_c,
        "safepin": safepin,
      },
      true,
    );
    debugPrint("/card/modpin = $result");
    var dic = json.decode(result);
    return dic;
  }

  //卡卡转账
  Future<Map<String, dynamic>?> transfer33Card(String card_order, String code,
      String cardpin, String cardNo, String amount) async {
    var result = await Api().post1(
      "/api/card/transfer",
      {
        "lang": AppStatus.shared.lang,
        "card_order": card_order,
        "code": code,
        "card_pin": cardpin,
        "to_card_no": cardNo,
        "money": amount,
      },
      true,
    );
    debugPrint("/card/transfer = $result");
    var dic = json.decode(result);
    return dic;
  }

  //显示卡号
  Future<Map<String, dynamic>?> cardDetail33(
    String card_order,
    String safepin,
  ) async {
    var result = await Api().post1(
      "/api/card/cardDetail33",
      {
        "lang": AppStatus.shared.lang,
        "card_order": card_order,
        "safepin": safepin,
      },
      true,
    );
    debugPrint("/card/cardDetail33 = $result");
    var dic = json.decode(result);
    return dic;
  }
}

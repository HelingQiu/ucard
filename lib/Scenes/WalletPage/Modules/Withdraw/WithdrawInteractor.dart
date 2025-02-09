import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Network/Api.dart';
import 'Entity/WithdrawInitModel.dart';
import 'Entity/WithdrawResultModel.dart';
import 'WithdrawPresenter.dart';

class WithdrawInteractor {
  WithdrawPresenter? presenter;

  //初始化
  Future<WithdrawInitModel?> fetchWithdrawInit(String currency) async {
    var result = await Api().post("/api/user/withdrawInitV2",
        {"currency": currency, "lang": AppStatus.shared.lang}, true);
    debugPrint("fetchWithdrawInit = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          Map<String, dynamic> data = dic["data"];
          if (data != null) {
            return WithdrawInitModel.parse(data);
          }
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
          }
        }
      }
    }
    return null;
  }

  //最近转出记录
  Future<Map<String, dynamic>?> fetchRecentReferList() async {
    var result = await Api().post1(
      "/api/user/translogs",
      {
        "lang": AppStatus.shared.lang,
      },
      true,
    );
    debugPrint("translogs = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic;
      if (code != null) {
        return code;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchWhiteList(String currency, String agreement) async {
    var result = await Api().post1(
      "/api/withdraw/getWhiteList",
      {
        "lang": AppStatus.shared.lang,
        "currency": currency,
        "agreement": agreement
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

  Future<Map<String, dynamic>?> deleteWhiteList(int listId) async {
    var result = await Api().post1(
      "/api/withdraw/delWhiteList",
      {
        "list_id": listId,
      },
      true,
    );
    debugPrint("delWhiteList = $result");

    var dic = json.decode(result);
    if (dic != null) {
      var code = dic;
      if (code != null) {
        return code;
      }
    }
    return null;
  }

  //账户互转
  Future<Map<String, dynamic>> transToUcardAccount(String inputAmount,
      String account, String code, String safePin, String currency) async {
    var result = await Api().post(
        "/api/user/trans",
        {
          "code": code,
          "safe_pin": safePin,
          "account": account,
          "currency": currency,
          "money": inputAmount
        },
        true);
    debugPrint("trans = $result");
    var dic = json.decode(result);
    return dic;
  }

  //提现
  Future<List> withdrawDo(
      String account,
      int accountType,
      String currency,
      String code,
      String blockchain,
      String address,
      double money,
      String safePin,
      BuildContext context) async {
    var result = await Api().post(
        "/api/user/withdrawDo",
        {
          "account": account,
          "currency": currency,
          "accountType": accountType,
          "code": code,
          "agreement": blockchain,
          "address": address,
          "money": money,
          "lang": AppStatus.shared.lang,
          "safepin":safePin
        },
        true,
        needShowTimeout: true,
        context: context);
    debugPrint("withdrawDo result = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          var data = dic["data"];
          if (data != null && data is Map<String, dynamic>) {
            WithdrawResultModel model = WithdrawResultModel.parse(data);
            if (model != null) {
              return [1, "", model]; //success
            }
          }
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
            return [0, message];
          }
        }
      }
    }
    return [0, ""];
  }
}

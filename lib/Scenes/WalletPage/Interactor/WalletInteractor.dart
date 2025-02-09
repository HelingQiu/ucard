import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../Data/AppStatus.dart';
import '../../../Network/Api.dart';
import '../Entity/CardRechargeModel.dart';
import '../Entity/TransCardrechargeModel.dart';
import '../Entity/TransferModel.dart';
import '../Presenter/WalletPresenter.dart';

class WalletInteractor {
  WalletPresenter? presenter;

  //钱包余额
  Future<Map<String, dynamic>?> getWalletBalance() async {
    var result = await Api().post1("/api/user/mywallet", {}, true);
    debugPrint("fetchInitInfo = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["data"];
      if (code != null) {
        return code;
      }
    }
    return null;
  }

  //充值列表
  Future<List<TransferModel>> fetchDepositList(int page, int size) async {
    var result = await Api().post("/api/user/chargeList",
        {"page": page, "size": size, "lang": AppStatus.shared.lang}, true);
    debugPrint("${DateTime.now()} fetchDepositList = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          List data = dic["data"];
          if (data != null && data.isNotEmpty) {
            List<TransferModel> transfers = [];
            data.forEach((element) {
              TransferModel m =
                  TransferModel.parse(0, element as Map<String, dynamic>);
              if (m.transferId != 0) {
                transfers.add(m);
              }
            });
            return transfers;
          }
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
          }
        }
      }
    }
    return [];
  }

  //提现列表
  Future<List<TransferModel>> fetchWithdrawList(int page, int size) async {
    var result = await Api().post("/api/user/withdrawList",
        {"page": page, "size": size, "lang": AppStatus.shared.lang}, true);
    debugPrint("${DateTime.now()}  fetchWithdrawList = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          List data = dic["data"];
          if (data != null && data.isNotEmpty) {
            List<TransferModel> transfers = [];
            data.forEach((element) {
              TransferModel m =
                  TransferModel.parse(1, element as Map<String, dynamic>);
              if (m.transferId != 0) {
                transfers.add(m);
              }
            });
            return transfers;
          }
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
          }
        }
      }
    }
    return [];
  }

  //卡充值列表
  Future<List> fetchCardchargeList(int page, int size) async {
    var result = await Api().post("/api/user/cardchargeList",
        {"page": page, "size": size, "lang": AppStatus.shared.lang}, true);
    debugPrint("${DateTime.now()}  fetchCardchargeList = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          List data = dic["data"]["list"];
          int totalPage = dic['data']['totalPage'];
          if (data != null && data.isNotEmpty) {
            List<CardRechargeModel> transfers = [];
            data.forEach((element) {
              CardRechargeModel m =
                  CardRechargeModel.parse(element as Map<String, dynamic>);
              if (m.rechargeId != 0) {
                transfers.add(m);
              }
            });
            return [totalPage, transfers];
          }
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
          }
        }
      }
    }
    return [];
  }

  //exchange
  Future<List> fetchExchangeList(int page, int size) async {
    var result = await Api().post1(
      "/api/user/transList",
      {
        "lang": AppStatus.shared.lang,
        "type": 1,
        "page": page,
        "pageSize": 10,
      },
      true,
    );
    debugPrint("exchargeList = $result");

    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          List data = dic["data"]["list"];
          int totalPage = dic['data']['totalPage'];
          if (data != null && data.isNotEmpty) {
            List<TransCardrechargeModel> transfers = [];
            data.forEach((element) {
              TransCardrechargeModel m =
                  TransCardrechargeModel.parse(element as Map<String, dynamic>);
              if (m.rechargeId != 0) {
                transfers.add(m);
              }
            });
            return [totalPage, transfers];
          }
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
          }
        }
      }
    }
    return [];
  }
}

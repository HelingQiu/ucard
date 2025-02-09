import 'package:ucardtemp/Model/WalletModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucardtemp/Network/Api.dart';
import 'dart:async';
import 'dart:convert';
import 'package:ucardtemp/Data/LoginCenter.dart';
import 'package:flutter/foundation.dart';

import '../Model/AreaCodeModel.dart';

class UserInfo {
  static UserInfo shared = new UserInfo._internal();
  String accesstoken = '';
  bool isLoggedin = false;
  bool isUnread = false; //是否有未读消息
  int loginTime = 0;
  String username = "";
  String email = "";
  String phone = "";
  // InvestTotalModel invest = InvestTotalModel(0, 0);
  AreaCodeModel? areaCode = AreaCodeModel('HK', "852", "");
  bool hideBalance = false;
  int isKycVerified = 0;
  bool isNewUser = false;
  int kycVerifiedLevel = 0;
  String kycAccountId = "";
  String kycAccessToken = "";
  String kycAuthorizationToken = "";
  String kycWorkflowExecutionId = "";
  DateTime kycAccessTokenExpireTime = DateTime.now();
  String fcmToken = "";
  int lastLoginMethod = 0;
  String lastEmail = "";
  String lastAreaCode = "";
  String lastPhone = "";
  //用于保存所选法币
  String seletedFiat = "AUD";

  //是否设置pin
  int has_safe_pin = 0;

  //什么模式
  int lightMode = 0;

  UserInfo._internal() {
    begin();
  }

  double getWalletCurrencyAmout(String currency) {
    double amount = 0.0;

    return amount;
  }

  begin() async {
    await getSavedData();
    checkLoginStatus();
  }

  Future<void> getSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    seletedFiat = prefs.getString("FiatType") ?? "AUD";
    loginTime = prefs.getInt("LoginTime") ?? 0;
    accesstoken = prefs.getString("Accesstoken") ?? "";
    hideBalance = prefs.getBool("HideBalance") ?? false;
    email = prefs.getString("Email") ?? "";
    phone = prefs.getString("Phone") ?? "";
    int status = prefs.getInt("LoginStatus") ?? 0;
    if (status == 1 && (accesstoken != "" && (email != "" || phone != ""))) {
      isLoggedin = true;
    } else {
      isLoggedin = false;
    }
    lastLoginMethod = prefs.getInt("LastLoginMethod") ?? 0;
    lastEmail = prefs.getString("LastEmail") ?? "";
    lastAreaCode = prefs.getString("LastAreaCode") ?? "";
    lastPhone = prefs.getString("LastPhone") ?? "";

    lightMode = prefs.getInt("lightMode") ?? 0;

    debugPrint("userinfo getSavedData islogin = ${UserInfo.shared.isLoggedin}");
    return;
  }

  Future<bool> searchNotification() async {
    var result = await Api().post("/api/msg/haveUnreadMsg", {}, true);
    debugPrint(" UnreadMsg= $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          bool isRead = dic["data"]["haveUnreadMsg"];
          isUnread = isRead;
          debugPrint("=====$isRead");
          return isRead;
        }
      }
      return false;
    }
    return false;
  }

  saveLoginData() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("Email", email);
    prefs.setString("Phone", phone);
    prefs.setInt("LoginStatus", isLoggedin ? 1 : 0);
    prefs.setInt("LoginTime", now);
    prefs.setString("Accesstoken", accesstoken);
    prefs.setInt("LastLoginMethod", lastLoginMethod);
    prefs.setString("LastEmail", lastEmail);
    prefs.setString("LastAreaCode", lastAreaCode);
    prefs.setString("LastPhone", lastPhone);
  }

  saveFiatData(String type) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("FiatType", type);
  }

  saveHideBalance() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("HideBalance", hideBalance);
  }

  checkLoginStatus() {
    // open or resume app
    if (isLoggedin == false) {
      return;
    }
    int now = DateTime.now().millisecondsSinceEpoch;
    int duration = ((now - loginTime) / 1000).toInt();
    debugPrint(
        "duration = $duration, now = $now, loginTime = $loginTime,  Accesstoken = $accesstoken");
    if (duration > 86400 * 7) {
      // isLoggedin = false;
      print("need signout");
      LoginCenter().signOut();
    } else {
      LoginCenter().fetchUserInfo();
    }
  }

  uploadAccountId() async {
    debugPrint(
        "kycAccountId = ${kycAccountId},  kycWorkflowExecutionId = ${kycWorkflowExecutionId}");
    if (kycAccountId != "" && kycWorkflowExecutionId != "") {
      var result = await Api().post(
          "/api/user/kycAccountIdSync",
          {
            "accountId": kycAccountId,
            "workflowExecutionId": kycWorkflowExecutionId
          },
          true);
      debugPrint("kycAccountIdSync =$result");
      var dic = json.decode(result);
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          return true;
        }
      }
    }
    return false;
  }
}

import 'package:ucardtemp/Data/UserInfo.dart';
import 'package:ucardtemp/Network//Api.dart';
import 'dart:convert';
import 'package:ucardtemp/Common/StreamCenter.dart';
import 'package:ucardtemp/Data/AppStatus.dart';
import 'package:flutter/foundation.dart';

class LoginCenter {
  /*
   第一次登录后，默认开启faceid再登录。之后再次开启app.如果时间小于1天，直接是已登录状态。如果超过1天，使用faceid登录。
   */
  String account = "";
  int type = 1; //1: email   2: phone
  String password = "";

  Future<String> loginWithInfo(String ac, int ty, String ps,
      {bool needCode = true}) async {
    account = ac;
    type = ty;
    password = ps;
    return await login(needCode);
  }

  Future<String> login(bool needCode) async {
    var result = await Api().post(
        "/api/login",
        {
          "account": account,
          "type": type,
          "passWord": password,
          "lang": AppStatus.shared.lang
        },
        false);
    debugPrint("login = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code != 200) {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
            return message;
          }
        } else {
          //login success
          Map data = dic["data"];
          String username = data["user_name"];
          String email = data["email"];
          String phone = data["phone"];
          String accesstoken = data["accesstoken"];
          if (username != null && username.isNotEmpty) {
            UserInfo.shared.username = username;
          } else {
            UserInfo.shared.username = "";
          }
          if (email != null && email.isNotEmpty) {
            UserInfo.shared.email = email;
          } else {
            UserInfo.shared.email = "";
          }
          if (phone != null && phone.isNotEmpty) {
            UserInfo.shared.phone = phone;
          } else {
            UserInfo.shared.phone = "";
          }
          if (username != null && username.isNotEmpty) {
            if (phone != null && phone.isNotEmpty && phone == username) {
              UserInfo.shared.lastLoginMethod = 1;
              List<String> p = phone.split(" ");
              if (p != null && p.length == 2) {
                UserInfo.shared.lastAreaCode = p[0];
                UserInfo.shared.lastPhone = p[1];
              }
            } else if (email != null && email.isNotEmpty) {
              UserInfo.shared.lastLoginMethod = 0;
              UserInfo.shared.lastEmail = email;
            }
          }
          if (accesstoken != null && accesstoken.isNotEmpty) {
            UserInfo.shared.accesstoken = accesstoken;
            if (needCode == false) {
              UserInfo.shared.isLoggedin = true;
              if (UserInfo.shared.fcmToken != "") {
                LoginCenter().updateFCMToken(UserInfo.shared.fcmToken);
              }
            }
            UserInfo.shared.saveLoginData();
          }
          var is_kyc_verified = data["is_kyc_verified"];
          if (is_kyc_verified != null && is_kyc_verified is int) {
            UserInfo.shared.isKycVerified = is_kyc_verified;
          }
          var kyc_verified_level = data["kyc_verified_level"];
          if (kyc_verified_level != null && kyc_verified_level is int) {
            UserInfo.shared.kycVerifiedLevel = kyc_verified_level;
          }
          var kyc_account_id = data["kyc_account_id"];
          if (kyc_account_id != null && kyc_account_id is String) {
            UserInfo.shared.kycAccountId = kyc_account_id;
          }
          var is_new = data["is_new"];
          if (is_new != null && is_new is int) {
            UserInfo.shared.isNewUser = is_new == 1;
          }
          var has_safe_pin = data["has_safe_pin"];
          print("has safe pin is === ${has_safe_pin}");
          if (has_safe_pin != null && has_safe_pin is int) {
            print("has safe pin is ${has_safe_pin}");
            UserInfo.shared.has_safe_pin = has_safe_pin;
          }
        }
      }
    }
    return "";
  }

  Future<List> sendCode(String account, int scene, int type) async {
    debugPrint("send code {account:$account, scene:$scene, type:$type}");
    var result = await Api().post("/api/sendCode",
        {"account": account, "scene": scene, "type": type}, false);
    debugPrint("sendcode = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          Map data = dic["data"];
          if (data != null) {
            var remainTime = data["remainTime"];
            if (remainTime != null) {
              return [1, "Send success"];
            }
          }
        } else {
          String message = dic["message"];
          return [0, message];
        }
      }
    }
    return [0, ""];
  }

  Future<String> loginVerify(
      String account, int type, String verificationCode) async {
    var result = await Api().post1(
        "/api/user/secondVerify",
        {
          "data": [
            {"account": account, "type": type, "code": verificationCode}
          ],
          "scene": 5
        },
        true); //scene操作场景

    // var result = await Api().post("/api/user/secondVerify", {"account":account, "type":type, "code":verificationCode}, true);
    debugPrint("loginVerify = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          UserInfo.shared.isLoggedin = true;
          UserInfo.shared.saveLoginData();
          if (UserInfo.shared.fcmToken != "") {
            LoginCenter().updateFCMToken(UserInfo.shared.fcmToken);
          }
          return "";
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
            return message;
          }
        }
      }
    }
    return "Error";
  }

  signOut({int tabbarIndex = 0}) async {
    if (UserInfo.shared.isLoggedin == true) {
      print("signout");
      UserInfo.shared.isLoggedin = false;
      UserInfo.shared.accesstoken = "";
      // UserInfo.shared.email = "";
      UserInfo.shared.username = "";
      // UserInfo.shared.phone = "";
      UserInfo.shared.kycAccountId = "";
      UserInfo.shared.kycAccessToken = "";
      UserInfo.shared.kycAuthorizationToken = "";
      UserInfo.shared.isKycVerified = 0;
      UserInfo.shared.kycVerifiedLevel = 0;
      UserInfo.shared.isNewUser = false;
      UserInfo.shared.saveLoginData();
      StreamCenter.shared.refreshAllStreamController
          .add({"type": "index", "content": "$tabbarIndex"});
    }
  }

  Future<void> fetchUserInfo() async {
    var result = await Api().post("/api/user/info", {}, true);
    debugPrint("fetchUserInfo = $result");
    if (result == null || result.isEmpty) {
      return;
    }
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          var data = dic["data"];
          if (data != null && data is Map) {
            String username = data["user_name"];
            String email = data["email"];
            String phone = data["phone"];
            if (username != null && username.isNotEmpty) {
              UserInfo.shared.username = username;
            }
            if (email != null && email.isNotEmpty) {
              UserInfo.shared.email = email;
            }
            if (phone != null && phone.isNotEmpty) {
              UserInfo.shared.phone = phone;
            }
            var is_kyc_verified = data["is_kyc_verified"];
            if (is_kyc_verified != null && is_kyc_verified is int) {
              UserInfo.shared.isKycVerified = is_kyc_verified;
            }
            var kyc_verified_level = data["kyc_verified_level"];
            if (kyc_verified_level != null && kyc_verified_level is int) {
              UserInfo.shared.kycVerifiedLevel = kyc_verified_level;
            }
            var kyc_account_id = data["kyc_account_id"];
            if (kyc_account_id != null && kyc_account_id is String) {
              UserInfo.shared.kycAccountId = kyc_account_id;
            }
            var is_new = data["is_new"];
            if (is_new != null && is_new is int) {
              UserInfo.shared.isNewUser = is_new == 1;
            }
            var allowed_to_buy = data["allowed_to_buy"];
            if (allowed_to_buy != null && allowed_to_buy is bool) {
              AppStatus.shared.purchaseWithoutKyc = allowed_to_buy;
            }
            var allowed_to_withdraw = data["allowed_to_withdraw"];
            if (allowed_to_withdraw != null && allowed_to_withdraw is bool) {
              AppStatus.shared.withdrawWithoutKyc = allowed_to_withdraw;
            }
            var has_safe_pin = data["has_safe_pin"];
            print("has safe pin is === ${has_safe_pin}");
            if (has_safe_pin != null && has_safe_pin is int) {
              print("has safe pin is ${has_safe_pin}");
              UserInfo.shared.has_safe_pin = has_safe_pin;
            }
          }
        } else {
          //{"data":[],"status_code":301,"message":"Invalid signature"}
          signOut();
        }
      }
    }
  }

  updateFCMToken(String token) async {
    var result =
        await Api().post("/api/user/fcmTokenSync", {"token": token}, true);
    debugPrint("updateFCMToken = $result");
  }

  Future<String> verifyPwd(String account, int type, String pwd) async {
    var result = await Api().post1("/api/verifypwd",
        {"account": account, "type": type, "passWord": pwd}, true); //scene操作场景

    // var result = await Api().post("/api/user/secondVerify", {"account":account, "type":type, "code":verificationCode}, true);
    debugPrint("verifypwd = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          return "";
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
            return message;
          }
        }
      }
    }
    return "Error";
  }
}

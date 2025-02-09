import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Data/UserInfo.dart';
import 'package:flutter/foundation.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';
import 'package:ucardtemp/Common/ShowMessage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ucardtemp/Data/AppStatus.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert' as convert;

class Api {
  //测试
  final String apiUrl = 'http://39.101.179.36:8001';
  //预发布
  // final String apiUrl = 'https://dpp8323pd.uollar.io';
  //生产
  // final String apiUrl = "http://cardapp.uollar.io";

  final String apiKey = "dajgoewhagpewagalewgoa";
//法币请求的参数
  final key = 'uollar@test10102022';
  final secret = 'CIL6mMAutiEugsufOCW1vdPBMJGbs3NX';
  final hostname = 'https://uollar.banxa-sandbox.com';

  String sign(String str) {
    var str2 = str + apiKey;
    var content = new Utf8Encoder().convert(str2);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    var str3 = hex.encode(digest.bytes);

    return str3;
  }

  String generateHmac(String playload, String nonce) {
    var payloadData = utf8.encode(playload);
    var sec = utf8.encode(secret);
    var hmac256 = Hmac(sha256, sec);
    var digest = hmac256.convert(payloadData);

    debugPrint('=================hmac is $digest');
    return '$key:$digest:$nonce';
  }

  Future<String> requestPostOrder(Map<String, dynamic> dic) async {
    var nonce = (DateTime.now().millisecondsSinceEpoch).toString();

    var mapStr = json.encode(dic);

    var data = 'POST\n/api/orders\n$nonce\n$mapStr';

    var hmac = generateHmac(data, nonce);
    BaseOptions options = BaseOptions();

    FormData formData = new FormData.fromMap(dic);

    options.headers['Authorization'] = "Bearer $hmac";
    options.contentType = "application/json";
    options.method = 'POST';
    Dio dio = new Dio(options);
    Response response;
    response = await dio
        .post('$hostname/api/orders', data: formData)
        .catchError((err) {
      debugPrint("==============post error  = $err");
    });
    String responseStr = response.toString();
    debugPrint(
        '==================================post response = $responseStr');
    return responseStr;
  }

  Future<String> requestGet(String url) async {
    var nonce = (DateTime.now().millisecondsSinceEpoch).toString();

    // var apiStr = "api/prices?source=USD&target=BTC";

    var data = 'GET\n$url\n$nonce';

    var hmac = generateHmac(data, nonce);
    BaseOptions options = BaseOptions();

    // FormData formData = new FormData.fromMap(dic);

    options.headers['Authorization'] = "Bearer $hmac";
    options.contentType = "application/json";
    options.method = 'GET';
    Dio dio = new Dio(options);
    Response response;
    response = await dio.get("$hostname/$url").catchError((err) {
      debugPrint("==============post error  = $err");
    });
    String responseStr = response.toString();
    return responseStr;
    debugPrint(
        '==================================post response = $responseStr');
  }

  Future<String> get(String url0, String uri, bool needAccesstoken) async {
    var time = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    var uri2 = (uri == "") ? "time=$time" : uri + "&time=$time";
    if (needAccesstoken == true) {
      uri2 = uri2 + '&accesstoken=${UserInfo.shared.accesstoken}';
    }
    var signed = sign(uri2);
    var url = apiUrl + url0 + "?${uri2}&sign=$signed";
    debugPrint('url==$url');
    Response response;
    Dio dio = new Dio();
    response = await dio.get(url);
    String responseStr = response.toString();
    return responseStr;
  }

  Future<String> post(
      String url0, Map<String, dynamic> body, bool needAccesstoken,
      {bool needShowTimeout = false, BuildContext? context = null}) async {
    //needShowTimeout and context are used for timeout alert

    var time = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    body["time"] = time;
    if (!body.keys.contains("lang")) {
      body["lang"] = AppStatus.shared.lang;
    }
    if (needAccesstoken == true) {
      if (UserInfo.shared.accesstoken.isEmpty) {
        return "";
      }
      body['accesstoken'] = UserInfo.shared.accesstoken;
    }
    var uri3 = "";
    var keys = body.keys.toList();
    if (body.keys.length > 1) {
      keys.sort((a, b) => a.toString().compareTo(b.toString()));
    }
    keys.forEach((key) {
      debugPrint("${url0} --  $key = ${body[key]}");
      if (uri3 == "") {
        uri3 = "$key=${body[key]}";
      } else {
        uri3 = uri3 + "&$key=${body[key]}";
      }
    });
    var signed = sign(uri3);
    var url = apiUrl + url0;
    debugPrint("url = $url,   uri = $uri3");
    body["sign"] = signed;
    debugPrint("sign = $signed");
    Response response;
    BaseOptions options = new BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: 600000,
        receiveTimeout: 600000);
    Dio dio = new Dio(options);
    FormData formData = new FormData.fromMap(body);
    response = await dio.post(url, data: formData).catchError((err) {
      debugPrint("post error $url0 = $err");
      debugPrint("body 的json ${body.toString()}");
      debugPrint("报错时的token $body['accesstoken']");
      if (err is DioError) {
        debugPrint(err.error);
        var str = err.error.toString();
        String result = str.replaceAll(new RegExp(r'[^0-9]'), '');

        if (err.type == DioErrorType.connectTimeout ||
            err.type == DioErrorType.receiveTimeout) {
          debugPrint("超时的token $body['accesstoken']");
          if (needShowTimeout == true &&
              context != null &&
              url0 != "/api/fiat/purchase") {
            showDialog(
                context: context,
                builder: (_) {
                  return ShowMessage(2, "Timeout".tr(),
                      styleType: 1, width: 257);
                });
          } else if (needShowTimeout == true &&
              context != null &&
              url0 == "/api/fiat/purchase") {
            showDialog(
                context: context,
                builder: (_) {
                  return ShowMessage(2, "Timeout".tr(),
                      styleType: 1, width: 257);
                });
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
          }
        } else {
          if (int.parse(result) > 400 &&
              context != null &&
              url0 == "/api/fiat/purchase") {
            //只有购买法币时才
            showDialog(
                context: context,
                builder: (_) {
                  return ShowMessage(
                      2, "Service unavailable, please try again later".tr(),
                      styleType: 1, width: 257);
                });
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
          }
        }
      }
    });
    String responseStr = response.toString();
    debugPrint('post response = $responseStr');
    return responseStr;
  }

  Future<String> post1(
      String url0, Map<String, dynamic> body, bool needAccesstoken,
      {bool needShowTimeout = false, BuildContext? context = null}) async {
    //needShowTimeout and context are used for timeout alert

    var time = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    body["time"] = time;
    if (!body.keys.contains("lang")) {
      body["lang"] = AppStatus.shared.lang;
    }

    if (needAccesstoken == true) {
      debugPrint('当前请求接口${url0}, ${UserInfo.shared.accesstoken}');
      if (UserInfo.shared.accesstoken.isEmpty) {
        return "";
      }

      body['accesstoken'] = UserInfo.shared.accesstoken;
    }

    var uri3 = "";
    var keys = body.keys.toList();
    if (body.keys.length > 1) {
      keys.sort((a, b) => a.toString().compareTo(b.toString()));
    }

    keys.forEach((key) {
      debugPrint("${url0} --  $key = ${body[key]}");
      if (uri3 == "") {
        uri3 = "$key=${body[key]}";
      } else if (key == "data") {
        debugPrint("----= = ${body[key]}");
        String str2 = json.encode(body[key]);
        debugPrint("str2 = $str2");
        uri3 = uri3 + "&$key=$str2";
      } else {
        uri3 = uri3 + "&$key=${body[key]}";
      }
    });

    var signed = sign(uri3);
    var url = apiUrl + url0;
    // url = url + "?accesstoken=${UserInfo.shared.accesstoken}&sign=${signed}&time=${time})&lang=${AppStatus.shared.lang}";
    debugPrint("url = $url,   uri = $uri3");
    body["sign"] = signed;
    debugPrint("sign = $signed");

    Response response;
    BaseOptions options = new BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: 600000,
        receiveTimeout: 600000);
    Dio dio = new Dio(options);
    FormData formData = new FormData.fromMap(body);
    debugPrint("body 的json ${json.encode(body)}");
    response = await dio.post(url, data: json.encode(body)).catchError((err) {
      debugPrint("post error $url0 = $err");
      debugPrint("body 的json ${body.toString()}");
      debugPrint("报错时的token $body['accesstoken']");
      if (err is DioError) {
        debugPrint(err.error);
        var str = err.error.toString();
        String result = str.replaceAll(new RegExp(r'[^0-9]'), '');

        if (err.type == DioErrorType.connectTimeout ||
            err.type == DioErrorType.receiveTimeout) {
          debugPrint("超时的token $body['accesstoken']");
          if (needShowTimeout == true &&
              context != null &&
              url0 != "/api/fiat/purchase") {
            showDialog(
                context: context,
                builder: (_) {
                  return ShowMessage(2, "Timeout".tr(),
                      styleType: 1, width: 257);
                });
          } else if (needShowTimeout == true &&
              context != null &&
              url0 == "/api/fiat/purchase") {
            showDialog(
                context: context,
                builder: (_) {
                  return ShowMessage(2, "Timeout".tr(),
                      styleType: 1, width: 257);
                });
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
          }
        } else {
          if (int.parse(result) > 400 &&
              context != null &&
              url0 == "/api/fiat/purchase") {
            //只有购买法币时才
            showDialog(
                context: context,
                builder: (_) {
                  return ShowMessage(
                      2, "Service unavailable, please try again later".tr(),
                      styleType: 1, width: 257);
                });
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
          }
        }
      }
    });
    String responseStr = response.toString();
    var dic = json.decode(responseStr);
    var code = dic["status_code"];
    if (code != null) {
      if (code == 203) {
        //用户登陆信息失效
        if (UserInfo.shared.isLoggedin == true) {
          print("signout");
          LoginCenter().signOut();
        }
      }
    }
    debugPrint('post response = $responseStr');
    return responseStr;
  }
}

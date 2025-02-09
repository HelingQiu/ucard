import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/UserInfo.dart';

class KYCIndexInteractor {
  Future<bool> fetchAccessToken() async {
    Response response;
    Dio dio = new Dio();
    var content = convert.utf8.encode(
        "${AppStatus.shared.kycAccountId}:${AppStatus.shared.kycSecret}");
    String usernamesecret = convert.base64Encode(content);
    // FormData formData = new FormData.fromMap({"grant_type":"client_credentials"});
    var body = {
      "grant_type": "client_credentials"
    }; //convert.jsonEncode({"grant_type":"client_credentials"});
    debugPrint(
        "fetchAccessToken url = https://auth.apac-1.jumio.ai/oauth2/token,  body = ${body}  usernamesecret = $usernamesecret");
    dio.options.headers["Authorization"] = "Basic $usernamesecret";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/x-www-form-urlencoded";
    response = await dio
        .post("https://auth.apac-1.jumio.ai/oauth2/token", data: body)
        .catchError((err) {
      if (err is DioError) {
        print(err.response);
      }
    });

    debugPrint("response = $response");
    String responseStr = response.toString();
    var dic = json.decode(responseStr);
    if (dic != null && dic is Map) {
      String at = dic["access_token"];
      if (at != null && at != "") {
        UserInfo.shared.kycAccessToken = at;
      }
      int expires = dic["expires_in"] ?? 0;
      UserInfo.shared.kycAccessTokenExpireTime =
          DateTime.now().add(Duration(seconds: expires));
      return true;
    }
    return false;
  }

  Future<bool> createAccount() async {
    Response response;
    Dio dio = new Dio();
    var body = {
      "customerInternalReference": UserInfo.shared.username,
      "workflowDefinition": {
        "key": 3,
        "credentials": [
          {
            "category": "ID",
            "type": {
              "values": ["DRIVING_LICENSE", "ID_CARD", "PASSPORT"]
            }
          }
        ]
      },
      "callbackUrl": "https://uollar.netverify.com",
      "userReference": UserInfo.shared.username
    };
    debugPrint("createAccount body = $body");
    dio.options.headers["Authorization"] =
        "Bearer ${UserInfo.shared.kycAccessToken}";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["User-Agent"] =
        "Uollar/v${AppStatus.shared.versionNumber}";

    response = await dio
        .post("https://account.apac-1.jumio.ai/api/v1/accounts", data: body)
        .catchError((err) {
      debugPrint("create account 3");
      if (err is DioError) {
        print(err.response);
      }
    });
    debugPrint("createAccount response = $response");
    String responseStr = response.toString();
    var dic = json.decode(responseStr);
    if (dic != null && dic is Map) {
      Map account = dic["account"];
      if (account != null && account is Map) {
        String id = account["id"];
        if (id != null && id is String && id != "") {
          UserInfo.shared.kycAccountId = id;
        }
      }
      Map sdk = dic["sdk"];
      if (sdk != null && sdk != "") {
        String token = sdk["token"];
        if (token != null && token != "") {
          UserInfo.shared.kycAuthorizationToken = token;
        }
      }
      Map workflowExecution = dic["workflowExecution"];
      if (workflowExecution != null && workflowExecution is Map) {
        String id = workflowExecution["id"];
        UserInfo.shared.kycWorkflowExecutionId = id;
      }
      return true;
    }
    return false;
  }

  Future<bool> updateAccount(String accountId) async {
    Response response;
    Dio dio = new Dio();
    var body = {
      "customerInternalReference": UserInfo.shared.username,
      "workflowDefinition": {
        "key": 3,
        "credentials": [
          {
            "category": "ID",
            "type": {
              "values": ["DRIVING_LICENSE", "ID_CARD", "PASSPORT"]
            }
          }
        ]
      },
      "callbackUrl": "https://uollar.netverify.com",
      "userReference": UserInfo.shared.username
    };
    debugPrint("updateAccount body = $body");
    dio.options.headers["Authorization"] =
        "Bearer ${UserInfo.shared.kycAccessToken}";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["User-Agent"] =
        "Uollar/v${AppStatus.shared.versionNumber}";

    response = await dio
        .put("https://account.apac-1.jumio.ai/api/v1/accounts/$accountId",
            data: body)
        .catchError((err) {
      if (err is DioError) {
        print(err.response);
      }
    });

    debugPrint("updateAccount response = $response");
    String responseStr = response.toString();
    var dic = json.decode(responseStr);
    if (dic != null && dic is Map) {
      Map sdk = dic["sdk"];
      if (sdk != null && sdk != "") {
        String token = sdk["token"];
        if (token != null && token != "") {
          UserInfo.shared.kycAuthorizationToken = token;
        }
      }
      Map workflowExecution = dic["workflowExecution"];
      if (workflowExecution != null && workflowExecution is Map) {
        String id = workflowExecution["id"];
        UserInfo.shared.kycWorkflowExecutionId = id;
      }
      return true;
    }
    return false;
  }
}

import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../Network/Api.dart';
import '../Entity/MessageModel.dart';

class MessageInteractor {
  Future<Map<String, dynamic>?> fetchMessageList(
      int page, int pageSize, String lang) async {
    var result = await Api().post("/api/msg/list",
        {"page": page, "pageSize": pageSize, "lang": lang}, true);
    debugPrint("fetchMessageList = $result");

    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          Map<String, dynamic> data = dic["data"];
          if (data != null) {
            return data;
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

  Future<List> markReadMessage(Map<String, dynamic> parameter) async {
    var result = await Api().post("/api/msg/mark", parameter, true);
    debugPrint(" = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          return [1, "Success".tr()];
        }
      }
      String message = dic["message"] ?? "";
      return [0, message];
    }
    return [0, ""];
  }

  Future<List> clearAllMessages() async {
    var result = await Api()
        .post("/api/msg/clear", {"lang": AppStatus.shared.lang}, true);
    debugPrint(" = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          return [1, "Success".tr()];
        }
      }
      String message = dic["message"] ?? "";
      return [0, message];
    }
    return [0, ""];
  }

  //消息详情
  Future<MessageModel?> fetchMessageInfo(int messageId) async {
    var result = await Api().post("/api/msg/info",
        {"id": messageId, "lang": AppStatus.shared.lang}, true);
    debugPrint("/api/msg/info = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          var data = dic["data"];
          if (data.isNotEmpty) {
            var model = MessageModel.parse(data as Map<String, dynamic>);
            return model;
          }
        } else {
          String message = dic["message"];
          debugPrint("message = $message");
        }
      }
    }
    return null;
  }
}

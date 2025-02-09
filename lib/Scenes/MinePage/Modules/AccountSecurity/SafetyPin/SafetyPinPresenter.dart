import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/LoginCenter.dart';
import '../../../../../Data/UserInfo.dart';
import 'SafetyPinInteractor.dart';
import 'SafetyPinRouter.dart';
import 'SafetyPinView.dart';

class SafetyPinPresenter {
  final SafetyPinInteractor interactor;
  SafetyPinView? view;
  final SafetyPinRouter router;

  SafetyPinPresenter(this.interactor, this.router) {
    startSendCode();
  }

  //进入发验证码
  startSendCode() async {
    bool result = await sendCodePressed(UserInfo.shared.username);
    if (result) {
      view?.isSent = true;
      view?.streamController.add(0);
    }
  }

  Future<bool> sendCodePressed(String address) async {
    List result = await LoginCenter()
        .sendCode(address, 15, (address == UserInfo.shared.email) ? 1 : 2);
    int number = result[0];
    if (number != 0) {
      //success, remaintime
      view?.isSent = true;

      view?.streamController.add(0);
      return true;
    } else {
      // String message = result[1];
      // if (message.isNotEmpty) {
      //   view?.showError(context, message);
      // }
    }
    view?.isSent = false;
    view?.streamController.add(0);
    return false;
  }

  saveSafetyPinCode(
      BuildContext context, String pin, String confirmPin, String code) async {
    var dic = await interactor.setSafetyPinCode(
      pin,
      confirmPin,
      code,
    );
    if (dic != null && dic is Map) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          UserInfo.shared.has_safe_pin = 1;
          showDialog(
              context: context,
              builder: (_) {
                return ShowMessage(2, "Set Safety Pin successfully".tr(),
                    styleType: 1, width: 257);
              });
          Future.delayed(Duration(seconds: 1)).then(
            (value) => {
              router.popToRoot(context),
            },
          );
        } else {
          String message = dic["message"];
          if (message != null) {
            showDialog(
                context: context,
                builder: (_) {
                  return ShowMessage(2, message, styleType: 1, width: 257);
                });
          }
        }
      }
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(2, "Error".tr(), styleType: 1, width: 257);
          });
    }
  }
}

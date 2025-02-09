import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/LoginCenter.dart';
import '../../../../../Data/UserInfo.dart';
import 'UpdatePhoneInteractor.dart';
import 'UpdatePhoneRouter.dart';
import 'UpdatePhoneView.dart';

class UpdatePhonePresenter {
  final UpdatePhoneInteractor interactor;
  UpdatePhoneView? view;
  final UpdatePhoneRouter router;

  UpdatePhonePresenter(this.interactor, this.router) {
    startSendCode();
  }

  //进入发验证码
  startSendCode() async {
    bool result = await sendCodePressed(UserInfo.shared.phone);
    if (result) {
      view?.isSent = true;
      view?.streamController.add(0);
    }
  }

  areaCodeButtonPressed(BuildContext context) {
    router.showAreaCodeScene(context);
  }

  //修改手机号
  ChangePhoneAction(BuildContext context, List info, String phoneStr) async {
    var InfoStr = await interactor.loginVerify(info);

    if (context.mounted) {
      if (InfoStr == "Success".tr()) {
        UserInfo.shared.phone = phoneStr;
        Future.delayed(const Duration(seconds: 1)).then((value) => {
              router.pop(context),
              showDialog(
                  context: context,
                  builder: (_) {
                    return ShowMessage(2, InfoStr, styleType: 1, width: 257);
                  })
            });
      } else {
        showDialog(
            context: context,
            builder: (_) {
              return ShowMessage(2, InfoStr, styleType: 1, width: 257);
            });
      }
    }
  }

  Future<bool> sendCodePressed(String address) async {
    List result = await LoginCenter()
        .sendCode(address, 13, (UserInfo.shared.email == address) ? 1 : 2);
    int number = result[0];
    if (number != 0) {
      //success, remaintime

      return true;
    } else {
      // String message = result[1];
      // if (message.isNotEmpty) {
      //   view?.showError(context, message);
      // }
    }

    return false;
  }

  Future<bool> sendCodePressed1(BuildContext context, String address) async {
    List result = await LoginCenter()
        .sendCode(address, 13, (UserInfo.shared.email == address) ? 1 : 2);
    int number = result[0];
    if (number != 0) {
      //success, remaintime

      return true;
    } else {
      // String message = result[1];
      // if (message.isNotEmpty) {
      //   view?.showError(context, message);
      // }
    }

    return false;
  }
}

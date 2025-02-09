import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/LoginCenter.dart';
import '../../../../../Data/UserInfo.dart';
import 'UpdateEmailInteractor.dart';
import 'UpdateEmailRouter.dart';
import 'UpdateEmailView.dart';

class UpdateEmailPresenter {
  final UpdateEmailInteractor interactor;
  UpdateEmailView? view;
  final UpdateEmailRouter router;

  UpdateEmailPresenter(this.interactor, this.router) {
    startSendCode();
  }

  //进入发验证码
  startSendCode() async {
    bool result = await sendCodePressed(UserInfo.shared.email);
    if (result) {
      view?.isSent = true;
      view?.streamController.add(0);
    }
  }

  //提交
  ChangeEmailAction(BuildContext context, List info, String newEmail) async {
    var InfoStr = await interactor.loginVerify(info);
    if (context.mounted) {
      if (InfoStr == "Success".tr()) {
        UserInfo.shared.email = newEmail;
        Future.delayed(const Duration(seconds: 0)).then((value) => {
              router.pop(context),
              showDialog(
                  context: context,
                  builder: (_) {
                    return ShowMessage(2, InfoStr, styleType: 1, width: 257);
                  }),
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
        .sendCode(address, 14, (UserInfo.shared.phone == address) ? 2 : 1);
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
        .sendCode(address, 14, (UserInfo.shared.phone == address) ? 2 : 1);
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

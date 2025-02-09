import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/LoginCenter.dart';
import '../../../../../Data/UserInfo.dart';
import 'BindEmailInteractor.dart';
import 'BindEmailRouter.dart';
import 'BindEmailView.dart';

class BindEmailPresenter {
  final BindEmailInteractor interactor;
  BindEmailView? view;
  final BindEmailRouter router;
  String loginAccount = "";

  BindEmailPresenter(this.interactor, this.router, this.loginAccount) {
    startSendCode();
  }

  //绑定
  bindPhoneAction(BuildContext context,List info, String email) async {
    var InfoStr = await interactor.loginVerify(info);

    if (context.mounted) {
      if (InfoStr == "Success".tr()) {
        UserInfo.shared.email = email;
        Future.delayed(const Duration(seconds: 0)).then((value) =>
        {
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

  //进入发验证码
  startSendCode() async {
    bool result = await sendCodePressed(UserInfo.shared.phone);
    if (result) {
      view?.isSent = true;
      view?.streamController.add(0);
    }
  }

  Future<bool> sendCodePressed(String address) async {
    List result = await LoginCenter()
        .sendCode(address, 4, (address == UserInfo.shared.phone) ? 2 : 1);
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/LoginCenter.dart';
import '../../../../../Data/UserInfo.dart';
import 'BindPhoneInteractor.dart';
import 'BindPhoneRouter.dart';
import 'BindPhoneView.dart';

class BindPhonePresenter {
  final BindPhoneInteractor interactor;
  BindPhoneView? view;
  final BindPhoneRouter router;
  String loginAccount = "";

  BindPhonePresenter(this.interactor, this.router, this.loginAccount) {
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

  areaCodeButtonPressed(BuildContext context) {
    router.showAreaCodeScene(context);
  }

  backFrontPage(BuildContext context) {
    router.pop(context);
  }

  //绑定
  bindPhoneAction(BuildContext context, List info, String phoneStr) async {
    var InfoStr = await interactor.loginVerify(info);

    if (context.mounted) {
      if (InfoStr == "Success".tr()) {
        UserInfo.shared.phone = phoneStr;
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
        .sendCode(address, 4, (address == UserInfo.shared.email) ? 1 : 2);
    int number = result[0];
    if (number != 0) {
      //success, remaintime
      if (address == UserInfo.shared.email) {
        view?.isSent = true;
      } else {
        view?.isSent1 = true;
      }

      view?.streamController.add(0);
      return true;
    } else {
      // String message = result[1];
      // if (message.isNotEmpty) {
      //   view?.showError(context, message);
      // }
    }
    if (address == UserInfo.shared.email) {
      view?.isSent = false;
    } else {
      view?.isSent1 = false;
    }
    view?.streamController.add(0);
    return false;
  }
}

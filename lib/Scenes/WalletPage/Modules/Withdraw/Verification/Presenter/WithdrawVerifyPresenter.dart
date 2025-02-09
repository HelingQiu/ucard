import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';
import 'package:ucardtemp/Data/UserInfo.dart';

import '../../../../../../Common/ShowMessage.dart';
import '../Interactor/WithdrawVerifyInteractor.dart';

import '../Router/WithdrawVerifyRouter.dart';
import '../View/WithdrawVerifyView.dart';

class WithdrawVerifyPresenter {
  final WithdrawVerifyInteractor interactor;
  WithdrawVerifyView? view;
  final WithdrawVerifyRouter router;

  //网络
  String blockchain = "";
  //地址
  String address = "";
  //金额
  double amount = 0.0;

  WithdrawVerifyPresenter(
    this.interactor,
    this.router,
    this.blockchain,
    this.address,
    this.amount,
  ) {
    startSendCode();
  }

  //进入发验证码
  startSendCode() async {
    bool result = await sendCodePressed();
    if (result) {
      view?.isSent = true;
      view?.streamController.add(0);
    }
  }

  //发送验证码
  Future<bool> sendCodePressed() async {
    List result = await LoginCenter().sendCode(UserInfo.shared.username, 7,
        UserInfo.shared.username == UserInfo.shared.email ? 1 : 2);
    int number = result[0];
    if (number != 0) {
      //success, remaintime
      return true;
    } else {
      // String message = result[1];
      // if (message.isNotEmpty) {
      //   view?.showTopError(context, message);
      // }
    }
    return false;
  }

  //withdraw
  withdrawPressed(BuildContext context, String code) async {
    var result = await interactor.withdrawDo(
        UserInfo.shared.username,
        (UserInfo.shared.username == UserInfo.shared.email) ? 1 : 2,
        "USDT",
        code,
        blockchain,
        address,
        amount,
        context);

    view?.isSubmiting = false;
    view?.streamController.add(0);

    if (context.mounted) {
      if (result[0] == 1) {
        view?.showTopError(context, 'Success'.tr());
        Future.delayed(const Duration(seconds: 2)).then((value) {
          router.popToRoot(context);
        });
      } else {
        var message = result[1] ?? "";
        if (message != null && message is String) {
          view?.showTopError(context, message);
        }
      }
    }
  }
}

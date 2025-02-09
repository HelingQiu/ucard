import 'package:flutter/cupertino.dart';

import '../../../../../Data/LoginCenter.dart';
import 'ForgetVerifyInteractor.dart';
import 'ForgetVerifyRouter.dart';
import 'ForgetVerifyView.dart';

class ForgetVerifyPresenter {
  final ForgetVerifyInteractor interactor;
  ForgetVerifyView? view;
  final ForgetVerifyRouter router;
  int accountType = 0; // 0: email  1:phone
  String forgetAccount = "";

  ForgetVerifyPresenter(
      this.interactor, this.router, this.accountType, this.forgetAccount) {
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

  Future<bool> sendCodePressed() async {
    List result = await LoginCenter()
        .sendCode(forgetAccount, 3, accountType == 0 ? 1 : 2);
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

  forgetRessetPressed(BuildContext context, String code) {
    //下一步
    router.showForgetSetPsdScene(context, accountType, forgetAccount, code);
  }
}

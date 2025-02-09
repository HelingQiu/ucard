import 'package:flutter/cupertino.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';

import '../../../../../Common/StreamCenter.dart';
import '../Interactor/CodeVerifyInteractor.dart';
import '../Router/CodeVerifyRouter.dart';
import '../View/CodeVerifyView.dart';

class CodeVerifyPresenter {
  final CodeVerifyInteractor interactor;
  CodeVerifyView? view;
  final CodeVerifyRouter router;
  int loginMethod = 0; // 0: email  1:phone
  String loginAccount = "";

  CodeVerifyPresenter(
      this.interactor, this.router, this.loginMethod, this.loginAccount) {
    startSendCode();
  }

  //进入发验证码
  startSendCode() async {
    bool result = await sendCodePressed();
    if (result) {
      view?.isSent = true;
      StreamCenter.shared.loginVerifyStreamController.add(0);
    }
  }

  Future<bool> sendCodePressed() async {
    List result =
        await LoginCenter().sendCode(loginAccount, 5, loginMethod == 0 ? 1 : 2);
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

  Future<bool> loginVerifyPressed(BuildContext context, String code) async {
    String errStr = await LoginCenter()
        .loginVerify(loginAccount, (loginMethod == 0 ? 1 : 2), code);
    if (errStr != null && errStr.isNotEmpty) {
      view?.showTopError(context, errStr);
      return false;
    }
    return true;
  }
}

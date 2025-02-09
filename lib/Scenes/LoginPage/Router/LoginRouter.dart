import 'package:flutter/material.dart';
import 'package:ucardtemp/Scenes/LoginPage/Modules/ForgetPassword/ForgetAccount/ForgetAccountBuilder.dart';
import '../../../Common/BaseRouter.dart';
import '../../../Common/StreamCenter.dart';
import '../Modules/AreaCodes/Builder/AreaCodesBuilder.dart';
import '../Modules/CodeVerify/Builder/CodeVerifyBuilder.dart';
import '../Modules/RegisterPage/Builder/RegisterBuilder.dart';

class LoginRouter extends BaseRouter {
  showRegisterScene(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RegisterBuilder().scene, fullscreenDialog: true));
  }

  closeButtonPressed(BuildContext context) {
    pop(context);
  }

  showAreaCodeScene(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => AreaCodesBuilder().scene,
            fullscreenDialog: true))
        .then((value) {
      StreamCenter.shared.loginRefreshStreamController.add(2);
    });
  }

  showForgetScene(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ForgetAccountBuilder().scene,
    ));
  }

  showCodeVerificationView(
      BuildContext context, int loginMethod, String loginAccount) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CodeVerifyBuilder(loginMethod, loginAccount).scene,
    ));
  }
}

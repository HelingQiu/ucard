import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Common/AgreementPage.dart';
import 'package:ucardtemp/Scenes/LoginPage/Modules/PasswordPage/Builder/PasswordBuilder.dart';

import '../../../../../Common/BaseRouter.dart';
import '../../../../../Common/StreamCenter.dart';
import '../../AreaCodes/Builder/AreaCodesBuilder.dart';

class RegisterRouter extends BaseRouter {
  //登录页
  loginButtonPressed(BuildContext context) {
    pop(context);
  }

  //设置密码
  showCreatePsdScene(
    BuildContext context,
    String account,
    String smscode,
    int method,
  ) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PasswordBuilder(account, smscode, method).scene));
  }

  showAreaCodeScene(BuildContext context) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (context) => AreaCodesBuilder().scene,
            fullscreenDialog: true))
        .then((value) {
      StreamCenter.shared.registerRefreshStreamController.add(3);
    });
  }

  showRegisterAgreementScene(BuildContext context, String url) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => AgreementPage("User Agreement".tr(), url)));
  }
}

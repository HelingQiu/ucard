import 'package:flutter/material.dart';
import 'package:ucardtemp/Common/BaseRouter.dart';
import 'package:ucardtemp/Scenes/LoginPage/Modules/ForgetPassword/ForgetVerify/ForgetVerifyBuilder.dart';

import '../../../../../Common/StreamCenter.dart';
import '../../AreaCodes/Builder/AreaCodesBuilder.dart';

class ForgetAccountRouter extends BaseRouter {
  //区域选择
  showAreaCodeScene(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => AreaCodesBuilder().scene,
            fullscreenDialog: true))
        .then((value) {
      StreamCenter.shared.forgetRefreshStreamController.add(0);
    });
  }

  //忘记密码验证码
  showForgetVerifyScene(BuildContext context, int accountType, String account) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              ForgetVerifyBuilder(accountType, account).scene),
    );
  }
}

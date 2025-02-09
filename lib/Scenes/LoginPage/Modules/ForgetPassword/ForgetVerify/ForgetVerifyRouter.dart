import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Scenes/LoginPage/Modules/ForgetPassword/ForgetPsd/ForgetPsdBuilder.dart';

import '../../../../../Common/BaseRouter.dart';

class ForgetVerifyRouter extends BaseRouter {
  //设置新密码
  showForgetSetPsdScene(
      BuildContext context, int accountType, String account, String smsCode) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              ForgetPsdBuilder(accountType, account, smsCode).scene),
    );
  }
}

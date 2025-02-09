import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/AccountSecurity/ChangePassword/ChangePsdVerify/ChangePsdVerifyBuilder.dart';

import '../../../../../../Common/BaseRouter.dart';

class ChangePasswordRouter extends BaseRouter {
  //修改密码发送验证码
  showChangePsdVerifyScene(BuildContext context, String oldPsd, String newPsd) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ChangePsdVerifyBuilder(oldPsd, newPsd).scene),
    );
  }
}

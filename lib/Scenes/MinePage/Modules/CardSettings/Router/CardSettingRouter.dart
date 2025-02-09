import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Common/BaseRouter.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/CardSettings/CardDeleteVerify/Builder/CardDeleteVerifyBuilder.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/CardSettings/View/CardUserInformationView.dart';

class CardSettingRouter extends BaseRouter {
  //跳转验证码
  showCardDeleteVerifyPage(BuildContext context, String cardOrder) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CardDeleteVerifyBuilder(cardOrder).scene));
  }

  //跳转持卡人详情
  showUserInfoPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CardUserInformationView()));
  }
}

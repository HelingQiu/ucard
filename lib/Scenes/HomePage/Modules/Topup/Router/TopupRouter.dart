import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Topup/View/TopupSuccessPage.dart';

import '../../../../../Common/BaseRouter.dart';
import '../../../../WalletPage/Modules/Deposit/DepositBuilder.dart';

class TopupRouter extends BaseRouter {
  //跳转成功页面
  showTopupSuccessPage(BuildContext context, String receivedAmout) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TopupSuccessPage(receivedAmout),
        fullscreenDialog: true));
  }

  //depost
  showDepositPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DepositBuilder('USDT').scene));
  }
}

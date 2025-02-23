import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Scenes/HomePage/Entity/MycardsModel.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/ApplyStartPage.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Bill/Builder/BillBuilder.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Detail/Builder/DetailBuilder.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Notification/Builder/MessageBuilder.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Topup/Builder/TopupBuilder.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Upgrade/Builder/UpgradeBuilder.dart';

import '../../../Common/BaseRouter.dart';
import '../../MinePage/Modules/AccountSecurity/SafetyPin/SafetyPinBuilder.dart';
import '../../MinePage/Modules/CardSettings/Builder/CardSettingsBuilder.dart';
import '../Entity/SettlementModel.dart';

class HomeRouter extends BaseRouter {
  //notification
  showNotificationPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MessageBuilder().scene));
  }

  //apply
  showApplyPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ApplyStartPage()));
  }

  //top-up
  showTopupPage(BuildContext context, MycardsModel model) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TopupBuilder(model).scene));
  }

  //upgrade
  showUpgradePage(BuildContext context, MycardsModel model) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => UpgradeBuilder(model).scene));
  }

  //detail
  showDetailPage(BuildContext context, SettlementModel model) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DetailBuilder(model).scene));
  }

  //跳转卡设置
  showCardSettingPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CardSettingBuilder().scene));
  }

  showBillPage(BuildContext context, MycardsModel model) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BillBuilder(model).scene));
  }

  //跳转设置安全码
  showSafePin(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SafetyPinBuilder().scene));
  }
}

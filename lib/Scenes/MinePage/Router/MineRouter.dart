import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Common/BaseRouter.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/AccountSecurity/AccountSecurityPage.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/Contact/ContactusPage.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/Language/LightModePage.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/ServiceAgreement/ServiceAgreementPage.dart';

import '../Modules/CardSettings/Builder/CardSettingsBuilder.dart';
import '../Modules/HelpCenter/HelpCenter.dart';
import '../Modules/KYCIndex/Builder/KYCIndexBuilder.dart';
import '../Modules/Language/LanguagePage.dart';
import '../Modules/SafeChain/SafeChainList/SafeChainListBuilder.dart';

class MineRouter extends BaseRouter {
  //跳转KYC
  showKYCIndexscene(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => KYCIndexBuilder().scene));
  }

  //跳转卡设置
  showCardSettingPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CardSettingBuilder().scene));
  }

  //跳转安全设置
  showAccountSecrityPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AccountAndSecurityPage()));
  }

  //safeChain
  showSafeChainPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SafeChainListBuilder().scene));
  }

  //跳转语言设置
  showLanguagePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LanguagePage()));
  }

  showLightModePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LightModePage()));
  }

  //跳转联系页面
  showContactusPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ContactusPage()));
  }

  //跳转协议页面
  showAgreementPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ServiceAgreementPage()));
  }

  //跳转帮助中心
  showHelpCenterPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HelpCenterPage()));
  }
}

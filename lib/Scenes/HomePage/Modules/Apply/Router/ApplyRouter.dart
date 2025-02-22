import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Common/BaseRouter.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/ApplyEndPage.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Builder/ApplyBuilder.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Modules/AddressInfo/AddressInfoBuilder.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Modules/AddressInfo/AddressInfoView.dart';

import '../../../../../Common/AgreementPage.dart';
import '../../../../../Common/StreamCenter.dart';
import '../../../../LoginPage/Modules/AreaCodes/Builder/AreaCodesBuilder.dart';

class ApplyRouter extends BaseRouter {
  //apply
  showApplyEndPage(BuildContext context, String cardType, int level,
      String cardName, String level_name, String card_order) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ApplyEndPage(cardType, level, cardName, level_name, card_order),
        fullscreenDialog: true));
  }

  showAgreementScene(BuildContext context, String url) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            AgreementPage("Application Card Agreement".tr(), url)));
  }

  showAddressScene(BuildContext context, int type) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => AddressInfoBuilder(type).scene))
        .then((value) {
      StreamCenter.shared.applyStreamController.add(0);
    });
  }

  showAreaCodeScene(BuildContext context) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (context) => AreaCodesBuilder().scene,
            fullscreenDialog: true))
        .then((value) {
      StreamCenter.shared.applyStreamController.add(0);
    });
  }
}

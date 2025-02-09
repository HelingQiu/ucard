import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../Common/BaseRouter.dart';
import '../../../../../Common/StreamCenter.dart';
import '../../../../LoginPage/Modules/AreaCodes/Builder/AreaCodesBuilder.dart';

class BindPhoneRouter extends BaseRouter {

  showAreaCodeScene(BuildContext context) {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => AreaCodesBuilder().scene, fullscreenDialog: true)).then((value) {
      StreamCenter.shared.loginRefreshStreamController.add(2);
    });
  }

}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Common/BaseRouter.dart';
import '../../../Common/StreamCenter.dart';
import '../../HomePage/Modules/Notification/Builder/MessageBuilder.dart';
import '../../LoginPage/Builder/LoginBuilder.dart';
import '../../MinePage/Modules/AdPage/AdPage.dart';

class MainRouter extends BaseRouter {
  //跳转登录页面
  showLogin(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => LoginBuilder().scene, fullscreenDialog: true))
        .then((value) {
      StreamCenter.shared.refreshAllStreamController.add({});
    });
  }

  //弹出广告页面
  showLaunchAd(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => AdPage(), fullscreenDialog: true))
        .then((value) {
      StreamCenter.shared.refreshAllStreamController
          .add({"type": "index", "content": "0"});
    });
  }

  showNotificationCenter(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MessageBuilder().scene));
  }

  showMessageDetail(BuildContext context, int messageId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MessageDetailBuilder(messageId).scene));
  }
}

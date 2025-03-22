import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../Common/Notification.dart';
import '../../../Common/StreamCenter.dart';
import '../../../Data/AppStatus.dart';
import '../../../Data/UserInfo.dart';
import '../Interactor/MineInteractor.dart';
import '../Router/MineRouter.dart';
import '../View/MineView.dart';

class MinePresenter {
  final MineInteractor interactor;
  final MineRouter router;
  MineView? view;
  bool gotUpdate = false;
  String langStr = '';

  MinePresenter(this.interactor, this.router) {}

  //获取语言
  getLangData(BuildContext context) async {
    await AppStatus.shared;
    int index = AppStatus.shared.languages
        .indexWhere((lang) => lang.replaceAll("-", "_") == "${context.locale}");
    langStr = AppStatus.shared.displayLanguages[index];
    view?.langStream.add(0);
  }

  Future<String> getKycToken() async {
    var result = await interactor.getKycToken();
    var token = result?["data"]["token"] ?? "";
    return token;
  }

  //登录
  loginPressed(BuildContext context) {
    LoginPageNotification().dispatch(context);
  }

  //安全设置
  accountSecrityPressed(BuildContext context) {
    router.showAccountSecrityPage(context);
  }

  //kyc
  kycButtonPressed(BuildContext context) {
    if (UserInfo.shared.isLoggedin == true) {
      if (UserInfo.shared.isKycVerified == 1 && (UserInfo.shared.isSign == 3)) {
        return;
      }
      view?.showKycDialog(context);
    } else {
      LoginPageNotification().dispatch(context);
    }
  }

  //原kyc
  showKycPage(BuildContext context) {
    router.showKYCIndexscene(context);
  }

  //card setting
  cardSettingButtonPressed(BuildContext context) {
    if (UserInfo.shared.isLoggedin == true) {
      router.showCardSettingPage(context);
    } else {
      LoginPageNotification().dispatch(context);
    }
  }

  //safe chain
  safeChainButtonPressed(BuildContext context) {
    if (UserInfo.shared.isLoggedin == true) {
      router.showSafeChainPage(context);
    } else {
      LoginPageNotification().dispatch(context);
    }
  }

  //language
  languageButtonPressed(BuildContext context) {
    router.showLanguagePage(context);
  }

  lightModeButtonPressed(BuildContext context) {
    router.showLightModePage(context);
  }

  //contact us
  contactusButtonPressed(BuildContext context) {
    router.showContactusPage(context);
  }

  //agreement
  agreementButtonPressed(BuildContext context) {
    router.showAgreementPage(context);
  }

  //help center
  helpCenterButtonPressed(BuildContext context) {
    router.showHelpCenterPage(context);
  }

  //上传签名
  Future<Map> uploadSignCall(BuildContext context, String sign) async {
    var result = await interactor.uploadSign(sign);
    var statusCode = result?["status_code"];
    var msg = result?["message"];
    return {"code": statusCode, "msg": msg};
  }
}

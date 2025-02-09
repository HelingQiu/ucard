import 'package:flutter/cupertino.dart';
import 'package:ucardtemp/Common/StringExtension.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../Data/AppStatus.dart';
import '../../../Data/UserInfo.dart';
import '../Interactor/LoginInteractor.dart';
import '../Router/LoginRouter.dart';
import '../View/LoginView.dart';

class LoginPresenter {
  final LoginInteractor interactor;
  LoginView? view;
  final LoginRouter router;
  int loginMethod = 0; // 0: email  1:phone
  bool showPsd = false; //是否显示密码

  String loginAccount = "";

  LoginPresenter(this.interactor, this.router) {
    loginMethod = UserInfo.shared.lastLoginMethod;
    fetchAreaCodes();
  }

  fetchAreaCodes() {
    AppStatus.shared.fetchAreaCodes();
  }

  registerButtonPressed(BuildContext context) {
    router.showRegisterScene(context);
  }

  closeButtonPressed(BuildContext context) {
    router.closeButtonPressed(context);
  }

  areaCodeButtonPressed(BuildContext context) {
    router.showAreaCodeScene(context);
  }

  forgetButtonPressed(BuildContext context) {
    router.showForgetScene(context);
  }

  loginButtonPressed(
      BuildContext context, String account, String password) async {
    String loginErr = "";
    if (password.isEmpty) {
      loginErr = "No password".tr();
    } else {
      if (loginMethod == 0) {
        if (account.isEmpty) {
          loginErr = "No email".tr();
        } else if (account.isValidEmail() == false) {
          loginErr = "Wrong email".tr();
        }
      } else {
        if (UserInfo.shared.areaCode == null) {
          loginErr = "No area code".tr();
        } else if (account.isEmpty) {
          loginErr = "No phone number".tr();
        } else {
          account =
              "${UserInfo.shared.areaCode!.interarea.replaceAll("+", "")} $account";
        }
      }
    }
    if (loginErr != "") {
      showError(loginErr);
      return;
    }

    //去登录
    String errStr = await LoginCenter()
        .loginWithInfo(account, (loginMethod == 0) ? 1 : 2, password);
    if (errStr != null && errStr.isNotEmpty) {
      showError(errStr);
      return;
    }
    loginAccount = account;
    //success
    // Login().sendCode(account, 5, loginMethod == 0 ? 1 : 2);
    //跳转到二次验证界面
    showCodeVerificationView(context);
  }

  showError(String err) {
    view?.loginErrorStreamController.add(err);
  }

  showTopError(BuildContext context, String err) {
    view?.showTopError(context, err);
  }

  showCodeVerificationView(BuildContext context) {
    router.showCodeVerificationView(context, loginMethod, loginAccount);
  }
}

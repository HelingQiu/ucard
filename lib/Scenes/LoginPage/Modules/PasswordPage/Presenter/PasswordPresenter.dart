import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Common/StringExtension.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/LoginCenter.dart';
import '../../../../../Data/UserInfo.dart';
import '../Interactor/PasswordInteractor.dart';
import '../Router/PasswordRouter.dart';
import '../View/PasswordView.dart';

class PasswordPresenter {
  final PasswordInteractor interactor;
  PasswordView? view;
  final PasswordRouter router;
  String account;
  String smscode;
  int method;
  PasswordPresenter(
      this.interactor, this.router, this.account, this.smscode, this.method) {}

  //psw
  String psd = '';
  String rePsd = '';
  String inviteStr = '';
  bool showError = false;

  Future<List> registerButtonPressed(BuildContext context, String password,
      String verifyPassword, String inviteCode) async {
    List result = await interactor.register(
        this.account, password, smscode, method, inviteCode);
    int number = result[0];
    if (number == 0) {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(
              0,
              result[1],
              styleType: 1,
              width: 257,
            );
          });
      return [];
    }
    return [1, "Register success".tr()];
  }

  Future<List> login(
      BuildContext context, String account, String password) async {
    String loginErr = "";
    if (password.isEmpty) {
      loginErr = "No password".tr();
    } else {}
    if (loginErr != "") {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(
              0,
              loginErr,
              styleType: 1,
              width: 257,
            );
          });
      return [];
    }

    String errStr = await LoginCenter()
        .loginWithInfo(account, method, password, needCode: false);
    if (errStr != null && errStr.isNotEmpty) {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(
              0,
              errStr,
              styleType: 1,
              width: 257,
            );
          });
      return [];
    }
    return [1, "Login Success".tr()];
  }
}

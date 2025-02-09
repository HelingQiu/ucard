import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../Data/UserInfo.dart';
import '../../../../../Common/ShowMessage.dart';
import 'ForgetPsdInteractor.dart';
import 'ForgetPsdRouter.dart';
import 'ForgetPsdView.dart';

class ForgetPsdPresenter {
  final ForgetPsdInteractor interactor;
  ForgetPsdView? view;
  final ForgetPsdRouter router;

  int accountType;
  String forgetAccount;
  String smsCode;

  ForgetPsdPresenter(this.interactor, this.router, this.accountType,
      this.forgetAccount, this.smsCode) {}

  submitButtonPressed(BuildContext context, String newPassword) async {
    Map<String, dynamic> dic = await interactor.resetPassword(
        forgetAccount, smsCode, newPassword, accountType == 0 ? 1 : 2);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code != 200) {
          String message = dic["message"];
          showError(context, message);
          return;
        }
        showError(context, "reset success".tr());
        Future.delayed(Duration(seconds: 3)).then((value) {
          router.popToRoot(context);
        });
        return;
      }
    }

    showError(context, "reset fail".tr());
  }

  showError(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) {
          return ShowMessage(1, message, styleType: 1, width: 257);
        });
  }
}

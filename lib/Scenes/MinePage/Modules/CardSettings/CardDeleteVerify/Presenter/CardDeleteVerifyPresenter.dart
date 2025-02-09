import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';
import 'package:ucardtemp/Data/UserInfo.dart';

import '../../../../../../Common/ShowMessage.dart';
import '../Interactor/CardDeleteVerifyInteractor.dart';
import '../Router/CardDeleteVerifyRouter.dart';
import '../View/CardDeleteVerifyView.dart';

class CardDeleteVerifyPresenter {
  final CardDeleteVerifyInteractor interactor;
  CardDeleteVerifyView? view;
  final CardDeleteVerifyRouter router;

  String cardOrder = "";

  CardDeleteVerifyPresenter(
    this.interactor,
    this.router,
    this.cardOrder,
  ) {
    startSendCode();
  }

  //进入发验证码
  startSendCode() async {
    bool result = await sendCodePressed();
    if (result) {
      view?.isSent = true;
      view?.streamController.add(0);
    }
  }

  //发送验证码
  Future<bool> sendCodePressed() async {
    List result = await LoginCenter().sendCode(UserInfo.shared.username, 20,
        UserInfo.shared.username == UserInfo.shared.email ? 1 : 2);
    int number = result[0];
    if (number != 0) {
      //success, remaintime
      return true;
    } else {
      // String message = result[1];
      // if (message.isNotEmpty) {
      //   view?.showTopError(context, message);
      // }
    }
    return false;
  }

  //delete
  deletePressed(BuildContext context, String code) async {
    var result = await interactor.deleteCard(cardOrder, code);

    view?.isSubmiting = false;
    view?.streamController.add(0);

    if (context.mounted) {
      if (result.isEmpty) {
        showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(1, "Delete Success".tr(),
                dismissSeconds: 2, styleType: 1, width: 257);
          },
        );
        Future.delayed(Duration(seconds: 2)).then((value) {
          router.popToRoot(context);
        });
      } else {
        showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(1, result,
                dismissSeconds: 2, styleType: 1, width: 257);
          },
        );
      }
    }
  }
}

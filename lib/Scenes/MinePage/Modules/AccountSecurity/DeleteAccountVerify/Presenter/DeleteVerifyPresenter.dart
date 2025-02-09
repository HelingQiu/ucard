import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';
import 'package:ucardtemp/Data/UserInfo.dart';

import '../../../../../../Common/ShowMessage.dart';
import '../../../../../../Common/StreamCenter.dart';
import '../Interactor/DeleteVerifyInteractor.dart';
import '../Router/DeleteVerifyRouter.dart';
import '../View/DeleteVerifyView.dart';

class DeleteVerifyPresenter {
  final DeleteVerifyInteractor interactor;
  DeleteVerifyView? view;
  final DeleteVerifyRouter router;

  DeleteVerifyPresenter(this.interactor, this.router) {
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

  Future<bool> sendCodePressed() async {
    List result = await LoginCenter().sendCode(UserInfo.shared.username, 8,
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

  //提交注销请求
  submitDesign(BuildContext context, String codeStr) async {
    debugPrint("print $codeStr");
    var result = await interactor.deleteUser(codeStr);
    view?.isSubmiting = false;
    view?.streamController.add(0);

    int code = result['status_code'];
    if (context.mounted) {
      if (code == 200) {
        //success
        logoutAccount(context);
      } else {
        String message = result['message'];
        if (message.isNotEmpty) {
          showError(context, message);
        }
      }
    }
  }

  logoutAccount(BuildContext context) {
    //退出登录时初始化一下消息
    UserInfo.shared.isUnread = false;
    StreamCenter.shared.unReadMsgStreamController.add(0);
    LoginCenter().signOut(tabbarIndex: 3);
    Navigator.of(context).popUntil((route) => route.isFirst);
    StreamCenter.shared.profileStreamController.add(2);
  }

  showError(BuildContext context, String error) {
    showDialog(
        context: context,
        builder: (_) {
          return ShowMessage(2, error, styleType: 1, width: 257);
        });
  }
}

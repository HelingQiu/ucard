import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../Common/ShowMessage.dart';
import '../../../../../../Data/LoginCenter.dart';
import '../../../../../../Data/UserInfo.dart';
import 'ChangePsdVerifyInteractor.dart';
import 'ChangePsdVerifyRouter.dart';
import 'ChangePsdVerifyView.dart';

class ChangePsdVerifyPresenter {
  final ChangePsdVerifyInteractor interactor;
  ChangePsdVerifyView? view;
  final ChangePsdVerifyRouter router;
  String oldPsd = "";
  String newPsd = "";

  ChangePsdVerifyPresenter(
      this.interactor, this.router, this.oldPsd, this.newPsd) {
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
    List result = await LoginCenter().sendCode(UserInfo.shared.username, 10,
        (UserInfo.shared.username == UserInfo.shared.email) ? 1 : 2);
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

  Future<List> changePasswordVerifyAction(List info) async {
    var InfoStr = await interactor.loginVerify(info);
    if (InfoStr == "Success".tr()) {
      return [1, InfoStr];
    } else {
      view?.isSubmiting = false;
      view?.streamController.add(0);
      return [0, InfoStr];
    }
  }

  //提交先验证 验证码是否正确
  submitPressed(BuildContext context, String code) async {
    Map map1 = {"account": UserInfo.shared.email, "type": 1, "code": code};
    Map map2 = {"account": UserInfo.shared.phone, "type": 2, "code": code};
    List list = [];
    if (UserInfo.shared.username == UserInfo.shared.email) {
      list.add(map1);
    }
    if (UserInfo.shared.username == UserInfo.shared.phone) {
      list.add(map2);
    }
    var result = await changePasswordVerifyAction(list);
    if (context.mounted) {
      if (result[0] == 0) {
        showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(2, result[1], styleType: 1, width: 257);
          },
        );
      }
      Future.delayed(Duration(seconds: 1)).then(
        (value) => {
          if (result[0] == 1)
            {
              changePwdMethod(context),
            }
        },
      );
    }
  }

  void changePwdMethod(BuildContext context) async {
    //验证成功后就去调修改密码接口
    var result = await changePassword(context);

    view?.isSubmiting = false;
    view?.streamController.add(0);

    if (context.mounted) {
      if (result[0] == 1) {
        showDialog(
            context: context,
            builder: (_) {
              return ShowMessage(2, result[1], styleType: 1, width: 257);
            });
        Future.delayed(Duration(seconds: 1)).then(
          (value) => {
            router.popToRoot(context),
          },
        );
      } else {
        showDialog(
            context: context,
            builder: (_) {
              return ShowMessage(2, result[1], styleType: 1, width: 257);
            });
      }
    }
  }

  Future<List> changePassword(BuildContext context) async {
    var dic = await interactor.changePassword(
      UserInfo.shared.email,
      (UserInfo.shared.username == UserInfo.shared.email) ? 1 : 2,
      oldPsd,
      newPsd,
    );
    if (dic != null && dic is Map) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          return [1, "Change password successfully".tr()];
        } else {
          String message = dic["message"];
          if (message != null) {
            return [0, message];
          }
        }
      }
    }

    return [0, "Error".tr()];
  }
}

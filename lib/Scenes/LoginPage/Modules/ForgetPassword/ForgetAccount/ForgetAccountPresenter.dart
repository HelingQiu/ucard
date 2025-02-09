import 'package:flutter/cupertino.dart';

import 'ForgetAccountInteractor.dart';
import 'ForgetAccountRouter.dart';
import 'ForgetAccountView.dart';

class ForgetAccountPresenter {
  final ForgetAccountInteractor interactor;
  ForgetAccountView? view;
  final ForgetAccountRouter router;

  int accountType = 0;

  ForgetAccountPresenter(this.interactor, this.router) {}

  //区域选择
  areaCodeButtonPressed(BuildContext context) {
    router.showAreaCodeScene(context);
  }

  nextButtonPressed(BuildContext context, String account) {
    router.showForgetVerifyScene(context, accountType, account);
  }
}

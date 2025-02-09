import 'package:flutter/cupertino.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../Data/UserInfo.dart';
import '../Interactor/ChangePasswordInteractor.dart';
import '../Router/ChangePasswordRouter.dart';
import '../View/ChangePasswordView.dart';

class ChangePasswordPresenter {
  final ChangePasswordInteractor interactor;
  ChangePasswordView? view;
  final ChangePasswordRouter router;

  ChangePasswordPresenter(this.interactor, this.router) {}

  submitButtonPressed(
      BuildContext context, String oldPassword, String newPassword) async {
    router.showChangePsdVerifyScene(context, oldPassword, newPassword);
  }
}

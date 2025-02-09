import 'package:flutter/material.dart';
import '../../../../../Data/UserInfo.dart';
import '../Interactor/KYCIndexInteractor.dart';
import '../Router/KYCIndexRouter.dart';
import '../View/KYCIndexView.dart';

class KYCIndexPresenter {
  final KYCIndexInteractor interactor;
  KYCIndexView? view;
  final KYCIndexRouter router;

  KYCIndexPresenter(this.interactor, this.router) {
    // fetchAccessToken();
  }

  fetchAccessToken(BuildContext context) async {
    var result = await interactor.fetchAccessToken();
    debugPrint("fetchAccessToken result = $result");
    if (result == true) {
      if (UserInfo.shared.kycAccountId != "") {
        updateAccout(context);
      } else {
        createAccount(context);
      }
    }
  }

  createAccount(BuildContext context) async {
    var result = await interactor.createAccount();
    if (result == true) {
      showKycView(context);
    }
  }

  updateAccout(BuildContext context) async {
    var result = await interactor.updateAccount(UserInfo.shared.kycAccountId);
    if (result) {
      showKycView(context);
    }
  }

  showKycView(BuildContext context) {
    view?.showKycView(context);
  }
}

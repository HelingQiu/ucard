import 'package:flutter/cupertino.dart';

import 'AddressInfoInteractor.dart';
import 'AddressInfoRouter.dart';
import 'AddressInfoView.dart';

class AddressInfoPresenter {
  final AddressInfoInteractor interactor;
  AddressInfoView? view;
  final AddressInfoRouter router;

  int type;

  AddressInfoPresenter(this.interactor, this.router, this.type) {}

  cancelPressed(BuildContext context) {
    router.pop(context);
  }

  savePressed(BuildContext context) {
    router.pop(context);
  }
}

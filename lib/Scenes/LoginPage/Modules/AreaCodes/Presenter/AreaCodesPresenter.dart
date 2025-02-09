import 'package:flutter/material.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/UserInfo.dart';
import '../../../../../Model/AreaCodeModel.dart';
import '../Interactor/AreaCodesInteractor.dart';
import '../Router/AreaCodesRouter.dart';
import '../View/AreaCodesView.dart';

class AreaCodesPresenter {
  final AreaCodesInteractor interactor;
  AreaCodesView? view;
  final AreaCodesRouter router;

  AreaCodesPresenter(this.interactor, this.router) {
    // interactor.sendCode();
  }

  fetchAreaCodes() async {
    var codes = await AppStatus.shared.fetchAreaCodes();
    view?.updateContent(codes);
  }

  areaPressed(BuildContext context, AreaCodeModel model) {
    UserInfo.shared.areaCode = model;
    router.pop(context);
  }

  search(String text) {
    List<AreaCodeModel> codes = [];
    if (text != "") {
      AppStatus.shared.areaCodes.forEach((element) {
        if (element.countryName.contains(text) ||
            element.interarea.contains(text) ||
            element.code.contains(text.toUpperCase())) {
          codes.add(element);
        }
      });
    } else {
      codes = AppStatus.shared.areaCodes;
    }
    view?.updateContent(codes);
  }
}

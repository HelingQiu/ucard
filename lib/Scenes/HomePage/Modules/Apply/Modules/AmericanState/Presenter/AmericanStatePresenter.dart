import 'package:flutter/material.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Entity/AmericanStateModel.dart';

import '../../../../../../../Data/AppStatus.dart';
import '../Interactor/AmericanStateInteractor.dart';
import '../Router/AmericanStateRouter.dart';
import '../View/AmericanStateView.dart';

class AmericanStatePresenter {
  final AmericanStateInteractor interactor;
  AmericanStateView? view;
  final AmericanStateRouter router;

  //总数据
  List<AmericanStateModel> totalList = [];

  AmericanStatePresenter(this.interactor, this.router) {
    // interactor.sendCode();
  }

  fetchAreaCodes() async {
    var codes = await interactor.fetchAreaCodes();
    totalList = codes;
    view?.updateContent(codes);
  }

  areaPressed(BuildContext context, AmericanStateModel model) {
    AppStatus.shared.stateModel = model;
    router.pop(context);
  }

  search(String text) {
    List<AmericanStateModel> codes = [];
    if (text != "") {
      totalList.forEach((element) {
        if (element.title.contains(text) || element.jx.contains(text)) {
          codes.add(element);
        }
      });
    } else {
      codes = totalList;
    }
    view?.updateContent(codes);
  }
}

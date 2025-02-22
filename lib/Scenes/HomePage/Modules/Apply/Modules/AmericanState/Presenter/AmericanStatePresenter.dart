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
  List<CountryModel> countryTotalList = [];

  bool isCountryCode;

  AmericanStatePresenter(this.interactor, this.router, this.isCountryCode) {
    // interactor.sendCode();
  }

  fetchAreaCodes() async {
    var codes = await interactor.fetchAreaCodes();
    totalList = codes;
    view?.updateContent(codes);
  }

  fetchCountryDatas() async {
    var datas = await interactor.fetchCountrysData();
    countryTotalList = datas;
    view?.updateCountryContent(datas);
  }

  areaPressed(BuildContext context, AmericanStateModel model) {
    AppStatus.shared.stateModel = model;
    router.pop(context);
  }

  countryPressed(BuildContext context, CountryModel model) {
    AppStatus.shared.countryModel = model;
    router.pop(context);
  }

  searchPressed(String text) {
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

  countrySearchPressed(String text) {
    List<CountryModel> codes = [];
    if (text != "") {
      countryTotalList.forEach((element) {
        if (element.countryname.contains(text) || element.code.contains(text)) {
          codes.add(element);
        }
      });
    } else {
      codes = countryTotalList;
    }
    view?.updateCountryContent(codes);
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucardtemp/Data/UserInfo.dart';

import '../../../../HomePage/Entity/MycardsModel.dart';
import '../Interactor/CardSettingInteractor.dart';
import '../Router/CardSettingRouter.dart';
import '../View/CardSettingView.dart';

class CardSettingPresenter {
  final CardSettingInteractor interactor;
  final CardSettingRouter router;
  CardSettingView? view;

  //我的卡片列表
  List<MycardsModel> cardsList = [];

  CardSettingPresenter(this.interactor, this.router) {
    fetchMycardsList();
  }

  //设置卡片
  setCardPressed(BuildContext context, String cardOrder, String cardName,
      int isHide) async {
    var result = await interactor.setCard(cardOrder, cardName, isHide);
  }

  //请求我的卡片
  fetchMycardsList() async {
    getLocalCardInfo();
    var list = await interactor.fetchMycards();
    debugPrint('my cards $list');
    cardsList.clear();
    setLocalCardInfo(list);
    list.forEach((element) {
      if (element is Map<String, dynamic>) {
        var model = MycardsModel.parse(element);
        cardsList.add(model);
      }
    });
    view?.streamController.add(0);
  }

  void getLocalCardInfo() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    String cardInfo = perf.getString("local card info") ?? "";
    String localAccount = perf.getString("local account") ?? "";
    if (localAccount == UserInfo.shared.username) {
      var list = json.decode(cardInfo);
      list.forEach((element) {
        if (element is Map<String, dynamic>) {
          var model = MycardsModel.parse(element);
          cardsList.add(model);
        }
      });
      view?.streamController.add(0);
    } else {
      perf.setString("local card info", "");
      perf.setString("local account", "");
    }
  }

  //设置本地开关
  void setLocalCardInfo(List list) async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    perf.setString("local card info", json.encode(list));
    perf.setString("local account", UserInfo.shared.username);
  }

  //card delete
  cardDeleteConfirm(BuildContext context, String cardOrder) {
    router.showCardDeleteVerifyPage(context, cardOrder);
  }

  //card user info
  toCardUserInfoPage(BuildContext context) {
    router.showUserInfoPage(context);
  }
}

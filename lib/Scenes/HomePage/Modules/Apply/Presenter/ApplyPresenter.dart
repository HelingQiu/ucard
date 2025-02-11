import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Common/StreamCenter.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Entity/CardInfoModel.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Entity/CardTypeModel.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Model/WalletModel.dart';
import '../../../../../Network/Api.dart';
import '../Interactor/ApplyInteractor.dart';
import '../Router/ApplyRouter.dart';
import '../View/ApplyView.dart';

class ApplyPresenter {
  final ApplyInteractor interactor;
  ApplyView? view;
  final ApplyRouter router;

  final CardTypeModel card;

  bool applying = false;

  ApplyPresenter(this.interactor, this.router, this.card) {
    fetchCardConfigsListData();
    fetchWalletData();
  }

  //卡列表
  List<CardInfoModel> models = [];

  //钱包余额
  WalletModel? walletModel;

  int currentCard = 0; //虚拟卡 实体卡

  //点击申请
  applyConfirmPressed(
      BuildContext context, int level, String cardname, String level_name) {
    applyCardRequest(context, level, cardname, level_name);
  }

  //获取不同等级的卡申请条件
  fetchCardConfigsListData() async {
    var list = await interactor.fetchCardConfigsList();
    debugPrint('CardConfigsList $list');
    list.forEach((element) {
      if (element is Map<String, dynamic>) {
        var model = CardInfoModel.parse(element);
        models.add(model);
      }
    });
    view?.streamController.add(0);
  }

  //获取钱包余额
  fetchWalletData() async {
    var result = await interactor.getWalletBalance();
    if (result != null) {
      List accountList = result["account"];
      if (accountList.isNotEmpty) {
        walletModel = WalletModel.parse(accountList.first);
      }
      view?.streamController.add(0);
    }
  }

  //申请卡
  applyCardRequest(BuildContext context, int level, String card_name,
      String level_name) async {
    var result = await interactor.applyCard(
        card.cardBin, level, card.cardType, card_name);

    applying = false;
    view?.applyStreamController.add(0);
    if (context.mounted) {
      if (result[0] == 1) {
        String card_order = result[1]['card_order'];
        router.showApplyEndPage(
            context, card.cardType, level, card_name, level_name, card_order);
      } else {
        showDialog(
            context: context,
            builder: (_) {
              return ShowMessage(2, result[1], styleType: 1, width: 257);
            });
      }
    }
  }

  agreementButtonPressed(BuildContext context) {
    String agreementUrl = Api().apiUrl +
        "/api/conf/agreementinfo?" +
        "code=a002&&lang=${AppStatus.shared.lang}";
    if (agreementUrl != "") {
      router.showAgreementScene(context, agreementUrl);
    }
  }

  gotoAddressInfoPage(BuildContext context, int type) {
    router.showAddressScene(context, type);
  }

  areaCodeButtonPressed(BuildContext context) {
    router.showAreaCodeScene(context);
  }
}

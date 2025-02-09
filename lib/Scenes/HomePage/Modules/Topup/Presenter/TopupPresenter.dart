import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Common/StreamCenter.dart';
import 'package:ucardtemp/Model/WalletModel.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../Entity/MycardsModel.dart';
import '../../Apply/Entity/CardInfoModel.dart';
import '../Interactor/TopupInteractor.dart';
import '../Router/TopupRouter.dart';
import '../View/TopupView.dart';

class TopupPresenter {
  final TopupInteractor interactor;
  TopupView? view;
  final TopupRouter router;

  //当前卡信息
  MycardsModel cardModel;

  //当前卡片的配置信息
  CardInfoModel? cardInfoModel;

  //钱包余额
  WalletModel? walletModel;

  //正在充值
  bool topuping = false;

  TopupPresenter(this.interactor, this.router, this.cardModel) {
    fetchCardConfigsListData();
    fetchWalletData();
  }

  //获取不同等级的卡申请条件
  fetchCardConfigsListData() async {
    var list = await interactor.fetchCardConfigsList();
    debugPrint('CardConfigsList $list');
    list.forEach((element) {
      if (element is Map<String, dynamic>) {
        var model = CardInfoModel.parse(element);
        if (model.level == cardModel.level) {
          cardInfoModel = model;
        }
      }
    });
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

  //充值
  topupSuccessPressed(
      BuildContext context, String money, String receivedMoney) async {
    var result = await interactor.rechargeCard(cardModel.card_order, money);

    topuping = false;
    view?.topupStreamController.add(0);
    if (context.mounted) {
      if (result.isEmpty) {
        StreamCenter.shared.refreshAllStreamController
            .add({"type": "index", "content": "0"});
        router.showTopupSuccessPage(context, receivedMoney);
      } else {
        //
        showDialog(
            context: context,
            builder: (_) {
              return ShowMessage(2, result, styleType: 1, width: 257);
            });
      }
    }
  }

  //deposit
  depositPagePressed(BuildContext context) {
    router.showDepositPage(context);
  }
}

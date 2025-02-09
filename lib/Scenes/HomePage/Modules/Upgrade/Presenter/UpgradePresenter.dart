import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../../../Common/StreamCenter.dart';
import '../../../../../Model/WalletModel.dart';
import '../../../Entity/MycardsModel.dart';
import '../../Apply/Entity/CardInfoModel.dart';
import '../Interactor/UpgradeInteractor.dart';
import '../Router/UpgradeRouter.dart';
import '../View/UpgradeView.dart';

class UpgradePresenter {
  final UpgradeInteractor interactor;
  UpgradeView? view;
  final UpgradeRouter router;

  //当前卡信息
  MycardsModel cardModel;

  //卡列表
  List<CardInfoModel> configModels = [];
  //钱包余额
  WalletModel? walletModel;

  //正在升级
  bool upgrading = false;

  UpgradePresenter(this.interactor, this.router, this.cardModel) {
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
        if (model.level > cardModel.level) {
          configModels.add(model);
        }
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

  //确定升级
  applyConfirmPressed(BuildContext context, int new_level) async {
    var result = await interactor.upgradeCard(cardModel.card_order, new_level);

    upgrading = false;
    view?.upgradeStreamController.add(0);
    if (result.isEmpty) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (_) {
              return ShowMessage(2, 'Success'.tr(), styleType: 1, width: 257);
            });
        Future.delayed(Duration(seconds: 1)).then((value) {
          router.popToRoot(context);
        });
      } else {
        showDialog(
            context: context,
            builder: (_) {
              return ShowMessage(2, result.tr(), styleType: 1, width: 257);
            });
      }
    }
  }
}

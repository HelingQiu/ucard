import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Common/StreamCenter.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Entity/CardInfoModel.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Entity/CardTypeModel.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Modules/AddressInfo/AddressSingleton.dart';

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

  bool pasteHasValue = false;

  ApplyPresenter(this.interactor, this.router, this.card) {
    fetchWalletData();
    if (card.isPhysial) {
      currentCard = 1;
      fetchPhysicalCardConfigsData();
    } else {
      currentCard = 0;
      fetchCardConfigsListData();
    }
  }

  //卡列表
  List<CardInfoModel> models = [];

  //实体卡
  CardInfoModel? phycialModel;

  //钱包余额
  WalletModel? walletModel;

  int currentCard = 0; //虚拟卡 实体卡

  bool isProtocolSelected = true;

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

  //实体卡信息
  fetchPhysicalCardConfigsData() async {
    var result = await interactor.fetchPhycialData();
    debugPrint('PhysicalCardConfigsData $result');
    phycialModel = result;
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

  agreement005ButtonPressed(BuildContext context) {
    String agreementUrl = Api().apiUrl +
        "/api/conf/agreementinfo?" +
        "code=a005&&lang=${AppStatus.shared.lang}";
    if (agreementUrl != "") {
      router.showAgreementScene(context, agreementUrl, "Statement".tr());
    }
  }

  agreement004ButtonPressed(BuildContext context) {
    String agreementUrl = Api().apiUrl +
        "/api/conf/agreementinfo?" +
        "code=a004&&lang=${AppStatus.shared.lang}";
    if (agreementUrl != "") {
      router.showAgreementScene(context, agreementUrl, "Privacy Policy".tr());
    }
  }

  agreement006ButtonPressed(BuildContext context) {
    String agreementUrl = Api().apiUrl +
        "/api/conf/agreementinfo?" +
        "code=a006&&lang=${AppStatus.shared.lang}";
    if (agreementUrl != "") {
      router.showAgreementScene(
          context, agreementUrl, "Application Card Agreement".tr());
    }
  }

  gotoAddressInfoPage(BuildContext context, int type) {
    router.showAddressScene(context, type);
  }

  areaCodeButtonPressed(BuildContext context) {
    router.showAreaCodeScene(context);
  }

  cancelPressed(BuildContext context) {
    AddressSingleton.shared.shippingDict = null;
    AddressSingleton.shared.mailingDict = null;
    AddressSingleton.shared.residentialDict = null;
    router.pop(context);
  }

  payPressed(BuildContext context, Map<String, dynamic> body) async {
    var result = await interactor.applyPhycialCard(body);

    // applying = false;
    // view?.applyStreamController.add(0);
    if (context.mounted) {
      if (result[0] == 1) {
        if (card.service == 2) {
          view?.showAlertDialog(context, "Congratulations!".tr(),
              "Your physical card application is successful.".tr(),
              isPhycialSuccess: true);
        } else {
          view?.showAlertDialog(context, "Congratulations!".tr(),
              "Your virtual card application is successful.".tr(),
              isPhycialSuccess: true);
        }
      } else {
        showDialog(
            context: context,
            builder: (_) {
              return ShowMessage(2, result[1], styleType: 1, width: 257);
            });
      }
    }
  }

  backToRoot(BuildContext context) {
    AddressSingleton.shared.shippingDict = null;
    AddressSingleton.shared.mailingDict = null;
    AddressSingleton.shared.residentialDict = null;
    router.popToRoot(context);
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:ucardtemp/Common/StreamCenter.dart';
import 'package:ucardtemp/Scenes/HomePage/Entity/MycardsModel.dart';
import 'package:ucardtemp/Scenes/MainPage/Router/MainRouter.dart';

import '../../../Common/Notification.dart';
import '../../../Data/LoginCenter.dart';
import '../../../Data/UserInfo.dart';
import '../../../Model/WalletModel.dart';
import '../Entity/SettlementModel.dart';
import '../Interactor/HomeInteractor.dart';
import '../Router/HomeRouter.dart';
import '../View/HomeView.dart';

class HomePresenter {
  final HomeInteractor interactor;
  HomeView? view;
  final HomeRouter router;

  //当前选择时间
  DateTime selectTime = DateTime.now();

  //我的卡片列表
  List<MycardsModel> models = [];

  //钱包余额
  WalletModel? walletModel;

  bool showCardNum = false;
  Card33InfoModel? card33Model;

  HomePresenter(this.interactor, this.router) {
    // fetchMycardsList();
  }

  //登录
  loginPressed(BuildContext context) {
    LoginPageNotification().dispatch(context);
  }

  //notification
  notificationButtonPressed(BuildContext context) {
    router.showNotificationPage(context);
  }

  //apply
  applyButtonPressed(BuildContext context) {
    if (UserInfo.shared.isLoggedin) {
      router.showApplyPage(context);
    } else {
      loginPressed(context);
    }
  }

  //top-up
  topupButtonPressed(BuildContext context, MycardsModel item) {
    if (UserInfo.shared.isLoggedin) {
      router.showTopupPage(context, item);
    } else {
      loginPressed(context);
    }
  }

  //upgrade
  upgradeButtonPressed(BuildContext context, MycardsModel item) {
    if (UserInfo.shared.isLoggedin) {
      router.showUpgradePage(context, item);
    } else {
      loginPressed(context);
    }
  }

  //bill detail
  detailButtonPressed(BuildContext context, SettlementModel model) {
    if (UserInfo.shared.isLoggedin) {
      router.showDetailPage(context, model);
    } else {
      loginPressed(context);
    }
  }

  //bill
  gotoBillPage(BuildContext context, MycardsModel model) {
    if (UserInfo.shared.isLoggedin) {
      router.showBillPage(context, model);
    } else {
      loginPressed(context);
    }
  }

  //请求我的卡片
  fetchMycardsList() async {
    if (!UserInfo.shared.isLoggedin) {
      return;
    }
    await UserInfo.shared;
    var list = await interactor.fetchMycards();
    models.clear();
    list.forEach((element) {
      if (element is Map<String, dynamic>) {
        var model = MycardsModel.parse(element);
        models.add(model);
        debugPrint("image_bg is ${model.img_card_bg}");
      }
    });
    // if (models.isNotEmpty) {
    //   MycardsModel m = models[0];
    //   getSettlementData(m);
    // }
    view?.updateCardData();
  }

  searchUnReadMsg() async {
    if (UserInfo.shared.isLoggedin == false) {
      return;
    }
    var result = await UserInfo.shared.searchNotification();
    StreamCenter.shared.unReadMsgStreamController.add(0);
  }

  gotoSafePin(BuildContext context) {
    router.showSafePin(context);
  }

  gotoCardSetting(BuildContext context) {
    router.showCardSettingPage(context);
  }

  startSendCode(int codeType) async {
    bool result = await sendCodePressed(UserInfo.shared.username, codeType);
    if (result) {
      view?.isSent = true;
      view?.safetyController.add(0);
    }
  }

  Future<bool> sendCodePressed(String address, int codeType) async {
    List result = await LoginCenter().sendCode(
        address, codeType, (address == UserInfo.shared.email) ? 1 : 2);
    int number = result[0];
    if (number != 0) {
      //success, remaintime
      view?.isSent = true;

      view?.safetyController.add(0);
      return true;
    } else {
      // String message = result[1];
      // if (message.isNotEmpty) {
      //   view?.showError(context, message);
      // }
    }
    view?.isSent = false;
    view?.safetyController.add(0);
    return false;
  }

  //激活
  Future<Map> active33Card(
      String card_order, String code, String safepin) async {
    var body = await interactor.activeCard(card_order, code, safepin);

    return {"code": body?["status_code"], "msg": body?["message"] ?? ""};
  }

  //冻结
  Future<Map> freeze33Card(String card_order) async {
    var body = await interactor.freezeCard(card_order);
    return {"code": body?["status_code"], "msg": body?["message"] ?? ""};
  }

  //解冻结
  Future<Map> unfreeze33Card(
      String card_order, String code, String safepin) async {
    var body = await interactor.unfreeze33Card(card_order, code, safepin);

    return {"code": body?["status_code"], "msg": body?["message"] ?? ""};
  }

  //挂失
  Future<Map> lost33Card(String card_order, String code, String cardpin) async {
    var body = await interactor.lost33Card(card_order, code, cardpin);

    return {"code": body?["status_code"], "msg": body?["message"] ?? ""};
  }

  //姐挂失
  Future<Map> unlost33Card(
      String card_order, String code, String cardpin) async {
    var body = await interactor.unlost33Card(card_order, code, cardpin);

    return {"code": body?["status_code"], "msg": body?["message"] ?? ""};
  }

  //modify pin
  Future<Map> modpin33Card(String card_order, String code, String cardpin,
      String new_pin, String new_pin_c, String safepin) async {
    var body = await interactor.modpin33Card(
        card_order, code, cardpin, new_pin, new_pin_c, safepin);
    return {"code": body?["status_code"], "msg": body?["message"] ?? ""};
  }

  //卡卡转账
  Future<Map> transfer33Card(String card_order, String code, String cardpin,
      String cardNo, String amount) async {
    var body = await interactor.transfer33Card(
        card_order, code, cardpin, cardNo, amount);
    return {"code": body?["status_code"], "msg": body?["message"] ?? ""};
  }

  //显示卡号
  Future<Map> showCardDetail33(String card_order, String safepin) async {
    var body = await interactor.cardDetail33(card_order, safepin);

    return {
      "code": body?["status_code"],
      "msg": body?["message"] ?? "",
      "data": body?["data"]
    };
  }

  toSafetyPinPage(BuildContext context) {
    router.showSafePin(context);
  }
}

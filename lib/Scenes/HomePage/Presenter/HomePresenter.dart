import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:ucardtemp/Common/StreamCenter.dart';
import 'package:ucardtemp/Scenes/HomePage/Entity/MycardsModel.dart';
import 'package:ucardtemp/Scenes/MainPage/Router/MainRouter.dart';

import '../../../Common/Notification.dart';
import '../../../Data/LoginCenter.dart';
import '../../../Data/UserInfo.dart';
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

  //卡账单当前页码
  int currentPage = 1;

  //总页面
  int totalPage = 1;
  bool hasMore = true;

  //卡账单列表数据
  List<SettlementModel> settleMentList = [];

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
  gotoBillPage(BuildContext context) {
    if (UserInfo.shared.isLoggedin) {
      router.showBillPage(context);
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
    if (models.isNotEmpty) {
      MycardsModel m = models[0];
      getSettlementData(m);
    }
    view?.updateCardData();
  }

  //获取账单
  getSettlementData(MycardsModel item) {
    currentPage = 1;
    DateFormat dateFormat = DateFormat("yyyy-MM");
    String dateTime = dateFormat.format(selectTime);
    fetchMysettlementList(item.card_order, dateTime, currentPage);
  }

  getSettlementMoreData(MycardsModel item) {
    currentPage += 1;
    DateFormat dateFormat = DateFormat("yyyy-MM");
    String dateTime = dateFormat.format(selectTime);
    fetchMysettlementList(item.card_order, dateTime, currentPage);
  }

  //请求我的账单
  fetchMysettlementList(
    String card_order,
    String settle_date,
    int currentPage,
  ) async {
    await UserInfo.shared;
    var body =
        await interactor.fetchSettlements(card_order, settle_date, currentPage);
    if (currentPage == 1) {
      settleMentList.clear();
    }
    if (body != null) {
      var list = body['list'];
      totalPage = body['totalPage'];
      list.forEach((element) {
        if (element is Map<String, dynamic>) {
          var model = SettlementModel.parse(element);
          settleMentList.add(model);
        }
      });
    }
    if (currentPage < totalPage) {
      hasMore = true;
    } else {
      hasMore = false;
    }
    StreamCenter.shared.homeStreamController.add(0);
  }

  Future<String> downPressed(
      String card_order, String settle_date, int currentPage) async {
    return await fetchMysettlementDownUrl(card_order, settle_date, currentPage);
  }

  Future<String> fetchMysettlementDownUrl(
      String card_order, String settle_date, int currentPage) async {
    var body =
        await interactor.downSettlements(card_order, settle_date, currentPage);
    if (body != null) {
      var down_url = body["down_url"];
      print(down_url);
      return down_url;
    }
    return "";
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
}

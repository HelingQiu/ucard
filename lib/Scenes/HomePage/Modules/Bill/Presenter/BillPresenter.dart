import 'package:easy_localization/easy_localization.dart';

import '../../../../../Data/UserInfo.dart';
import '../../../Entity/MycardsModel.dart';
import '../../../Entity/SettlementModel.dart';
import '../Interactor/BillInteractor.dart';
import '../Router/BillRouter.dart';
import '../View/BillView.dart';

class BillPresenter {
  final BillInteractor interactor;
  BillView? view;
  final BillRouter router;
  MycardsModel model;

  BillPresenter(this.interactor, this.router, this.model) {
    getSettlementData();
  }

  //当前选择时间
  DateTime selectTime = DateTime.now();

  //卡账单当前页码
  int currentPage = 1;

  //总页面
  int totalPage = 1;
  bool hasMore = true;

  //卡账单列表数据
  List<SettlementModel> settleMentList = [];

//请求我的账单
  fetchMysettlementList(
    String card_order,
    String settle_date,
    int currentPage,
  ) async {
    await UserInfo.shared;
    var body = await interactor.fetchSettlements(
        card_order, settle_date, currentPage, model.service);
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
    view?.streamController.add(0);
  }

  //获取账单
  getSettlementData() {
    currentPage = 1;
    DateFormat dateFormat = DateFormat("yyyy-MM");
    String dateTime = dateFormat.format(selectTime);
    fetchMysettlementList(model.card_order, dateTime, currentPage);
  }

  getSettlementMoreData() {
    currentPage += 1;
    DateFormat dateFormat = DateFormat("yyyy-MM");
    String dateTime = dateFormat.format(selectTime);
    fetchMysettlementList(model.card_order, dateTime, currentPage);
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
}

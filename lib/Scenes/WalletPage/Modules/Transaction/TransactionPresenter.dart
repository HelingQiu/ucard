import 'package:easy_localization/easy_localization.dart';

import '../../Entity/TransCardrechargeModel.dart';
import 'TransactionInteractor.dart';
import 'TransactionRouter.dart';
import 'TransactionView.dart';

class TransactionPresenter {
  final TransactionInteractor interactor;
  TransactionView? view;
  final TransactionRouter router;

  bool isFetching = false;
  int page = 1;
  int totalPage = 1;
  bool hasMore = true;
  List<TransCardrechargeModel> records = [];

  TransactionPresenter(this.interactor, this.router) {
    fetchCardchargeList(1);
  }

  fetchCardchargeList(int page) async {
    isFetching = true;
    var body = await interactor.fetchTransList(page);

    if (page == 1) {
      records.clear();
    }
    if (body != null) {
      List data = body["list"];
      totalPage = body["totalPage"];
      if (data != null && data.isNotEmpty) {
        List<TransCardrechargeModel> transfers = [];
        data.forEach(
          (element) {
            TransCardrechargeModel m = TransCardrechargeModel.parse(element);
            if (m.rechargeId != 0) {
              transfers.add(m);
            }
          },
        );
        records.addAll(transfers);
      }
    }

    isFetching = false;
    if (page < totalPage) {
      hasMore = true;
    } else {
      hasMore = false;
    }
    view?.controller.add(0);
  }

  Future<bool> fetchRefreshList() async {
    page = 1;
    await fetchCardchargeList(page);
    return true;
  }

  Future<bool> fetchMoreList() async {
    page += 1;
    await fetchCardchargeList(page);
    return true;
  }
}

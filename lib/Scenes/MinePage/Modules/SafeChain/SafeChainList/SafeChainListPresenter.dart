import 'package:flutter/cupertino.dart';

import 'SafeChainListInteractor.dart';
import 'SafeChainListRouter.dart';
import 'SafeChainListView.dart';
import 'WhiteListModel.dart';

class SafeChainListPresenter {
  final SafeChainListInteractor interactor;
  final SafeChainListRouter router;
  SafeChainListView? view;

  List<WhiteListModel> chainList = [];

  SafeChainListPresenter(this.interactor, this.router) {
    getChainListData();
  }

  getChainListData() async {
    var body = await interactor.fetchWhiteList();

    if (body != null && body.isNotEmpty) {
      List mList = body['data'];
      List<WhiteListModel> data = [];
      mList.forEach(
        (element) {
          WhiteListModel m = WhiteListModel.parse(element);
          if (m.whiteId != 0) {
            data.add(m);
          }
        },
      );
      chainList.addAll(data);
    }
    view?.controller.add(0);
  }

  addButtonPressed(BuildContext context) {
    router.showAddSafeChainPage(context);
  }
}

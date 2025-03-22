import 'package:flutter/cupertino.dart';

import '../../Entity/CardRechargeDetailModel.dart';
import '../../Entity/TransferDetailModel.dart';
import 'TopupDetailInteractor.dart';
import 'TopupDetailRouter.dart';
import 'TopupDetailView.dart';

class TopupDetailPresenter {
  final TopupDetailInteractor interactor;
  TopupDetailView? view;
  final TopupDetailRouter router;
  int transferId;
  int cardSource;
  CardRechargeDetailModel model = CardRechargeDetailModel(
      "", 0, "", "", "", "", "", "", "", "", "", 0, DateTime.now());

  TopupDetailPresenter(
      this.interactor, this.router, this.transferId, this.cardSource) {
    fetchCardchargeDetail();
  }

  fetchCardchargeDetail() async {
    var m = await interactor.fetchCardchargeinfo(transferId, cardSource);
    if (m != null) {
      model = m;
      view?.updateModel(model);
    }
  }
}

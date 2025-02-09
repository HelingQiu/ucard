
import 'package:flutter/cupertino.dart';

import '../../Entity/TransferDetailModel.dart';
import 'WithdrwaDetailInteractor.dart';
import 'WithdrwaDetailRouter.dart';
import 'WithdrwaDetailView.dart';

class WithdrwaDetailPresenter {
  final WithdrwaDetailInteractor interactor;
  WithdrwaDetailView? view;
  final WithdrwaDetailRouter router;
  int type;
  int transferId;
  TransferDetailModel model = TransferDetailModel(0, "", "", "", "", 0, 0, "", "", 0);

  WithdrwaDetailPresenter(this.interactor, this.router, this.type, this.transferId) {
    if (type == 0) {
      fetchDepositDetail(transferId);
    }
    else if (type == 1) {
      fetchWithdrawDetail(transferId);
    }
  }

  fetchDepositDetail(int id) async {
    var m = await interactor.fetchDepositDetail(transferId);
    if (m != null) {
      model = m;
      debugPrint("fetchDepositDetail  ${model.currency} ${model.status} ${model.time}");
      view?.updateModel(model);
    }

  }

  fetchWithdrawDetail(int id) async {
    var m = await interactor.fetchWithdrawDetail(transferId);
    if (m != null) {
      model = m;
      debugPrint("fetchWithdrawDetail  ${model.currency} ${model.status} ${model.time}");
      view?.updateModel(model);
    }
  }
}

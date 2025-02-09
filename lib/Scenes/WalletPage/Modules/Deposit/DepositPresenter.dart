import 'package:ucardtemp/Common/StreamCenter.dart';

import '../../Entity/AddressModel.dart';
import 'DepositInteractor.dart';
import 'DepositRouter.dart';
import 'DepositView.dart';

class DepositPresenter {
  final DepositInteractor interactor;
  DepositView? view;
  final DepositRouter router;

  //生成地址模型
  AddressModel? addModel;

  String currency;

  DepositPresenter(this.interactor, this.router, this.currency) {
    fetchDepositAddress(currency, "BEP20", 0);
  }

  //生成地址
  fetchDepositAddress(String currency, String blockchain, int create) async {
    var address =
        await interactor.fetchDepositAddress(currency, blockchain, create);
    if (address != null) {
      AddressModel m = address;
      addModel = m;
      StreamCenter.shared.depositStreamController.add(0);
    }
  }
}

import '../../Entity/CardTypeModel.dart';
import 'ApplyUserInfoInteractor.dart';
import 'ApplyUserInfoRouter.dart';
import 'ApplyUserInfoView.dart';

class ApplyUserInfoPresenter {
  final ApplyUserInfoInteractor interactor;
  ApplyUserInfoView? view;
  final ApplyUserInfoRouter router;

  final CardTypeModel card;

  ApplyUserInfoPresenter(this.interactor, this.router, this.card) {}

  //提交持卡人信息
  Future<List> requestApplyCardUser(
      String first_name, String last_name, String state, String city, String address, String zipcode) async {
    return await interactor.applyCardUser(first_name, last_name, state, city, address, zipcode);
  }
}

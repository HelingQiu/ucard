import '../../../Entity/SettlementModel.dart';
import '../Interactor/DetailInteractor.dart';
import '../Router/DetailRouter.dart';
import '../View/DetailView.dart';

class DetailPresenter {
  final DetailInteractor interactor;
  DetailView? view;
  final DetailRouter router;

  SettlementModel model;

  DetailPresenter(this.interactor, this.router, this.model) {

  }

}
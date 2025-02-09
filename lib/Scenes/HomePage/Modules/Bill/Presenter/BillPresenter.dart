import '../Interactor/BillInteractor.dart';
import '../Router/BillRouter.dart';
import '../View/BillView.dart';

class BillPresenter {
  final BillInteractor interactor;
  BillView? view;
  final BillRouter router;
  BillPresenter(this.interactor, this.router) {

  }

  //当前选择时间
  DateTime selectTime = DateTime.now();


}
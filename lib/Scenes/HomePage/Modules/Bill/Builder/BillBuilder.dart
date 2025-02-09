import '../Interactor/BillInteractor.dart';
import '../Presenter/BillPresenter.dart';
import '../Router/BillRouter.dart';
import '../View/BillView.dart';

class BillBuilder {
  final BillView scene;
  BillBuilder._(this.scene);

  factory BillBuilder() {
    final router = BillRouter();
    final interactor = BillInteractor();
    final presenter = BillPresenter(interactor, router);
    final scene = BillView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return BillBuilder._(scene);
  }
}
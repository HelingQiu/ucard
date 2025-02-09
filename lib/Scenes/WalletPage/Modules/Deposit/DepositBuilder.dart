import 'DepositInteractor.dart';
import 'DepositPresenter.dart';
import 'DepositRouter.dart';
import 'DepositView.dart';

class DepositBuilder {
  final DepositView scene;
  DepositBuilder._(this.scene);

  factory DepositBuilder(String currency) {
    final router = DepositRouter();
    final interactor = DepositInteractor();
    final presenter = DepositPresenter(interactor, router, currency);
    final scene = DepositView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return DepositBuilder._(scene);
  }
}

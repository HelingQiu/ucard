import 'WithdrawInteractor.dart';
import 'WithdrawPresenter.dart';
import 'WithdrawRouter.dart';
import 'WithdrawView.dart';

class WithdrawBuilder {
  final WithdrawView scene;
  WithdrawBuilder._(this.scene);

  factory WithdrawBuilder(String currency, int withdrawType) {
    final router = WithdrawRouter();
    final interactor = WithdrawInteractor();
    final presenter =
        WithdrawPresenter(interactor, router, currency, withdrawType);
    final scene = WithdrawView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return WithdrawBuilder._(scene);
  }
}

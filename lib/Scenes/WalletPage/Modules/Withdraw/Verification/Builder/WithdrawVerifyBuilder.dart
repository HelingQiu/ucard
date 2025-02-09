import '../Interactor/WithdrawVerifyInteractor.dart';
import '../Presenter/WithdrawVerifyPresenter.dart';
import '../Router/WithdrawVerifyRouter.dart';
import '../View/WithdrawVerifyView.dart';

class WithdrawVerifyBuilder {
  final WithdrawVerifyView scene;
  WithdrawVerifyBuilder._(this.scene);

  factory WithdrawVerifyBuilder(
      String blockchain, String address, double amount) {
    final router = WithdrawVerifyRouter();
    final interactor = WithdrawVerifyInteractor();
    final presenter = WithdrawVerifyPresenter(
        interactor, router, blockchain, address, amount);
    final scene = WithdrawVerifyView(presenter);
    presenter.view = scene;
    return WithdrawVerifyBuilder._(scene);
  }
}

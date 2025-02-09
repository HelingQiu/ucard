import '../Interactor/WalletInteractor.dart';
import '../Presenter/WalletPresenter.dart';
import '../Router/WalletRouter.dart';
import '../View/WalletView.dart';

class WalletBuilder {
  final WalletView scene;
  WalletBuilder._(this.scene);

  factory WalletBuilder() {
    final router = WalletRouter();
    final interactor = WalletInteractor();
    final presenter = WalletPresenter(interactor,router);
    final scene = WalletView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return WalletBuilder._(scene);
  }
}
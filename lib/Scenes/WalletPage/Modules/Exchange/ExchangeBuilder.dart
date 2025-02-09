import '../../../../Model/WalletModel.dart';
import 'ExchangeInteractor.dart';
import 'ExchangePresenter.dart';
import 'ExchangeRouter.dart';
import 'ExchangeView.dart';

class ExchangeBuilder {
  final ExchangeView scene;
  ExchangeBuilder._(this.scene);

  factory ExchangeBuilder(
      List<WalletModel> balanceList, double rate_usdt_usdc) {
    final router = ExchangeRouter();
    final interactor = ExchangeInteractor();
    final presenter =
        ExchangePresenter(interactor, router, balanceList, rate_usdt_usdc);
    final scene = ExchangeView(presenter);
    presenter.view = scene;
    return ExchangeBuilder._(scene);
  }
}

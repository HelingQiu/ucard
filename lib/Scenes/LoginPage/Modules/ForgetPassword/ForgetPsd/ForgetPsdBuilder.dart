import 'ForgetPsdInteractor.dart';
import 'ForgetPsdPresenter.dart';
import 'ForgetPsdRouter.dart';
import 'ForgetPsdView.dart';

class ForgetPsdBuilder {
  final ForgetPsdView scene;
  ForgetPsdBuilder._(this.scene);

  factory ForgetPsdBuilder(
      int accountType, String forgetAccount, String smsCode) {
    final router = ForgetPsdRouter();
    final interactor = ForgetPsdInteractor();
    final presenter = ForgetPsdPresenter(
        interactor, router, accountType, forgetAccount, smsCode);
    final scene = ForgetPsdView(presenter);
    presenter.view = scene;
    return ForgetPsdBuilder._(scene);
  }
}

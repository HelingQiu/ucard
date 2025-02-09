import 'ForgetVerifyInteractor.dart';
import 'ForgetVerifyPresenter.dart';
import 'ForgetVerifyRouter.dart';
import 'ForgetVerifyView.dart';

class ForgetVerifyBuilder {
  final ForgetVerifyView scene;
  ForgetVerifyBuilder._(this.scene);

  factory ForgetVerifyBuilder(int method, String forgetAccount) {
    final router = ForgetVerifyRouter();
    final interactor = ForgetVerifyInteractor();
    final presenter =
    ForgetVerifyPresenter(interactor, router, method, forgetAccount);
    final scene = ForgetVerifyView(presenter);
    presenter.view = scene;
    return ForgetVerifyBuilder._(scene);
  }
}
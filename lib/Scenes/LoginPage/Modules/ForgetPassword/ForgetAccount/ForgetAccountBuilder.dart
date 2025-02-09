import 'ForgetAccountInteractor.dart';
import 'ForgetAccountPresenter.dart';
import 'ForgetAccountRouter.dart';
import 'ForgetAccountView.dart';

class ForgetAccountBuilder {
  final ForgetAccountView scene;
  ForgetAccountBuilder._(this.scene);

  factory ForgetAccountBuilder() {
    final router = ForgetAccountRouter();
    final interactor = ForgetAccountInteractor();
    final presenter = ForgetAccountPresenter(interactor, router);
    final scene = ForgetAccountView(presenter);
    presenter.view = scene;
    return ForgetAccountBuilder._(scene);
  }
}

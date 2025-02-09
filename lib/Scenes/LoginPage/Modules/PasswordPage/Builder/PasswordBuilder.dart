import '../Interactor/PasswordInteractor.dart';
import '../Presenter/PasswordPresenter.dart';
import '../Router/PasswordRouter.dart';
import '../View/PasswordView.dart';

class PasswordBuilder {
  final PasswordView scene;
  PasswordBuilder._(this.scene);

  factory PasswordBuilder(
    String account,
    String smscode,
    int method,
  ) {
    final router = PasswordRouter();
    final interactor = PasswordInteractor();
    final presenter =
        PasswordPresenter(interactor, router, account, smscode, method);
    final scene = PasswordView(presenter);
    presenter.view = scene;
    return PasswordBuilder._(scene);
  }
}

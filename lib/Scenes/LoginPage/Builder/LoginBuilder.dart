import '../Interactor/LoginInteractor.dart';
import '../Presenter/LoginPresenter.dart';
import '../Router/LoginRouter.dart';
import '../View/LoginView.dart';

class LoginBuilder {
  final LoginView scene;
  LoginBuilder._(this.scene);

  factory LoginBuilder() {
    final router = LoginRouter();
    final interactor = LoginInteractor();
    final presenter = LoginPresenter(interactor,router);
    final scene = LoginView(presenter);
    presenter.view = scene;
    return LoginBuilder._(scene);
  }
}
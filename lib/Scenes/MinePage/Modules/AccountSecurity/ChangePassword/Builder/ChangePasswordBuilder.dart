import '../Interactor/ChangePasswordInteractor.dart';
import '../Presenter/ChangePasswordPresenter.dart';
import '../Router/ChangePasswordRouter.dart';
import '../View/ChangePasswordView.dart';

class ChangePasswordBuilder {
  final ChangePasswordView scene;
  ChangePasswordBuilder._(this.scene);

  factory ChangePasswordBuilder() {
    final router = ChangePasswordRouter();
    final interactor = ChangePasswordInteractor();
    final presenter = ChangePasswordPresenter(interactor, router);
    final scene = ChangePasswordView(presenter);
    presenter.view = scene;
    return ChangePasswordBuilder._(scene);
  }
}

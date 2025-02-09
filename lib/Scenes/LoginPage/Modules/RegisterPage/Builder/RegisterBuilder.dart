import '../Interactor/RegisterInteractor.dart';
import '../Presenter/RegisterPresenter.dart';
import '../Router/RegisterRouter.dart';
import '../View/RegisterView.dart';

class RegisterBuilder {
  final RegisterView scene;
  RegisterBuilder._(this.scene);

  factory RegisterBuilder() {
    final router = RegisterRouter();
    final interactor = RegisterInteractor();
    final presenter = RegisterPresenter(interactor, router);
    final scene = RegisterView(presenter);
    presenter.view = scene;
    return RegisterBuilder._(scene);
  }
}

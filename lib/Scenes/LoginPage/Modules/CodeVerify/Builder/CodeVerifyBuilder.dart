import '../Interactor/CodeVerifyInteractor.dart';
import '../Presenter/CodeVerifyPresenter.dart';
import '../Router/CodeVerifyRouter.dart';
import '../View/CodeVerifyView.dart';

class CodeVerifyBuilder {
  final CodeVerifyView scene;
  CodeVerifyBuilder._(this.scene);

  factory CodeVerifyBuilder(int method, String loginAccount) {
    final router = CodeVerifyRouter();
    final interactor = CodeVerifyInteractor();
    final presenter =
        CodeVerifyPresenter(interactor, router, method, loginAccount);
    final scene = CodeVerifyView(presenter);
    presenter.view = scene;
    return CodeVerifyBuilder._(scene);
  }
}

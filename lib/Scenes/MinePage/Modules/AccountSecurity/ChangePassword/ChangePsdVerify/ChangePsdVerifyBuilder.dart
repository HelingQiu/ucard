import 'ChangePsdVerifyInteractor.dart';
import 'ChangePsdVerifyPresenter.dart';
import 'ChangePsdVerifyRouter.dart';
import 'ChangePsdVerifyView.dart';

class ChangePsdVerifyBuilder {
  final ChangePsdVerifyView scene;
  ChangePsdVerifyBuilder._(this.scene);

  factory ChangePsdVerifyBuilder(String oldPsd, String newPsd) {
    final router = ChangePsdVerifyRouter();
    final interactor = ChangePsdVerifyInteractor();
    final presenter =
        ChangePsdVerifyPresenter(interactor, router, oldPsd, newPsd);
    final scene = ChangePsdVerifyView(presenter);
    presenter.view = scene;
    return ChangePsdVerifyBuilder._(scene);
  }
}

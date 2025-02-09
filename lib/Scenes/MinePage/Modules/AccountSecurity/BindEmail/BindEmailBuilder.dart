import 'BindEmailInteractor.dart';
import 'BindEmailPresenter.dart';
import 'BindEmailRouter.dart';
import 'BindEmailView.dart';

class BindEmailBuilder {
  final BindEmailView scene;
  BindEmailBuilder._(this.scene);

  factory BindEmailBuilder(String loginAccount) {
    final router = BindEmailRouter();
    final interactor = BindEmailInteractor();
    final presenter = BindEmailPresenter(interactor, router, loginAccount);
    final scene = BindEmailView(presenter);
    presenter.view = scene;
    return BindEmailBuilder._(scene);
  }
}

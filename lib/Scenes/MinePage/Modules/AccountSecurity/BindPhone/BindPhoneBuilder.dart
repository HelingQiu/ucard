import 'BindPhoneInteractor.dart';
import 'BindPhonePresenter.dart';
import 'BindPhoneRouter.dart';
import 'BindPhoneView.dart';

class BindPhoneBuilder {
  final BindPhoneView scene;
  BindPhoneBuilder._(this.scene);

  factory BindPhoneBuilder(String loginAccount) {
    final router = BindPhoneRouter();
    final interactor = BindPhoneInteractor();
    final presenter = BindPhonePresenter(interactor, router, loginAccount);
    final scene = BindPhoneView(presenter);
    presenter.view = scene;
    return BindPhoneBuilder._(scene);
  }
}

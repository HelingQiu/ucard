import 'UpdatePhoneInteractor.dart';
import 'UpdatePhonePresenter.dart';
import 'UpdatePhoneRouter.dart';
import 'UpdatePhoneView.dart';

class UpdatePhoneBuilder {
  final UpdatePhoneView scene;
  UpdatePhoneBuilder._(this.scene);

  factory UpdatePhoneBuilder() {
    final router = UpdatePhoneRouter();
    final interactor = UpdatePhoneInteractor();
    final presenter = UpdatePhonePresenter(interactor, router);
    final scene = UpdatePhoneView(presenter);
    presenter.view = scene;
    return UpdatePhoneBuilder._(scene);
  }
}

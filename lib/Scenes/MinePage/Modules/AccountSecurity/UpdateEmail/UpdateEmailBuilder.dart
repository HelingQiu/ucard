import 'UpdateEmailInteractor.dart';
import 'UpdateEmailPresenter.dart';
import 'UpdateEmailRouter.dart';
import 'UpdateEmailView.dart';

class UpdateEmailBuilder {
  final UpdateEmailView scene;
  UpdateEmailBuilder._(this.scene);

  factory UpdateEmailBuilder() {
    final router = UpdateEmailRouter();
    final interactor = UpdateEmailInteractor();
    final presenter = UpdateEmailPresenter(interactor, router);
    final scene = UpdateEmailView(presenter);
    presenter.view = scene;
    return UpdateEmailBuilder._(scene);
  }
}

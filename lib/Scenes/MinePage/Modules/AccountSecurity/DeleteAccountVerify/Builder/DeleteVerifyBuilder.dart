import '../Interactor/DeleteVerifyInteractor.dart';
import '../Presenter/DeleteVerifyPresenter.dart';
import '../Router/DeleteVerifyRouter.dart';
import '../View/DeleteVerifyView.dart';

class DeleteVerifyBuilder {
  final DeleteVerifyView scene;
  DeleteVerifyBuilder._(this.scene);

  factory DeleteVerifyBuilder() {
    final router = DeleteVerifyRouter();
    final interactor = DeleteVerifyInteractor();
    final presenter = DeleteVerifyPresenter(interactor, router);
    final scene = DeleteVerifyView(presenter);
    presenter.view = scene;
    return DeleteVerifyBuilder._(scene);
  }
}

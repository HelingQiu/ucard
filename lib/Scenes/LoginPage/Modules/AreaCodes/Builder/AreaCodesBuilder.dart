import '../Interactor/AreaCodesInteractor.dart';
import '../Presenter/AreaCodesPresenter.dart';
import '../Router/AreaCodesRouter.dart';
import '../View/AreaCodesView.dart';

class AreaCodesBuilder {
  final AreaCodesView scene;
  AreaCodesBuilder._(this.scene);

  factory AreaCodesBuilder() {
    final router = AreaCodesRouter();
    final interactor = AreaCodesInteractor();
    final presenter = AreaCodesPresenter(interactor, router);
    final scene = AreaCodesView(presenter);
    presenter.view = scene;
    return AreaCodesBuilder._(scene);
  }
}

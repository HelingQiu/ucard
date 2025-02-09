import '../Interactor/MainInteractor.dart';
import '../Presenter/MainPresenter.dart';
import '../Router/MainRouter.dart';
import '../View/MainView.dart';

class MainBuilder {
  final MainView scene;
  MainBuilder._(this.scene);

  factory MainBuilder() {
    final router = MainRouter();
    final interactor = MainInteractor();
    final presenter = MainPresenter(interactor, router);
    final scene = MainView(presenter);
    presenter.view = scene;
    return MainBuilder._(scene);
  }
}

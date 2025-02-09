import '../Interactor/HomeInteractor.dart';
import '../Presenter/HomePresenter.dart';
import '../Router/HomeRouter.dart';
import '../View/HomeView.dart';

class HomeBuilder {
  final HomeView scene;
  HomeBuilder._(this.scene);

  factory HomeBuilder() {
    final router = HomeRouter();
    final interactor = HomeInteractor();
    final presenter = HomePresenter(interactor,router);
    final scene = HomeView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return HomeBuilder._(scene);
  }
}
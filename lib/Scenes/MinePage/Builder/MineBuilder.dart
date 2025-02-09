import '../Interactor/MineInteractor.dart';
import '../Presenter/MinePresenter.dart';
import '../Router/MineRouter.dart';
import '../View/MineView.dart';

class MineBuilder {
  final MineView scene;
  MineBuilder._(this.scene);

  factory MineBuilder() {
    final router = MineRouter();
    final interactor = MineInteractor();
    final presenter = MinePresenter(interactor, router);
    final scene = MineView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return MineBuilder._(scene);
  }
}

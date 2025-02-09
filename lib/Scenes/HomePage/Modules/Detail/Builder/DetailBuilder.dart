import '../../../Entity/SettlementModel.dart';
import '../Interactor/DetailInteractor.dart';
import '../Presenter/DetailPresenter.dart';
import '../Router/DetailRouter.dart';
import '../View/DetailView.dart';

class DetailBuilder {
  final DetailView scene;
  DetailBuilder._(this.scene);

  factory DetailBuilder(SettlementModel model) {
    final router = DetailRouter();
    final interactor = DetailInteractor();
    final presenter = DetailPresenter(interactor, router, model);
    final scene = DetailView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return DetailBuilder._(scene);
  }
}

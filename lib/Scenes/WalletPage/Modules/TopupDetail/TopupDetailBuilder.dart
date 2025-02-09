import 'TopupDetailInteractor.dart';
import 'TopupDetailPresenter.dart';
import 'TopupDetailRouter.dart';
import 'TopupDetailView.dart';

class TopupDetailBuilder {
  final TopupDetailView scene;
  TopupDetailBuilder._(this.scene);

  factory TopupDetailBuilder(int transferId) {
    final router = TopupDetailRouter();
    final interactor = TopupDetailInteractor();
    final presenter =
        TopupDetailPresenter(interactor, router, transferId);
    final scene = TopupDetailView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return TopupDetailBuilder._(scene);
  }
}

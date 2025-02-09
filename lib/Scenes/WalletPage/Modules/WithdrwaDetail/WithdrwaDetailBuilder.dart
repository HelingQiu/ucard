import 'WithdrwaDetailInteractor.dart';
import 'WithdrwaDetailPresenter.dart';
import 'WithdrwaDetailRouter.dart';
import 'WithdrwaDetailView.dart';

class WithdrwaDetailBuilder {
  final WithdrwaDetailView scene;
  WithdrwaDetailBuilder._(this.scene);

  factory WithdrwaDetailBuilder(int type, int transferId) {
    final router = WithdrwaDetailRouter();
    final interactor = WithdrwaDetailInteractor();
    final presenter =
        WithdrwaDetailPresenter(interactor, router, type, transferId);
    final scene = WithdrwaDetailView(presenter, type);
    presenter.view = scene;
    interactor.presenter = presenter;
    return WithdrwaDetailBuilder._(scene);
  }
}

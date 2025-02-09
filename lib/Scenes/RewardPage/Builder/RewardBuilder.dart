import '../Interactor/RewardInteractor.dart';
import '../Presenter/RewardPresenter.dart';
import '../Router/RewardRouter.dart';
import '../View/RewardView.dart';

class RewardBuilder {
  final RewardView scene;
  RewardBuilder._(this.scene);

  factory RewardBuilder() {
    final router = RewardRouter();
    final interactor = RewardInteractor();
    final presenter = RewardPresenter(interactor, router);
    final scene = RewardView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return RewardBuilder._(scene);
  }
}

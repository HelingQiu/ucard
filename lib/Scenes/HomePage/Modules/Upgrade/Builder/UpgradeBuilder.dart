import 'package:ucardtemp/Scenes/HomePage/Entity/MycardsModel.dart';

import '../Interactor/UpgradeInteractor.dart';
import '../Presenter/UpgradePresenter.dart';
import '../Router/UpgradeRouter.dart';
import '../View/UpgradeView.dart';

class UpgradeBuilder {
  final UpgradeView scene;
  UpgradeBuilder._(this.scene);

  factory UpgradeBuilder(MycardsModel card) {
    final router = UpgradeRouter();
    final interactor = UpgradeInteractor();
    final presenter = UpgradePresenter(interactor, router, card);
    final scene = UpgradeView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return UpgradeBuilder._(scene);
  }
}

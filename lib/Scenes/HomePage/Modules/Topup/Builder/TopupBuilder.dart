import 'package:ucardtemp/Scenes/HomePage/Entity/MycardsModel.dart';

import '../Interactor/TopupInteractor.dart';
import '../Presenter/TopupPresenter.dart';
import '../Router/TopupRouter.dart';
import '../View/TopupView.dart';

class TopupBuilder {
  final TopupView scene;
  TopupBuilder._(this.scene);

  factory TopupBuilder(MycardsModel item) {
    final router = TopupRouter();
    final interactor = TopupInteractor();
    final presenter = TopupPresenter(interactor, router, item);
    final scene = TopupView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return TopupBuilder._(scene);
  }
}

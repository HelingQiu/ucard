import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Entity/CardTypeModel.dart';

import '../Interactor/ApplyInteractor.dart';
import '../Presenter/ApplyPresenter.dart';
import '../Router/ApplyRouter.dart';
import '../View/ApplyView.dart';

class ApplyBuilder {
  final ApplyView scene;
  ApplyBuilder._(this.scene);

  factory ApplyBuilder(CardTypeModel card) {
    final router = ApplyRouter();
    final interactor = ApplyInteractor();
    final presenter = ApplyPresenter(interactor, router, card);
    final scene = ApplyView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return ApplyBuilder._(scene);
  }
}

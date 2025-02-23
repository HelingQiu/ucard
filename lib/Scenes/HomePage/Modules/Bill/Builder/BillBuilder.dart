import 'package:ucardtemp/Scenes/HomePage/Entity/MycardsModel.dart';

import '../Interactor/BillInteractor.dart';
import '../Presenter/BillPresenter.dart';
import '../Router/BillRouter.dart';
import '../View/BillView.dart';

class BillBuilder {
  final BillView scene;

  BillBuilder._(this.scene);

  factory BillBuilder(MycardsModel model) {
    final router = BillRouter();
    final interactor = BillInteractor();
    final presenter = BillPresenter(interactor, router, model);
    final scene = BillView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return BillBuilder._(scene);
  }
}

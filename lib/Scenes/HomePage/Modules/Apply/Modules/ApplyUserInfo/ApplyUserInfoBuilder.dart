import '../../Entity/CardTypeModel.dart';
import 'ApplyUserInfoInteractor.dart';
import 'ApplyUserInfoPresenter.dart';
import 'ApplyUserInfoRouter.dart';
import 'ApplyUserInfoView.dart';

class ApplyUserInfoBuilder {
  final ApplyUserInfoView scene;
  ApplyUserInfoBuilder._(this.scene);

  factory ApplyUserInfoBuilder(CardTypeModel card) {
    final router = ApplyUserInfoRouter();
    final interactor = ApplyUserInfoInteractor();
    final presenter = ApplyUserInfoPresenter(interactor, router, card);
    final scene = ApplyUserInfoView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return ApplyUserInfoBuilder._(scene);
  }
}

import '../Interactor/CardSettingInteractor.dart';
import '../Presenter/CardSettingPresenter.dart';
import '../Router/CardSettingRouter.dart';
import '../View/CardSettingView.dart';

class CardSettingBuilder {
  final CardSettingView scene;
  CardSettingBuilder._(this.scene);

  factory CardSettingBuilder() {
    final router = CardSettingRouter();
    final interactor = CardSettingInteractor();
    final presenter = CardSettingPresenter(interactor, router);
    final scene = CardSettingView(presenter);
    presenter.view = scene;
    return CardSettingBuilder._(scene);
  }
}

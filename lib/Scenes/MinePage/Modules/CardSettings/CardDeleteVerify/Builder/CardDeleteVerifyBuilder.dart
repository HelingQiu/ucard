import '../Interactor/CardDeleteVerifyInteractor.dart';
import '../Presenter/CardDeleteVerifyPresenter.dart';
import '../Router/CardDeleteVerifyRouter.dart';
import '../View/CardDeleteVerifyView.dart';

class CardDeleteVerifyBuilder {
  final CardDeleteVerifyView scene;
  CardDeleteVerifyBuilder._(this.scene);

  factory CardDeleteVerifyBuilder(String cardOrder) {
    final router = CardDeleteVerifyRouter();
    final interactor = CardDeleteVerifyInteractor();
    final presenter = CardDeleteVerifyPresenter(interactor, router, cardOrder);
    final scene = CardDeleteVerifyView(presenter);
    presenter.view = scene;
    return CardDeleteVerifyBuilder._(scene);
  }
}

import '../Interactor/AmericanStateInteractor.dart';
import '../Presenter/AmericanStatePresenter.dart';
import '../Router/AmericanStateRouter.dart';
import '../View/AmericanStateView.dart';

class AmericanStateBuilder {
  final AmericanStateView scene;

  AmericanStateBuilder._(this.scene);

  factory AmericanStateBuilder() {
    final router = AmericanStateRouter();
    final interactor = AmericanStateInteractor();
    final presenter = AmericanStatePresenter(interactor, router);
    final scene = AmericanStateView(presenter);
    presenter.view = scene;
    return AmericanStateBuilder._(scene);
  }
}

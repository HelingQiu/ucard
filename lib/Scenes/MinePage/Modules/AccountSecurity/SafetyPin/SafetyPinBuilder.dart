import 'SafetyPinInteractor.dart';
import 'SafetyPinPresenter.dart';
import 'SafetyPinRouter.dart';
import 'SafetyPinView.dart';

class SafetyPinBuilder {
  final SafetyPinView scene;
  SafetyPinBuilder._(this.scene);

  factory SafetyPinBuilder() {
    final router = SafetyPinRouter();
    final interactor = SafetyPinInteractor();
    final presenter = SafetyPinPresenter(interactor, router);
    final scene = SafetyPinView(presenter);
    presenter.view = scene;
    return SafetyPinBuilder._(scene);
  }
}

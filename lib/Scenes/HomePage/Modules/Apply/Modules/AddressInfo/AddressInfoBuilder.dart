import 'AddressInfoInteractor.dart';
import 'AddressInfoPresenter.dart';
import 'AddressInfoRouter.dart';
import 'AddressInfoView.dart';

class AddressInfoBuilder {
  final AddressInfoView scene;

  AddressInfoBuilder._(this.scene);

  factory AddressInfoBuilder(int type) {
    final router = AddressInfoRouter();
    final interactor = AddressInfoInteractor();
    final presenter = AddressInfoPresenter(interactor, router, type);
    final scene = AddressInfoView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return AddressInfoBuilder._(scene);
  }
}

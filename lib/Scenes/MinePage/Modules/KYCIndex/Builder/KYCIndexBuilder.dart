import '../Interactor/KYCIndexInteractor.dart';
import '../Presenter/KYCIndexPresenter.dart';
import '../Router/KYCIndexRouter.dart';
import '../View/KYCIndexView.dart';

class KYCIndexBuilder {
  final KYCIndexView scene;
  KYCIndexBuilder._(this.scene);

  factory KYCIndexBuilder() {
    final router = KYCIndexRouter();
    final interactor = KYCIndexInteractor();
    final presenter = KYCIndexPresenter(interactor, router);
    final scene = KYCIndexView(presenter);
    presenter.view = scene;
    return KYCIndexBuilder._(scene);
  }
}

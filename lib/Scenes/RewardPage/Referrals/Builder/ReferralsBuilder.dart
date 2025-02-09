import '../Interactor/ReferralsInteractor.dart';
import '../Presenter/ReferralsPresenter.dart';
import '../Router/ReferralsRouter.dart';
import '../View/ReferralsView.dart';

class ReferralsBuilder {
  final ReferralsView scene;
  ReferralsBuilder._(this.scene);

  factory ReferralsBuilder() {
    final router = ReferralsRouter();
    final interactor = ReferralsInteractor();
    final presenter = ReferralsPresenter(interactor, router);
    final scene = ReferralsView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return ReferralsBuilder._(scene);
  }
}

import 'SafeChainListInteractor.dart';
import 'SafeChainListPresenter.dart';
import 'SafeChainListRouter.dart';
import 'SafeChainListView.dart';

class SafeChainListBuilder {
  final SafeChainListView scene;
  SafeChainListBuilder._(this.scene);

  factory SafeChainListBuilder() {
    final router = SafeChainListRouter();
    final interactor = SafeChainListInteractor();
    final presenter = SafeChainListPresenter(interactor, router);
    final scene = SafeChainListView(presenter);
    presenter.view = scene;
    return SafeChainListBuilder._(scene);
  }
}

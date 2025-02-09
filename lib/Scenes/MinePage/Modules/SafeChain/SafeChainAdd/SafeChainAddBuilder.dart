import 'package:ucardtemp/Scenes/MinePage/Modules/SafeChain/SafeChainList/WhiteListModel.dart';

import 'SafeChainAddInteractor.dart';
import 'SafeChainAddPresenter.dart';
import 'SafeChainAddRouter.dart';
import 'SafeChainAddView.dart';

class SafeChainAddBuilder {
  final SafeChainAddView scene;
  SafeChainAddBuilder._(this.scene);

  factory SafeChainAddBuilder(WhiteListModel? model) {
    final router = SafeChainAddRouter();
    final interactor = SafeChainAddInteractor();
    final presenter = SafeChainAddPresenter(interactor, router, model);
    final scene = SafeChainAddView(presenter);
    presenter.view = scene;
    return SafeChainAddBuilder._(scene);
  }
}

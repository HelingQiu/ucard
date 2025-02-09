import 'TransactionInteractor.dart';
import 'TransactionPresenter.dart';
import 'TransactionRouter.dart';
import 'TransactionView.dart';

class TransactionBuilder {
  final TransactionView scene;
  TransactionBuilder._(this.scene);

  factory TransactionBuilder() {
    final router = TransactionRouter();
    final interactor = TransactionInteractor();
    final presenter = TransactionPresenter(interactor, router);
    final scene = TransactionView(presenter);
    presenter.view = scene;
    interactor.presenter = presenter;
    return TransactionBuilder._(scene);
  }
}

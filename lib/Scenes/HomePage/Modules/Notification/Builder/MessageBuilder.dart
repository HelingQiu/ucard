import '../Interactor/MessageInteractor.dart';
import '../Presenter/MessagePresenter.dart';
import '../Router/MessageRouter.dart';
import '../View/MessageDetailView.dart';
import '../View/MessageView.dart';

class MessageBuilder {
  final MessageView scene;
  MessageBuilder._(this.scene);

  factory MessageBuilder() {
    final router = MessageRouter();
    final interactor = MessageInteractor();
    final presenter = MessagePresenter(interactor, router);
    final scene = MessageView(presenter);
    presenter.view = scene;
    return MessageBuilder._(scene);
  }
}

class MessageDetailBuilder {
  final MessageDetailView scene;
  MessageDetailBuilder._(this.scene);

  factory MessageDetailBuilder(int messageId) {
    final router = MessageRouter();
    final interactor = MessageInteractor();
    final presenter = MessageDetailPresenter(interactor, router, messageId);
    final scene = MessageDetailView(presenter);
    presenter.view = scene;
    return MessageDetailBuilder._(scene);
  }
}

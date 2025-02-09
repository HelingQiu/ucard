import 'dart:async';

class StreamCenter {
  static StreamCenter shared = new StreamCenter._internal();
  StreamController<int> unReadMsgStreamController =
      StreamController.broadcast();
  StreamController<int> homeStreamController = StreamController.broadcast();
  StreamController<int> rewardStreamController = StreamController.broadcast();
  StreamController<int> earnStreamController = StreamController.broadcast();
  StreamController<int> profileStreamController = StreamController.broadcast();
  // 0: get data   1: need fetch data
  StreamController<int> myWalletStreamController = StreamController.broadcast();
  StreamController<Map> refreshAllStreamController =
      StreamController.broadcast();
  StreamController<int> depositStreamController = StreamController.broadcast();
  StreamController<int> earnDetailStreamController =
      StreamController.broadcast();
  StreamController<int> marketDetailStreamController = StreamController
      .broadcast(); //0: refresh   1: show leftview    2:hide leftview
  StreamController<int> marketDetailShowLeftStreamController = StreamController
      .broadcast(); //0:display  1:hide  2:appear with animation  3:disappear with animation
  StreamController<int> loginRefreshStreamController =
      StreamController.broadcast();
  StreamController<int> registerRefreshStreamController =
      StreamController.broadcast();
  StreamController<int> forgetRefreshStreamController =
      StreamController.broadcast();
  StreamController<int> referralsShareStreamController =
      StreamController.broadcast();
  StreamController<int> referralsStreamController =
      StreamController.broadcast();
  StreamController<int> withdrawWarningStreamController =
      StreamController.broadcast();
  StreamController<int> withdrawStreamController = StreamController.broadcast();
  StreamController<int> codeViewStreamController = StreamController.broadcast();
  StreamController<int> loginVerifyStreamController =
      StreamController.broadcast();
  StreamController<int> productsHistoryStreamController =
      StreamController.broadcast();
  StreamController<int> incomeAnalysisStreamController =
      StreamController.broadcast();
  StreamController<int> newUserTaskStreamController =
      StreamController.broadcast();

  StreamCenter._internal() {}
}

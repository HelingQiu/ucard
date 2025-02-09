import 'package:flutter/cupertino.dart';

import '../../../Common/StreamCenter.dart';
import '../../../Data/UserInfo.dart';
import '../Entity/MyawardsModel.dart';
import '../Entity/RewardModel.dart';
import '../Interactor/RewardInteractor.dart';
import '../Router/RewardRouter.dart';
import '../View/RewardView.dart';

class RewardPresenter {
  final RewardInteractor interactor;
  RewardView? view;
  final RewardRouter router;

  int firstNum = 0;
  int secondNum = 19;
  int thirdNum = 49;
  int forthNum = 99;
  int toppedNum = 0;

  //推荐奖励数据
  RewardModel? awardModel;
  //推荐奖励列表
  List<MyawardsModel> awardsList = [];

  RewardPresenter(this.interactor, this.router) {}

  //获取推荐数据
  getAwards() async {
    if (!UserInfo.shared.isLoggedin) {
      return;
    }
    await UserInfo.shared;
    var result = await interactor.getMyawards();
    if (result != null) {
      awardModel = RewardModel.parse(result);
      toppedNum = awardModel?.recharge ?? 0;
      StreamCenter.shared.rewardStreamController.add(0);
    }
  }

  //推荐奖励列表
  fetchMyawardsList() async {
    if (!UserInfo.shared.isLoggedin) {
      return;
    }
    await UserInfo.shared;
    awardsList.clear();
    var body = await interactor.fetchAwards();
    if (body != null) {
      var list = body['list'];
      list.forEach((element) {
        if (element is Map<String, dynamic>) {
          var model = MyawardsModel.parse(element);
          awardsList.add(model);
        }
      });
    }
    StreamCenter.shared.rewardStreamController.add(0);
  }

  //referrals
  referralsPressed(BuildContext context) {
    router.showReferralsPage(context);
  }
}

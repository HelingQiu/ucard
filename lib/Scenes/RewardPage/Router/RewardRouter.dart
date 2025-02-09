import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Scenes/RewardPage/Referrals/Builder/ReferralsBuilder.dart';

import '../../../Common/BaseRouter.dart';

class RewardRouter extends BaseRouter {
  //跳转记录列表
  showReferralsPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ReferralsBuilder().scene));
  }
}

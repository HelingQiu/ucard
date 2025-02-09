import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Common/BaseRouter.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/SafeChain/SafeChainList/WhiteListModel.dart';
import 'package:ucardtemp/Scenes/WalletPage/Modules/Withdraw/Verification/Builder/WithdrawVerifyBuilder.dart';

import '../../../MinePage/Modules/AccountSecurity/SafetyPin/SafetyPinBuilder.dart';
import '../../../MinePage/Modules/SafeChain/SafeChainAdd/SafeChainAddBuilder.dart';

class WithdrawRouter extends BaseRouter {
  //验证码
  showWithdrawVerificationPage(
      BuildContext context, String blockchain, String address, double amount) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            WithdrawVerifyBuilder(blockchain, address, amount).scene));
  }

  //添加安全链
  showAddSafeChainPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SafeChainAddBuilder(null).scene));
  }

  showEditSafeChainPage(BuildContext context, WhiteListModel model) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SafeChainAddBuilder(model).scene));
  }

  //设置安全码
  showSafetyPinPage(BuildContext context,) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SafetyPinBuilder().scene));
  }
}

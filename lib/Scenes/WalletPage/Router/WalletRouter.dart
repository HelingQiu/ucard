import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Model/WalletModel.dart';
import 'package:ucardtemp/Scenes/WalletPage/Modules/Deposit/DepositBuilder.dart';
import 'package:ucardtemp/Scenes/WalletPage/Modules/Exchange/ExchangeBuilder.dart';
import 'package:ucardtemp/Scenes/WalletPage/Modules/TopupDetail/TopupDetailBuilder.dart';
import 'package:ucardtemp/Scenes/WalletPage/Modules/Transaction/TransactionBuilder.dart';
import 'package:ucardtemp/Scenes/WalletPage/Modules/Withdraw/WithdrawBuilder.dart';
import 'package:ucardtemp/Scenes/WalletPage/Modules/WithdrwaDetail/WithdrwaDetailBuilder.dart';

import '../../../Common/BaseRouter.dart';

class WalletRouter extends BaseRouter {
  //history
  showHistoryPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TransactionBuilder().scene));
  }

  //depost
  showDepositPage(BuildContext context, String currency) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DepositBuilder(currency).scene));
  }

  //withdraw
  showWithdrawPage(BuildContext context, String currency, int withdrawType) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WithdrawBuilder(currency, withdrawType).scene));
  }

  //exchange
  showExchangePage(BuildContext context, List<WalletModel> walletList,
      double rate_usdt_usdc) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ExchangeBuilder(walletList, rate_usdt_usdc).scene));
  }

  //detail
  showWithdrawDepositPage(BuildContext context, int type, int transferId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WithdrwaDetailBuilder(type, transferId).scene));
  }

  //card recharge
  showCardRechargeDetailPage(
      BuildContext context, int transferId, int cardSource) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            TopupDetailBuilder(transferId, cardSource).scene));
  }
}

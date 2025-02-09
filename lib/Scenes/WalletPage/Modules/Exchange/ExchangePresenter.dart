import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Common/ShowMessage.dart';
import '../../../../Model/WalletModel.dart';
import 'ExchangeInteractor.dart';
import 'ExchangeRouter.dart';
import 'ExchangeView.dart';

class ExchangePresenter {
  final ExchangeInteractor interactor;
  ExchangeView? view;
  final ExchangeRouter router;
  List<WalletModel> walletList;
  double rate_usdt_usdc;

  WalletModel usdtModel = WalletModel("", "");
  WalletModel usdcModel = WalletModel("", "");

  bool isUsdcToUsdt = true;

  ExchangePresenter(
      this.interactor, this.router, this.walletList, this.rate_usdt_usdc) {
    handleBalance();
  }

  void handleBalance() {
    if (walletList.isNotEmpty && walletList.length == 2) {
      usdtModel = walletList[0];
      usdcModel = walletList[1];
    } else if (walletList.isNotEmpty && walletList.length == 1) {
      usdtModel = walletList[0];
    }
    view?.controller.add(0);
  }

  exchangePressed(BuildContext context, String currency_out, String currency_in,
      String amount) async {
    var dic = await interactor.exchangeMoney(
      currency_out,
      currency_in,
      amount,
    );
    if (dic != null && dic is Map) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          showDialog(
              context: context,
              builder: (_) {
                return ShowMessage(2, "Exchange successfully".tr(),
                    styleType: 1, width: 257);
              });
          Future.delayed(Duration(seconds: 1)).then(
            (value) => {
              router.popToRoot(context),
            },
          );
        } else {
          String message = dic["message"];
          if (message != null) {
            showDialog(
                context: context,
                builder: (_) {
                  return ShowMessage(2, message, styleType: 1, width: 257);
                });
          }
        }
      }
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(2, "Error".tr(), styleType: 1, width: 257);
          });
    }
  }
}

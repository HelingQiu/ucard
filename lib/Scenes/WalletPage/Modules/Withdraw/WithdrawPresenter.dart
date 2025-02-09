import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Common/StreamCenter.dart';
import 'package:ucardtemp/Scenes/WalletPage/Modules/Withdraw/Entity/RecentReferModel.dart';

import '../../../../Common/NumberPlus.dart';
import '../../../../Common/ShowMessage.dart';
import '../../../../Data/LoginCenter.dart';
import '../../../../Data/UserInfo.dart';
import '../../../MinePage/Modules/SafeChain/SafeChainList/WhiteListModel.dart';
import 'Entity/WithdrawInitModel.dart';
import 'QrcodeScanView.dart';
import 'WithdrawInteractor.dart';
import 'WithdrawRouter.dart';
import 'WithdrawView.dart';

class WithdrawPresenter {
  final WithdrawInteractor interactor;
  WithdrawView? view;
  final WithdrawRouter router;

  WithdrawInitModel withdrawInfo = WithdrawInitModel("", "0", "0", "", [], "0");
  //手续费
  double gas = 0;
  //输入金额
  double inputAmount = 0;
  //最终金额
  double finalAmount = 0;
  //选择网络
  String blockchain = "BEP20";

  //选择币种
  String currency;
  //账户提现或者地址提现
  int withdrawType;

  List<RecentReferModel> recentList = [];

  WithdrawPresenter(
      this.interactor, this.router, this.currency, this.withdrawType) {
    fetchWithdrawInit();
  }

  //初始化
  fetchWithdrawInit() async {
    var model = await interactor.fetchWithdrawInit(currency);
    if (model != null) {
      withdrawInfo = model;
      gas = 0;
      for (FeeModel model in withdrawInfo.fees) {
        if (model.blockchain == blockchain) {
          gas = inputAmount * model.feePercent + model.gasFee;
          break;
        }
      }
      StreamCenter.shared.withdrawStreamController.add(0);
    }
  }

  fetchRecentList() async {
    var result = await interactor.fetchRecentReferList();
    List<RecentReferModel> rList = [];
    if (result != null && result.isNotEmpty) {
      List mList = result['data']['list'];
      List<RecentReferModel> data = [];
      mList.forEach(
        (element) {
          RecentReferModel m = RecentReferModel.parse(element);
          if (m.recentId != 0) {
            data.add(m);
          }
        },
      );
      rList.addAll(data);
    }
    return rList;
  }

  //更新金额
  updateAmount(String str) {
    inputAmount = (num.tryParse(str) ?? 0).toDouble();
    gas = 0;
    if (withdrawType == 1) {
      gas = double.parse(withdrawInfo.fee_transfer);
    } else {
      for (FeeModel model in withdrawInfo.fees) {
        if (model.blockchain == blockchain) {
          gas = inputAmount * model.feePercent + model.gasFee;
          break;
        }
      }
    }

    finalAmount = inputAmount - gas;
    if (finalAmount < 0) {
      finalAmount = 0;
    }
    StreamCenter.shared.withdrawStreamController.add(0);
  }

  //提现
  withdrawButtonPressed(BuildContext context, String address, String code, String safePin) async {
    String error = '';
    if (withdrawInfo.currency == "" || blockchain == "") {
      error = "Wrong currency or blockchain".tr();
    } else if (address == "") {
      error = "Wrong address".tr();
    } else if (inputAmount <= 0 ||
        inputAmount < double.parse(withdrawInfo.min)) {
      error = "Minimum amount not reached".tr();
    } else if (finalAmount <= 0 ||
        finalAmount >
            double.parse(NumberPlus.removeZero(withdrawInfo.available))) {
      error = "Insufficient quantity".tr();
    }
    if (error.isNotEmpty) {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(2, error, styleType: 1, width: 257);
          });
      return;
    }
    //跳转到验证码页面
    // router.showWithdrawVerificationPage(
    //     context, blockchain, address, inputAmount);
    var result = await interactor.withdrawDo(
        UserInfo.shared.username,
        (UserInfo.shared.username == UserInfo.shared.email) ? 1 : 2,
        currency,
        code,
        blockchain,
        address,
        inputAmount,
        safePin,
        context);
    if (context.mounted) {
      if (result[0] == 1) {
        showDialog(
            context: context,
            builder: (_) {
              return ShowMessage(2, "Withdraw successfully".tr(),
                  styleType: 1, width: 257);
            });
        Future.delayed(Duration(seconds: 1)).then(
              (value) => {
            router.popToRoot(context),
          },
        );
      } else {
        var message = result[1] ?? "";
        if (message != null && message is String) {
          showDialog(
              context: context,
              builder: (_) {
                return ShowMessage(2, message,
                    styleType: 1, width: 257);
              });
        }
      }
    }
  }

  Future<List<WhiteListModel>> fetchWhiteList() async {
    var body = await interactor.fetchWhiteList(currency, blockchain);

    List<WhiteListModel> chainList = [];
    if (body != null && body.isNotEmpty) {
      List mList = body['data'];
      List<WhiteListModel> data = [];
      mList.forEach(
        (element) {
          WhiteListModel m = WhiteListModel.parse(element);
          if (m.whiteId != 0) {
            data.add(m);
          }
        },
      );
      chainList.addAll(data);
    }
    return chainList;
  }

  //跳转到扫码界面
  toScanQrcodePage(BuildContext context) {}

  //添加安全链
  toAddSafeChainPage(BuildContext context) {
    router.showAddSafeChainPage(context);
  }

  toEditSafeChainPage(BuildContext context, WhiteListModel model) {
    router.showEditSafeChainPage(context, model);
  }

  toSafetyPinPage(BuildContext context) {
    router.showSafetyPinPage(context);
  }

  //delete
  deleteSafeChain(BuildContext context, int listId) async {
    var result = await interactor.deleteWhiteList(listId);
    if (result != null && result is Map) {
      var code = result["status_code"];
      if (code != null) {
        if (code == 200) {
          showDialog(
              context: context,
              builder: (_) {
                return ShowMessage(2, "Delete Chain successfully".tr(),
                    styleType: 1, width: 257);
              });
        } else {
          String message = result["message"];
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

  startSendCode() async {
    bool result = await sendCodePressed(UserInfo.shared.username);
    if (result) {
      view?.isSent = true;
      view?.safetyController.add(0);
    }
  }

  Future<bool> sendCodePressed(String address) async {
    List result = await LoginCenter()
        .sendCode(address, withdrawType == 0 ? 7 : 16, (address == UserInfo.shared.email) ? 1 : 2);
    int number = result[0];
    if (number != 0) {
      //success, remaintime
      view?.isSent = true;

      view?.safetyController.add(0);
      return true;
    } else {
      // String message = result[1];
      // if (message.isNotEmpty) {
      //   view?.showError(context, message);
      // }
    }
    view?.isSent = false;
    view?.safetyController.add(0);
    return false;
  }

  withdrawSubmitPressed(BuildContext context, String inputAmount,
      String account, String code, String safePin) async {
    var dic = await interactor.transToUcardAccount(
        inputAmount, account, code, safePin, currency);
    if (dic != null && dic is Map) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          showDialog(
              context: context,
              builder: (_) {
                return ShowMessage(2, "Withdraw successfully".tr(),
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Data/UserInfo.dart';
import 'package:ucardtemp/Scenes/WalletPage/Entity/CardRechargeModel.dart';

import '../../../Common/ShowMessage.dart';
import '../../../Common/StreamCenter.dart';
import '../../../Data/AppStatus.dart';
import '../../../Model/WalletModel.dart';
import '../Entity/TransCardrechargeModel.dart';
import '../Entity/TransferModel.dart';
import '../Interactor/WalletInteractor.dart';
import '../Router/WalletRouter.dart';
import '../View/WalletView.dart';

class WalletPresenter {
  final WalletInteractor interactor;
  WalletView? view;
  final WalletRouter router;

  //钱包
  List<WalletModel> walletList = [];
  double rate_usdt_usdc = 0;

  WalletModel? walletModel;
  int selectedType = 0; // 0:deposit   1:withdraw  2:purchase
  int page = 0;
  int size = 10;
  int totalPage = 0;
  bool hasMore = true;
  List<TransferModel> depositRecords = [];
  List<TransferModel> withdrawRecords = [];
  List<CardRechargeModel> cardRechargeRecords = [];
  List<TransCardrechargeModel> exchargeRecords = [];
  bool isFetching = false;

  WalletPresenter(this.interactor, this.router) {}

  //获取钱包余额
  fetchWalletData() async {
    if (!UserInfo.shared.isLoggedin) {
      return;
    }
    await UserInfo.shared;
    var result = await interactor.getWalletBalance();
    walletList.clear();
    if (result != null) {
      List accountList = result["account"];
      rate_usdt_usdc = double.parse(result["rate_usdt_usdc"].toString());
      if (accountList.isNotEmpty) {
        accountList.forEach((element) {
          WalletModel model = WalletModel.parse(element);
          walletList.add(model);
        });
      }
      StreamCenter.shared.myWalletStreamController.add(0);
    }
  }

  //列表数据
  Future<void> fetchListData() async {
    if (!UserInfo.shared.isLoggedin) {
      return;
    }
    isFetching = true;
    page = 1;
    size = 10;
    hasMore = true;
    if (selectedType == 0) {
      fetchDepositList(page);
    } else if (selectedType == 1) {
      fetchWithdrawList(page);
    } else if (selectedType == 2) {
      fetchCardRechargeList(page);
    } else if (selectedType == 3) {
      fetchExchangeList(page);
    }
  }

  //更多
  Future<bool> fetchMoreListData() async {
    if (isFetching) {
      await Future.delayed(const Duration(milliseconds: 2000), () {});
    }
    isFetching = true;
    if (selectedType == 0) {
      return fetchMoreDepositList();
    } else if (selectedType == 1) {
      return fetchMoreWithdrawList();
    } else if (selectedType == 2) {
      return fetchMoreCardRechargeList();
    } else if (selectedType == 3) {
      return fetchMoreExchangeList();
    }
    return true;
  }

  //充值
  fetchDepositList(int p) async {
    isFetching = true;
    var records = await interactor.fetchDepositList(p, size);
    if (selectedType != 0) {
      return;
    }
    if (page == 1) {
      depositRecords.clear();
    }
    depositRecords.addAll(records);
    isFetching = false;
    if (records.length <= totalPage) {
      hasMore = false;
    } else {
      hasMore = true;
    }
    StreamCenter.shared.myWalletStreamController.add(0);
  }

  Future<bool> fetchMoreDepositList() async {
    page += 1;
    await fetchDepositList(page);
    return true;
  }

  //提现
  fetchWithdrawList(int p) async {
    isFetching = true;
    var records = await interactor.fetchWithdrawList(p, size);
    if (selectedType != 1) {
      return;
    }
    if (page == 1) {
      withdrawRecords.clear();
    }
    withdrawRecords.addAll(records);
    isFetching = false;
    if (records.length < size) {
      hasMore = false;
    } else {
      hasMore = true;
    }
    StreamCenter.shared.myWalletStreamController.add(0);
  }

  Future<bool> fetchMoreWithdrawList() async {
    page += 1;
    await fetchWithdrawList(page);
    return true;
  }

  //卡充值
  fetchCardRechargeList(int p) async {
    isFetching = true;
    var records = await interactor.fetchCardchargeList(p, size);
    if (selectedType != 2) {
      return;
    }
    if (page == 1) {
      cardRechargeRecords.clear();
    }
    if (records.isNotEmpty) {
      totalPage = records[0];
      cardRechargeRecords.addAll(records[1]);
      isFetching = false;
      if (p <= totalPage) {
        hasMore = true;
      } else {
        hasMore = false;
      }
      StreamCenter.shared.myWalletStreamController.add(0);
    }
  }

  Future<bool> fetchMoreCardRechargeList() async {
    page += 1;
    await fetchCardRechargeList(page);
    return true;
  }

  //exchange
  fetchExchangeList(int p) async {
    isFetching = true;
    var records = await interactor.fetchExchangeList(p, size);
    if (selectedType != 3) {
      return;
    }
    if (page == 1) {
      exchargeRecords.clear();
    }
    if (records.isNotEmpty) {
      totalPage = records[0];
      exchargeRecords.addAll(records[1]);
      isFetching = false;
      if (p <= totalPage) {
        hasMore = true;
      } else {
        hasMore = false;
      }
      StreamCenter.shared.myWalletStreamController.add(0);
    }
  }

  fetchMoreExchangeList() async {
    page += 1;
    await fetchExchangeList(page);
    return true;
  }

  //history
  histroyButtonPressed(BuildContext context) {
    router.showHistoryPage(context);
  }

  //deposit
  depositPagePressed(BuildContext context, String currency) {
    router.showDepositPage(context, currency);
  }

  //exchange
  exchangePagePressed(BuildContext context) {
    router.showExchangePage(context, walletList, rate_usdt_usdc);
  }

  //withdraw
  withdrawPagePressed(BuildContext context, String currency, int withdrawType) {
    if (UserInfo.shared.isKycVerified != 1 &&
        AppStatus.shared.withdrawWithoutKyc == false) {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(
                2, "Please Complete Identity Verification First".tr(),
                dismissSeconds: 2, styleType: 1, width: 257);
          });
      return;
    }
    router.showWithdrawPage(context, currency, withdrawType);
  }

  //detail
  withdrawDepositDetailPressed(BuildContext context, int type, int transferId) {
    router.showWithdrawDepositPage(context, type, transferId);
  }

  //卡充值详情
  cardRechargeDetailPressed(
      BuildContext context, int transferId, int cardSource) {
    router.showCardRechargeDetailPage(context, transferId, cardSource);
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_lifecycle/flutter_page_lifecycle.dart';
import 'package:loadmore/loadmore.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';
import 'package:ucardtemp/Common/NumberPlus.dart';
import 'package:ucardtemp/Model/WalletModel.dart';

import '../../../Common/StreamCenter.dart';
import '../../../Common/TextImageButton.dart';
import '../../../Data/AppStatus.dart';
import '../../../Data/UserInfo.dart';
import '../../../gen_a/A.dart';
import '../../../main.dart';
import '../Presenter/WalletPresenter.dart';
import 'package:badges/badges.dart' as badges;

class WalletView extends StatelessWidget {
  final WalletPresenter presenter;

  WalletView(this.presenter);

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return PageLifecycle(
        stateChanged: (appear) {
          if (appear) {
            if (UserInfo.shared.email == AppStatus.shared.specialAccount) {
              presenter.selectedType = 2;
              StreamCenter.shared.myWalletStreamController.add(0);
            }
            presenter.fetchWalletData();
            presenter.fetchListData();
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor, //修改颜色
            ),
            elevation: 0,
            centerTitle: false,
            toolbarHeight: 40,
            backgroundColor: theme == AppTheme.light
                ? AppStatus.shared.bgWhiteColor
                : AppStatus.shared.bgBlackColor,
            title: Text(
              'Wallet'.tr(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor),
            ),
            actions: [
              InkWell(
                onTap: () {
                  presenter.histroyButtonPressed(context);
                },
                child: Container(
                  height: 30,
                  width: 40,
                  child: Image.asset(theme == AppTheme.light
                      ? A.assets_wallet_history_black
                      : A.assets_wallet_history),
                ),
              ),
            ],
          ),
          body: StreamBuilder<int>(
            stream: StreamCenter.shared.myWalletStreamController.stream,
            builder: (context, snapshot) {
              return Container(
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgWhiteColor
                    : AppStatus.shared.bgBlackColor,
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildTopView(context),
                      SizedBox(
                        height: 10,
                      ),
                      _buildHistoryRow(context),
                      SizedBox(
                        height: 20,
                      ),
                      _buildHistoryListView(context),
                      _buildNodataView(context),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  //顶部
  Widget _buildTopView(BuildContext context) {
    String amout =
        "${presenter.walletModel?.balance ?? "0.0"} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : presenter.walletModel?.currency ?? "USDT"}";
    return Container(
      height: (presenter.walletList.length == 1) ? 120 : 200,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 15),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _theme == AppTheme.light
                ? AppStatus.shared.bgGreyLightColor
                : AppStatus.shared.bgGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " " + "Total Asset".tr(),
                          style: TextStyle(
                              color: AppStatus.shared.textGreyColor,
                              fontSize: 16),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            UserInfo.shared.hideBalance =
                                !UserInfo.shared.hideBalance;
                            UserInfo.shared.saveHideBalance();
                            StreamCenter.shared.myWalletStreamController.add(0);
                          },
                          child: Container(
                            child: Image.asset(UserInfo.shared.hideBalance
                                ? _theme == AppTheme.light
                                    ? A.assets_unvisible_black
                                    : A.assets_wallet_visible_close
                                : _theme == AppTheme.light
                                    ? A.assets_visible_black
                                    : A.assets_wallet_visible_open),
                          ),
                        ),
                      ],
                    ),
                  )),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: presenter.walletList.length,
                  itemBuilder: (context, index) {
                    WalletModel model = presenter.walletList[index];
                    var showAmount = "${model.balance}${model.currency}";
                    if(UserInfo.shared.email == AppStatus.shared.specialAccount) {
                      showAmount = "${model.balance} USD";
                    }
                    return Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text(
                          (UserInfo.shared.hideBalance
                              ? "***"
                              : showAmount),
                          style: TextStyle(
                              color: _theme == AppTheme.light
                                  ? AppStatus.shared.bgBlackColor
                                  : AppStatus.shared.bgWhiteColor,
                              fontSize: 20),
                        ),
                      ),
                    );
                  }),
              Visibility(
                visible:
                    (UserInfo.shared.email != AppStatus.shared.specialAccount),
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 36,
                        decoration: BoxDecoration(
                            color: _theme == AppTheme.light
                                ? ColorsUtil.hexColor(0x000000, alpha: 0.24)
                                : AppStatus.shared.bgBlueColor,
                            borderRadius: BorderRadius.circular(18)),
                        child: Center(
                          child: TextImageButton(
                            margin: 2,
                            type: TextIconButtonType.imageLeft,
                            icon: Image.asset(_theme == AppTheme.light
                                ? A.assets_wallet_down_black
                                : A.assets_wallet_down),
                            text: Text(
                              'Deposit'.tr(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: _theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor),
                            ),
                            onTap: () {
                              // presenter.depositPagePressed(context);
                              showSelectCurrencyDiolog(context, 0);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 100,
                        height: 36,
                        decoration: BoxDecoration(
                            color: _theme == AppTheme.light
                                ? ColorsUtil.hexColor(0x000000, alpha: 0.24)
                                : AppStatus.shared.bgBlueColor,
                            borderRadius: BorderRadius.circular(18)),
                        child: Center(
                          child: TextImageButton(
                            margin: 2,
                            type: TextIconButtonType.imageLeft,
                            icon: Image.asset(_theme == AppTheme.light
                                ? A.assets_wallet_up_black
                                : A.assets_wallet_up),
                            text: Text(
                              'Withdraw'.tr(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: _theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor),
                            ),
                            onTap: () {
                              // presenter.withdrawPagePressed(context);
                              showSelectCurrencyDiolog(context, 1);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 100,
                        height: 36,
                        decoration: BoxDecoration(
                            color: _theme == AppTheme.light
                                ? ColorsUtil.hexColor(0x000000, alpha: 0.24)
                                : AppStatus.shared.bgBlueColor,
                            borderRadius: BorderRadius.circular(18)),
                        child: Center(
                          child: TextImageButton(
                            margin: 2,
                            type: TextIconButtonType.imageLeft,
                            icon: Image.asset(_theme == AppTheme.light
                                ? A.assets_exchange_black
                                : A.assets_wallet_up),
                            text: Text(
                              'Exchange'.tr(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: _theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor),
                            ),
                            onTap: () {
                              presenter.exchangePagePressed(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //历史记录
  Widget _buildHistoryRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History'.tr(),
            style: TextStyle(
                fontSize: 15,
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  presenter.selectedType = 0;
                  StreamCenter.shared.myWalletStreamController.add(0);
                  presenter.fetchListData();
                },
                child: Visibility(
                  visible: (UserInfo.shared.email !=
                      AppStatus.shared.specialAccount),
                  child: Container(
                    width: 65,
                    height: 26,
                    decoration: BoxDecoration(
                        color: presenter.selectedType == 0
                            ? AppStatus.shared.bgBlueColor
                            : _theme == AppTheme.light
                                ? AppStatus.shared.bgGreyLightColor
                                : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(13)),
                    child: Center(
                      child: Text(
                        'Deposit'.tr(),
                        style: TextStyle(
                            fontSize: 12,
                            color: _theme == AppTheme.light
                                ? presenter.selectedType == 0
                                    ? AppStatus.shared.bgWhiteColor
                                    : AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible:
                    (UserInfo.shared.email != AppStatus.shared.specialAccount),
                child: SizedBox(
                  width: 12,
                ),
              ),
              GestureDetector(
                onTap: () {
                  presenter.selectedType = 1;
                  StreamCenter.shared.myWalletStreamController.add(0);
                  presenter.fetchListData();
                },
                child: Visibility(
                  visible: (UserInfo.shared.email !=
                      AppStatus.shared.specialAccount),
                  child: Container(
                    width: 75,
                    height: 26,
                    decoration: BoxDecoration(
                        color: presenter.selectedType == 1
                            ? AppStatus.shared.bgBlueColor
                            : _theme == AppTheme.light
                                ? AppStatus.shared.bgGreyLightColor
                                : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(13)),
                    child: Center(
                      child: Text(
                        'Withdraw'.tr(),
                        style: TextStyle(
                            fontSize: 12,
                            color: _theme == AppTheme.light
                                ? presenter.selectedType == 1
                                    ? AppStatus.shared.bgWhiteColor
                                    : AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible:
                    (UserInfo.shared.email != AppStatus.shared.specialAccount),
                child: SizedBox(
                  width: 12,
                ),
              ),
              GestureDetector(
                onTap: () {
                  presenter.selectedType = 2;
                  StreamCenter.shared.myWalletStreamController.add(0);
                  presenter.fetchListData();
                },
                child: Container(
                  width: 65,
                  height: 26,
                  decoration: BoxDecoration(
                      color: presenter.selectedType == 2
                          ? AppStatus.shared.bgBlueColor
                          : _theme == AppTheme.light
                              ? AppStatus.shared.bgGreyLightColor
                              : AppStatus.shared.bgDarkGreyColor,
                      borderRadius: BorderRadius.circular(13)),
                  child: Center(
                    child: Text(
                      'Top-up'.tr(),
                      style: TextStyle(
                          fontSize: 12,
                          color: _theme == AppTheme.light
                              ? presenter.selectedType == 2
                                  ? AppStatus.shared.bgWhiteColor
                                  : AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible:
                    (UserInfo.shared.email != AppStatus.shared.specialAccount),
                child: SizedBox(
                  width: 12,
                ),
              ),
              GestureDetector(
                onTap: () {
                  presenter.selectedType = 3;
                  StreamCenter.shared.myWalletStreamController.add(0);
                  presenter.fetchListData();
                },
                child: Container(
                  width: 65,
                  height: 26,
                  decoration: BoxDecoration(
                      color: presenter.selectedType == 3
                          ? AppStatus.shared.bgBlueColor
                          : _theme == AppTheme.light
                              ? AppStatus.shared.bgGreyLightColor
                              : AppStatus.shared.bgDarkGreyColor,
                      borderRadius: BorderRadius.circular(13)),
                  child: Center(
                    child: Text(
                      'Exchange'.tr(),
                      style: TextStyle(
                          fontSize: 12,
                          color: _theme == AppTheme.light
                              ? presenter.selectedType == 3
                                  ? AppStatus.shared.bgWhiteColor
                                  : AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //历史列表
  Widget _buildHistoryListView(BuildContext context) {
    int itemCount = 0;
    switch (presenter.selectedType) {
      case 0:
        itemCount = presenter.depositRecords.length;
        break;
      case 1:
        itemCount = presenter.withdrawRecords.length;
        break;
      case 2:
        itemCount = presenter.cardRechargeRecords.length;
        break;
      case 3:
        itemCount = presenter.exchargeRecords.length;
        break;
    }
    debugPrint('xxxxxxxxxxxx==========xxxxxxxxxxxx$itemCount');
    return Visibility(
      visible: itemCount > 0,
      child: Expanded(
        child: EasyRefresh(
          header: MaterialHeader(),
          footer: MaterialFooter(),
          onRefresh: () async {
            debugPrint("111111111111111");
            if (presenter.selectedType == 2) {
              await presenter.fetchListData();
            }
          },
          onLoad: () {
            if (presenter.selectedType == 2) {
              presenter.fetchMoreListData();
              if (!presenter.hasMore) {
                return IndicatorResult.noMore;
              }
            }
          },
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              Color color = AppStatus.shared.bgDarkGreyColor;
              var imageName = '';
              var imageBg = '';
              var title = '';
              var subTitle = '';
              var money = '';
              var time = '';
              if (presenter.selectedType == 0) {
                imageName = A.assets_wallet_history_eth;
                title = presenter.depositRecords[index].status;

                double moneynum =
                    double.parse(presenter.depositRecords[index].money);
                money = NumberPlus.displayNumber(moneynum, "") +
                    " " +
                    ((UserInfo.shared.email == AppStatus.shared.specialAccount)
                        ? "USD"
                        : presenter.depositRecords[index].currency);
                time = DateFormat("yyyy-MM-dd HH:mm:ss")
                    .format(presenter.depositRecords[index].time);
                subTitle = presenter.depositRecords[index].address;
              } else if (presenter.selectedType == 1) {
                imageName = A.assets_wallet_history_eth;
                title = presenter.withdrawRecords[index].status;
                double moneynum =
                    double.parse(presenter.withdrawRecords[index].money);
                money = NumberPlus.displayNumber(moneynum, "") +
                    " " +
                    ((UserInfo.shared.email == AppStatus.shared.specialAccount)
                        ? "USD"
                        : presenter.withdrawRecords[index].currency);
                time = DateFormat("yyyy-MM-dd HH:mm:ss")
                    .format(presenter.withdrawRecords[index].time);
                subTitle = presenter.withdrawRecords[index].address;
              } else if (presenter.selectedType == 2) {
                imageName = A.assets_wallet_topup_icon;
                title = presenter.cardRechargeRecords[index].card_no;
                subTitle =
                    presenter.cardRechargeRecords[index].card_type == "master"
                        ? "Mastercard"
                        : "Visa";
                money = presenter.cardRechargeRecords[index].money +
                    " " +
                    ((UserInfo.shared.email == AppStatus.shared.specialAccount)
                        ? "USD"
                        : presenter.cardRechargeRecords[index].currency);
                // DateTime datetime = DateTime.parse(
                //     presenter.cardRechargeRecords[index].created_at);
                // time =
                //     DateFormat("yyyy-MM-dd HH:mm:ss").format(datetime.toUtc());
                time = DateFormat("yyyy-MM-dd HH:mm:ss").format(
                    presenter.cardRechargeRecords[index].created_at_int);

                if (presenter.cardRechargeRecords[index].card_level <= 1) {
                  imageBg = A.assets_wallet_topup_level1;
                } else if (presenter.cardRechargeRecords[index].card_level ==
                    2) {
                  imageBg = A.assets_wallet_topup_level2;
                }
                if (presenter.cardRechargeRecords[index].card_level == 3) {
                  imageBg = A.assets_wallet_topup_level3;
                }
                if (presenter.cardRechargeRecords[index].card_level == 4) {
                  imageBg = A.assets_wallet_topup_level4;
                }
              } else if (presenter.selectedType == 3) {
                imageName = A.assets_wallet_history_eth;
                title = presenter.exchargeRecords[index].trans_code_str;
                double moneynum =
                    double.parse(presenter.exchargeRecords[index].money);
                money = NumberPlus.displayNumber(moneynum, "") +
                    " " +
                    ((UserInfo.shared.email == AppStatus.shared.specialAccount)
                        ? "USD"
                        : presenter.exchargeRecords[index].currency);
                time = presenter.exchargeRecords[index].created_at;
                subTitle = presenter.exchargeRecords[index].trans_code;
              }
              return InkWell(
                onTap: () {
                  //
                  if (presenter.selectedType == 0) {
                    presenter.withdrawDepositDetailPressed(
                        context,
                        presenter.depositRecords[index].type,
                        presenter.depositRecords[index].transferId);
                  } else if (presenter.selectedType == 1) {
                    presenter.withdrawDepositDetailPressed(
                        context,
                        presenter.withdrawRecords[index].type,
                        presenter.withdrawRecords[index].transferId);
                  } else if (presenter.selectedType == 2) {
                    presenter.cardRechargeDetailPressed(context,
                        presenter.cardRechargeRecords[index].rechargeId);
                  } else {}
                },
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 0, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Visibility(
                              visible: presenter.selectedType == 2,
                              child: Image.asset(imageBg),
                            ),
                            Image.asset(imageName),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                      color: _theme == AppTheme.light
                                          ? AppStatus.shared.bgBlackColor
                                          : AppStatus.shared.bgWhiteColor,
                                      fontSize: 15),
                                ),
                                Text(
                                  money,
                                  style: TextStyle(
                                      color: _theme == AppTheme.light
                                          ? AppStatus.shared.bgBlackColor
                                          : AppStatus.shared.bgWhiteColor,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  subTitle,
                                  style: TextStyle(
                                      color: AppStatus.shared.textGreyColor,
                                      fontSize: 12),
                                ),
                                Text(
                                  time,
                                  style: TextStyle(
                                      color: AppStatus.shared.textGreyColor,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNodataView(BuildContext context) {
    int itemCount = 0;
    switch (presenter.selectedType) {
      case 0:
        itemCount = presenter.depositRecords.length;
        break;
      case 1:
        itemCount = presenter.withdrawRecords.length;
        break;
      case 2:
        itemCount = presenter.cardRechargeRecords.length;
        break;
    }
    debugPrint('xxxxxxxxxxxx==========$itemCount');
    return Visibility(
      visible: itemCount == 0,
      child: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(A.assets_ucard_nodata),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "No data  ".tr(),
                style: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //弹窗
  showSelectCurrencyDiolog(BuildContext context, int type) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 200, minWidth: double.infinity),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return Container(
              decoration: BoxDecoration(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : ColorsUtil.hexColor(0x2E2E2E),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Select Currency Type".tr(),
                      style: TextStyle(
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: InkWell(
                      onTap: () {
                        if (type == 0) {
                          print('ddddddd');
                          presenter.depositPagePressed(context, 'USDT');
                        } else {
                          showSelectWithdrawMethodDiolog(context, 'USDT');
                        }
                      },
                      child: Container(
                        height: 44.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppStatus.shared.bgBlueColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(22))),
                        child: Image.asset(
                          A.assets_wallet_usdt,
                          width: 83,
                          height: 24,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: InkWell(
                      onTap: () {
                        if (type == 0) {
                          presenter.depositPagePressed(context, 'USDC');
                        } else {
                          showSelectWithdrawMethodDiolog(context, 'USDC');
                        }
                      },
                      child: Container(
                        height: 44.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppStatus.shared.bgBlueColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(22))),
                        child: Image.asset(
                          A.assets_wallet_usdc,
                          width: 83,
                          height: 24,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        }).whenComplete(() {});
  }

  //账号
  showSelectWithdrawMethodDiolog(BuildContext context, String currency) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 200, minWidth: double.infinity),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return Container(
              decoration: BoxDecoration(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : ColorsUtil.hexColor(0x2E2E2E),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Select Withdraw Method".tr(),
                      style: TextStyle(
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: InkWell(
                      onTap: () {
                        presenter.withdrawPagePressed(context, currency, 0);
                      },
                      child: Container(
                        height: 44.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppStatus.shared.bgBlueColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(22))),
                        child: Center(
                          child: Text(
                            'On-Chain Whtidrawal(BNB/ETH/Tron)'.tr(),
                            style: TextStyle(
                                color: AppStatus.shared.bgWhiteColor,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: InkWell(
                      onTap: () {
                        presenter.withdrawPagePressed(context, currency, 1);
                      },
                      child: Container(
                          height: 44.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppStatus.shared.bgBlueColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22))),
                          child: Center(
                            child: Text(
                              'Ucard Transferral'.tr(),
                              style: TextStyle(
                                  color: AppStatus.shared.bgWhiteColor,
                                  fontSize: 16),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            );
          });
        }).whenComplete(() {});
  }
}

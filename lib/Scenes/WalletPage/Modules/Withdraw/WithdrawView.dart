import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ucardtemp/Common/NumberPlus.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Modules/ApplyUserInfo/CustomFormatter.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/SafeChain/SafeChainList/WhiteListModel.dart';
import 'package:ucardtemp/Scenes/WalletPage/Modules/Deposit/QrcodeView.dart';
import 'package:ucardtemp/Scenes/WalletPage/Modules/Withdraw/QrcodeScanView.dart';
import '../../../../Common/CustomWidget.dart';
import '../../../../Common/ShowMessage.dart';
import '../../../../Common/StreamCenter.dart';
import '../../../../Data/AppStatus.dart';
import '../../../../Data/UserInfo.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';
import 'Entity/RecentReferModel.dart';
import 'WithdrawPresenter.dart';

class WithdrawView extends StatelessWidget {
  final WithdrawPresenter presenter;

  WithdrawView(this.presenter);

  final TextEditingController _addressController =
      TextEditingController(text: '');
  final TextEditingController _amountController =
      TextEditingController(text: '');
  ScrollController _scrollController = ScrollController();
  int _selecedNetWork = 0;

  int selectChain = -1;
  int selectAccount = -1;

  StreamController<int> quickController = StreamController.broadcast();

  StreamController<int> safetyController = StreamController.broadcast();
  final TextEditingController _safetyPinCodeController =
      TextEditingController(text: '');
  final _safetyPinfocusNode = FocusNode();
  String _safetyPinCode = "";

  bool isSent = false;
  final TextEditingController _emailCodeController =
      TextEditingController(text: '');
  final _emailfocusNode = FocusNode();
  String _emailCode = "";

  final ValueNotifier<bool> _sendCodeSuccess = ValueNotifier<bool>(false);

  ScrollController _safeScroController = ScrollController();

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return StreamBuilder<int>(
        stream: StreamCenter.shared.withdrawStreamController.stream,
        builder: (context, snapshot) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
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
                'Withdraw'.tr(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: theme == AppTheme.light
                        ? AppStatus.shared.bgBlackColor
                        : AppStatus.shared.bgWhiteColor),
              ),
            ),
            backgroundColor: theme == AppTheme.light
                ? AppStatus.shared.bgWhiteColor
                : AppStatus.shared.bgBlackColor,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              },
              child: Container(
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgWhiteColor
                    : AppStatus.shared.bgBlackColor,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildTopInfo(context),
                          presenter.withdrawType == 0
                              ? _buildNetworkView(context)
                              : Container(),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 20),
                            child: Text(
                              presenter.withdrawType == 1
                                  ? "You may register or edit friend's accounts in 'Settings'"
                                      .tr()
                                  : 'Warning: The withdraw addresses of BEP20 and ERC20 networks are different'
                                      .tr(),
                              style: TextStyle(
                                color: AppStatus.shared.textGreyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 32),
                            child: Text(
                              'Destination address'.tr(),
                              style: TextStyle(
                                color: AppStatus.shared.textGreyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //
                          _buildAddressView(context),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 32),
                            child: Text(
                              'Withdrawal amount'.tr(),
                              style: TextStyle(
                                color: AppStatus.shared.textGreyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          _buildAmountView(context),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 20),
                            child: Text(
                              "Withdrawable balance".tr() +
                                  '：${NumberPlus.removeZero(presenter.withdrawInfo.available)} ${presenter.currency}',
                              style: TextStyle(
                                color: AppStatus.shared.textGreyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 5),
                            child: RichText(
                              //必传文本
                              text: TextSpan(
                                text: "Network Fee：".tr(),
                                style: TextStyle(
                                  color: AppStatus.shared.textGreyColor,
                                  fontSize: 14,
                                ),
                                //手势监听
                                children: [
                                  TextSpan(
                                    text: presenter.withdrawType == 1
                                        ? "${NumberPlus.displayValue(double.parse(presenter.withdrawInfo.fee_transfer), presenter.withdrawInfo.currency)} ${presenter.currency}"
                                        : "${NumberPlus.displayValue(presenter.gas, presenter.withdrawInfo.currency)} ${presenter.currency}",
                                    style: TextStyle(
                                        color: AppStatus.shared.bgBlueColor,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _buildNoteInfoView(context),
                          SizedBox(
                            height: 250,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 150,
                      child: Container(
                        color: theme == AppTheme.light
                            ? AppStatus.shared.bgWhiteColor
                            : ColorsUtil.hexColor(0x2e2e2e),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Receive Amount".tr(),
                                    style: TextStyle(
                                        color: theme == AppTheme.light
                                            ? AppStatus.shared.bgBlackColor
                                            : AppStatus.shared.bgWhiteColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${NumberPlus.displayNumber(presenter.finalAmount, presenter.withdrawInfo.currency)} ${presenter.currency}",
                                    style: TextStyle(
                                        color: theme == AppTheme.light
                                            ? AppStatus.shared.bgBlackColor
                                            : AppStatus.shared.bgWhiteColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  if (presenter.withdrawType == 1) {
                                    if (UserInfo.shared.has_safe_pin != 1) {
                                      showAlertDialog(context, "Notes", "You have not set up your payment safety pin.");
                                    } else {
                                      String error = "";
                                      double inputAmount =
                                          presenter.inputAmount;
                                      if (_addressController.text == "") {
                                        error = "Wrong address".tr();
                                      } else if (inputAmount <= 0 ||
                                          inputAmount <
                                              double.parse(
                                                  presenter.withdrawInfo.min)) {
                                        error =
                                            "Minimum amount not reached".tr();
                                      } else if (presenter.finalAmount <= 0 ||
                                          presenter.finalAmount >
                                              double.parse(
                                                  NumberPlus.removeZero(
                                                      presenter.withdrawInfo
                                                          .available))) {
                                        error = "Insufficient quantity".tr();
                                      }
                                      if (error.isNotEmpty) {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return ShowMessage(2, error,
                                                  styleType: 1, width: 257);
                                            });
                                        return;
                                      }
                                      showSafetyAuthView(context);
                                    }
                                  } else {
                                    if (UserInfo.shared.has_safe_pin != 1) {
                                      showAlertDialog(context, "Notes", "You have not set up your payment safety pin.");
                                    }else{
                                      String error = '';
                                      if (presenter.withdrawInfo.currency == "" || presenter.blockchain == "") {
                                        error = "Wrong currency or blockchain".tr();
                                      } else if (_addressController.text == "") {
                                        error = "Wrong address".tr();
                                      } else if (presenter.inputAmount <= 0 ||
                                          presenter.inputAmount < double.parse(presenter.withdrawInfo.min)) {
                                        error = "Minimum amount not reached".tr();
                                      } else if (presenter.finalAmount <= 0 ||
                                          presenter.finalAmount >
                                              double.parse(NumberPlus.removeZero(presenter.withdrawInfo.available))) {
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
                                      showSafetyAuthView(context);
                                    }
                                  }
                                },
                                child: Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppStatus.shared.bgBlueColor,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Withdraw".tr(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ),
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
        },
      );
    });
  }

  //顶部
  Widget _buildTopInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 20),
      child: Row(
        children: [
          Image.asset(presenter.currency == 'USDT'
              ? A.assets_wallet_usdt_icon
              : A.assets_exchange_usdc1),
          SizedBox(
            width: 12,
          ),
          Text(
            presenter.currency,
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Ethereum',
            style: TextStyle(
                color: AppStatus.shared.textGreyColor,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
        ],
      ),
    );
  }

  //network
  Widget _buildNetworkView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select network'.tr(),
            style: TextStyle(
                color: AppStatus.shared.textGreyColor,
                fontWeight: FontWeight.w400,
                fontSize: 14),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    _selecedNetWork = 0;
                    presenter.blockchain = "BEP20";
                    presenter.updateAmount(_addressController.text);
                    // StreamCenter.shared.withdrawStreamController.add(0);
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: _selecedNetWork == 0
                            ? AppStatus.shared.bgBlueColor
                            : _theme == AppTheme.light
                                ? AppStatus.shared.bgGreyLightColor
                                : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'BEP20',
                          style: TextStyle(
                              color: _selecedNetWork == 0
                                  ? AppStatus.shared.bgWhiteColor
                                  : _theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'BNB Smart Chain',
                          style: TextStyle(
                              color: _selecedNetWork == 0
                                  ? ColorsUtil.hexColor(0xFFFFFF, alpha: 0.6)
                                  : _theme == AppTheme.light
                                      ? AppStatus.shared.textGreyColor
                                      : ColorsUtil.hexColor(0xFFFFFF,
                                          alpha: 0.6),
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _selecedNetWork = 1;
                    presenter.blockchain = "ERC20";
                    presenter.updateAmount(_addressController.text);
                    // StreamCenter.shared.withdrawStreamController.add(0);
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: _selecedNetWork == 1
                            ? AppStatus.shared.bgBlueColor
                            : _theme == AppTheme.light
                                ? AppStatus.shared.bgGreyLightColor
                                : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ERC20',
                          style: TextStyle(
                              color: _selecedNetWork == 1
                                  ? AppStatus.shared.bgWhiteColor
                                  : _theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Ethereum',
                          style: TextStyle(
                              color: _selecedNetWork == 1
                                  ? ColorsUtil.hexColor(0xFFFFFF, alpha: 0.6)
                                  : _theme == AppTheme.light
                                      ? AppStatus.shared.textGreyColor
                                      : ColorsUtil.hexColor(0xFFFFFF,
                                          alpha: 0.6),
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _selecedNetWork = 2;
                    presenter.blockchain = "TRC20";
                    presenter.updateAmount(_addressController.text);
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: _selecedNetWork == 2
                            ? AppStatus.shared.bgBlueColor
                            : _theme == AppTheme.light
                                ? AppStatus.shared.bgGreyLightColor
                                : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'TRC20',
                          style: TextStyle(
                              color: _selecedNetWork == 2
                                  ? AppStatus.shared.bgWhiteColor
                                  : _theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Tron',
                          style: TextStyle(
                              color: _selecedNetWork == 2
                                  ? ColorsUtil.hexColor(0xFFFFFF, alpha: 0.6)
                                  : _theme == AppTheme.light
                                      ? AppStatus.shared.textGreyColor
                                      : ColorsUtil.hexColor(0xFFFFFF,
                                          alpha: 0.6),
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                      ],
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

  //地址
  Widget _buildAddressView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 20),
      child: Container(
        height: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _theme == AppTheme.light
                ? AppStatus.shared.bgGreyLightColor
                : AppStatus.shared.bgDarkGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            textAlign: TextAlign.start,
            autocorrect: false,
            controller: _addressController,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
            inputFormatters: [
              CustomFormatter(),
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 10,
                right: 5,
                bottom: 0,
              ),
              border: InputBorder.none,
              hintText: presenter.withdrawType == 1
                  ? "Type or paste the UID or Email".tr():"Type or long press to paste the address".tr(),
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14),
              suffixIcon: Container(
                width: 100,
                child: presenter.withdrawType == 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Image.asset(_theme == AppTheme.light
                                ? A.assets_withdraw_safechain_black
                                : A.assets_withdraw_safechain1),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              showAccountSelectView(context);
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Image.asset(_theme == AppTheme.light
                                ? A.assets_withdraw_safechain_black
                                : A.assets_withdraw_safechain1),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              showQuickSelectView(context);
                            },
                          ),
                          IconButton(
                            icon: Image.asset(_theme == AppTheme.light
                                ? A.assets_withdraw_scan_black
                                : A.assets_wallet_scan),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => QrcodeScanView(
                                    (str) {
                                      //
                                      debugPrint(str);
                                      _addressController.text = str;
                                    },
                                    () {
                                      //
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ),
            ),
            onChanged: (text) {},
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  //金额
  Widget _buildAmountView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 20),
      child: Container(
        height: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _theme == AppTheme.light
                ? AppStatus.shared.bgGreyLightColor
                : AppStatus.shared.bgDarkGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            textAlign: TextAlign.start,
            autocorrect: false,
            controller: _amountController,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,' + '${2}' + '}')),
            ],
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 10,
                right: 5,
                bottom: 0,
              ),
              border: InputBorder.none,
              hintText: "Minimum withdraw amount".tr() +
                  " ${presenter.withdrawInfo.min} ${presenter.withdrawInfo.currency}",
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14),
              suffixIcon: TextButton(
                onPressed: () {
                  _amountController.text =
                      "${NumberPlus.removeZero(presenter.withdrawInfo.available)}";
                  presenter.updateAmount(_amountController.text);
                },
                child: Text(
                  "All".tr(),
                  style: TextStyle(
                      color: AppStatus.shared.bgBlueColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            onChanged: (text) {
              presenter.updateAmount(_amountController.text);
            },
            onTap: () {
              _scrollController.animateTo(120,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              String t = NumberPlus.inputNumber(
                  _amountController.text, presenter.withdrawInfo.currency);
              _amountController.text = t;
            },
          ),
        ),
      ),
    );
  }

  //note
  Widget _buildNoteInfoView(BuildContext context) {
    String note = presenter.withdrawInfo.notice;
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 32),
      child: Text(
        note,
        style: TextStyle(
            color: AppStatus.shared.textGreyColor,
            fontWeight: FontWeight.w400,
            fontSize: 12),
      ),
    );
  }

  //quick select
  showQuickSelectView(BuildContext context) async {
    List<WhiteListModel> dataList = await presenter.fetchWhiteList();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
            maxHeight: dataList.isNotEmpty ? 460 : 460,
            minWidth: double.infinity),
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
                  dataList.isNotEmpty
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 16, right: 16),
                          child: StreamBuilder<int>(
                              stream: quickController.stream,
                              builder: (context, snapshot) {
                                return Container(
                                  constraints:
                                      BoxConstraints(maxHeight: 100 * 3),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: dataList.length,
                                    itemBuilder: (context1, index) {
                                      WhiteListModel model = dataList[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: InkWell(
                                          onTap: () {
                                            if (selectChain == index) {
                                              selectChain = -1;
                                            } else {
                                              selectChain = index;
                                            }
                                            quickController.add(0);
                                          },
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: selectChain == index
                                                  ? AppStatus.shared.bgBlueColor
                                                  : _theme == AppTheme.light
                                                      ? AppStatus.shared
                                                          .bgGreyLightColor
                                                      : AppStatus.shared
                                                          .bgDarkGreyColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 16, top: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          model.alias +
                                                              ' ' +
                                                              model.agreement,
                                                          style: TextStyle(
                                                              color: _theme ==
                                                                      AppTheme
                                                                          .light
                                                                  ? selectChain ==
                                                                          index
                                                                      ? AppStatus
                                                                          .shared
                                                                          .bgWhiteColor
                                                                      : AppStatus
                                                                          .shared
                                                                          .bgBlackColor
                                                                  : AppStatus
                                                                      .shared
                                                                      .bgWhiteColor,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          model.address,
                                                          style: TextStyle(
                                                              color: _theme ==
                                                                      AppTheme
                                                                          .light
                                                                  ? selectChain ==
                                                                          index
                                                                      ? AppStatus
                                                                          .shared
                                                                          .bgWhiteColor
                                                                      : AppStatus
                                                                          .shared
                                                                          .bgBlackColor
                                                                  : AppStatus
                                                                      .shared
                                                                      .bgWhiteColor,
                                                              fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          presenter
                                                              .toEditSafeChainPage(
                                                                  context,
                                                                  model);
                                                        },
                                                        child: Image.asset(_theme ==
                                                                AppTheme.light
                                                            ? selectChain ==
                                                                    index
                                                                ? A.assets_chain_edit
                                                                : A.assets_TrashFill
                                                            : A.assets_chain_edit),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          presenter
                                                              .deleteSafeChain(
                                                                  context,
                                                                  model
                                                                      .whiteId);
                                                          Future.delayed(
                                                                  Duration(
                                                                      seconds:
                                                                          1))
                                                              .then(
                                                            (value) => {
                                                              Navigator.pop(
                                                                  context2)
                                                            },
                                                          );
                                                        },
                                                        child: Image.asset(_theme ==
                                                                AppTheme.light
                                                            ? selectChain ==
                                                                    index
                                                                ? A.assets_chain_delete
                                                                : A.assets_PencilSquare
                                                            : A.assets_chain_delete),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
                        )
                      : Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 16, right: 16),
                          child: Container(
                            child: Center(
                              child: Column(
                                children: [
                                  Image.asset(A.assets_ucard_nodata),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'No data'.tr(),
                                    style: TextStyle(
                                        color: AppStatus.shared.textGreyColor,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: InkWell(
                      onTap: () {
                        presenter.toAddSafeChainPage(context);
                      },
                      child: Container(
                        height: 44.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppStatus.shared.bgBlueColor),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Center(
                          child: Text(
                            'Add New Safe Chain'.tr(),
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //
                  dataList.isNotEmpty
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 16, right: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () {
                                      //取消
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 44,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: _theme == AppTheme.light
                                            ? AppStatus.shared.bgGreyLightColor
                                            : AppStatus.shared.bgDarkGreyColor,
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Cancel".tr(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: _theme == AppTheme.light
                                                  ? AppStatus
                                                      .shared.bgBlackColor
                                                  : AppStatus
                                                      .shared.bgWhiteColor,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: InkWell(
                                    onTap: () {
                                      if (selectChain == -1) {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return ShowMessage(
                                                  2, "Please select chain".tr(),
                                                  styleType: 1, width: 257);
                                            });
                                      } else {
                                        WhiteListModel m =
                                            dataList[selectChain];
                                        _addressController.text = m.address;
                                        if (m.agreement == "BEP20") {
                                          _selecedNetWork = 0;
                                        } else if (m.agreement == "ERC20") {
                                          _selecedNetWork = 1;
                                        } else {
                                          _selecedNetWork = 2;
                                        }
                                        StreamCenter
                                            .shared.withdrawStreamController
                                            .add(0);
                                        Navigator.pop(context2);
                                      }
                                    },
                                    child: Container(
                                      height: 44,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: AppStatus.shared.bgBlueColor,
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Confirm".tr(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 16, right: 16),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 44.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgGreyLightColor
                                    : AppStatus.shared.bgDarkGreyColor,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Center(
                                child: Text(
                                  'Cancel'.tr(),
                                  style: TextStyle(
                                      color: _theme == AppTheme.light
                                          ? AppStatus.shared.bgBlackColor
                                          : AppStatus.shared.bgWhiteColor,
                                      fontSize: 16),
                                ),
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

  //发给用户弹窗
  showAccountSelectView(BuildContext context) async {
    List<RecentReferModel> recentList = await presenter.fetchRecentList();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
            maxHeight: recentList.isNotEmpty ? 430 : 400,
            minWidth: double.infinity),
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
                      "Recent Transfers".tr(),
                      style: TextStyle(
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  recentList.isNotEmpty
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 16, right: 16),
                          child: StreamBuilder<int>(
                              stream: quickController.stream,
                              builder: (context, snapshot) {
                                return Container(
                                  constraints:
                                      BoxConstraints(maxHeight: 120 * 3),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: recentList.length,
                                    itemBuilder: (context1, index) {
                                      RecentReferModel model =
                                          recentList[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: InkWell(
                                          onTap: () {
                                            if (selectAccount == index) {
                                              selectAccount = -1;
                                            } else {
                                              selectAccount = index;
                                            }
                                            quickController.add(0);
                                          },
                                          child: Container(
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: selectAccount == index
                                                  ? AppStatus.shared.bgBlueColor
                                                  : _theme == AppTheme.light
                                                      ? AppStatus.shared
                                                          .bgGreyLightColor
                                                      : AppStatus.shared
                                                          .bgDarkGreyColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 16, top: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Ucard Uid.'.tr(),
                                                    style: TextStyle(
                                                        color: AppStatus.shared
                                                            .textGreyColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${model.to_uid}',
                                                    style: TextStyle(
                                                        color: _theme ==
                                                                AppTheme.light
                                                            ? selectAccount ==
                                                                    index
                                                                ? AppStatus
                                                                    .shared
                                                                    .bgWhiteColor
                                                                : AppStatus
                                                                    .shared
                                                                    .bgBlackColor
                                                            : AppStatus.shared
                                                                .bgWhiteColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    'Email.'.tr(),
                                                    style: TextStyle(
                                                        color: AppStatus.shared
                                                            .textGreyColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${model.to_user_name}',
                                                    style: TextStyle(
                                                        color: _theme ==
                                                                AppTheme.light
                                                            ? selectAccount ==
                                                                    index
                                                                ? AppStatus
                                                                    .shared
                                                                    .bgWhiteColor
                                                                : AppStatus
                                                                    .shared
                                                                    .bgBlackColor
                                                            : AppStatus.shared
                                                                .bgWhiteColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
                        )
                      : Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 16, right: 16),
                          child: Container(
                            child: Center(
                              child: Column(
                                children: [
                                  Image.asset(A.assets_ucard_nodata),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'No data'.tr(),
                                    style: TextStyle(
                                        color: AppStatus.shared.textGreyColor,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  //
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                //取消
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 44,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: _theme == AppTheme.light
                                      ? AppStatus.shared.bgGreyLightColor
                                      : AppStatus.shared.bgDarkGreyColor,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Center(
                                  child: Text(
                                    "Cancel".tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _theme == AppTheme.light
                                            ? AppStatus.shared.bgBlackColor
                                            : AppStatus.shared.bgWhiteColor,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: InkWell(
                              onTap: () {
                                if (selectAccount == -1) {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return ShowMessage(
                                            2, "Please select chain".tr(),
                                            styleType: 1, width: 257);
                                      });
                                } else {
                                  RecentReferModel m =
                                      recentList[selectAccount];
                                  _addressController.text = '${m.to_uid}';

                                  StreamCenter.shared.withdrawStreamController
                                      .add(0);
                                  Navigator.pop(context2);
                                }
                              },
                              child: Container(
                                height: 44,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: AppStatus.shared.bgBlueColor,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Center(
                                  child: Text(
                                    "Confirm".tr(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        }).whenComplete(() {});
  }

  //安全码
  showSafetyAuthView(BuildContext context) async {
    presenter.startSendCode();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 620, minWidth: double.infinity),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return StreamBuilder<int>(
                stream: safetyController.stream,
                builder: (context, snapshot) {
                  return Container(
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgWhiteColor
                            : ColorsUtil.hexColor(0x2E2E2E),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Account Authorisation".tr(),
                                style: TextStyle(
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : AppStatus.shared.bgWhiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            controller: _safeScroController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSafetyPinView(context),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildAccountsView(context),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildEmailVerifyView(context),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildeSendCodeView(context),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    String amount = _amountController.text;
                                    String account = _addressController.text;
                                    String code = _emailCode;
                                    String safePin = _safetyPinCode;
                                    if (safePin.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return ShowMessage(2,
                                                "Please enter Safety Pin".tr(),
                                                styleType: 1, width: 257);
                                          });
                                      return;
                                    } else if (code.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return ShowMessage(
                                                2,
                                                "Please enter verification code"
                                                    .tr(),
                                                styleType: 1,
                                                width: 257);
                                          });
                                      return;
                                    }
                                    if (presenter.withdrawType == 0) {
                                      presenter.withdrawButtonPressed(context, _addressController.text, code, safePin);
                                    }else{
                                      presenter.withdrawSubmitPressed(context,
                                          amount, account, code, safePin);
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AppStatus.shared.bgBlueColor,
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Submit".tr(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 200,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          });
        }).whenComplete(() {});
  }

  Widget _buildSafetyPinView(BuildContext context) {
    var itemSize = (MediaQuery.of(context).size.width - 112) / 6;
    const length = 6;
    var borderColor = AppStatus.shared.bgBlueColor;
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    var fillColor = _theme == AppTheme.light
        ? AppStatus.shared.bgGreyLightColor
        : AppStatus.shared.bgDarkGreyColor;
    final defaultPinTheme = PinTheme(
      width: itemSize,
      height: itemSize,
      margin: EdgeInsets.only(right: 8),
      textStyle: TextStyle(
        fontSize: 22,
        color: _theme == AppTheme.light
            ? AppStatus.shared.bgBlackColor
            : Colors.white,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Padding(
      padding: EdgeInsets.only(
        left: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Your Safety Pin".tr(),
            style:
                TextStyle(fontSize: 14, color: AppStatus.shared.textGreyColor),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: itemSize,
            child: Pinput(
              length: length,
              controller: _safetyPinCodeController,
              focusNode: _safetyPinfocusNode,
              defaultPinTheme: defaultPinTheme,
              onCompleted: (pin) {
                //
                _safetyPinCode = pin;
                safetyController.add(0);
              },
              onChanged: (pin) {
                _safetyPinCode = pin;
                safetyController.add(0);
              },
              focusedPinTheme: defaultPinTheme.copyWith(
                height: itemSize,
                width: itemSize,
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: borderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyWith(
                decoration: BoxDecoration(
                  color: errorColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //文本
  Widget _buildAccountsView(BuildContext context) {
    return Visibility(
      visible: isSent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "A verification code is sent to".tr(),
            style:
                TextStyle(fontSize: 14, color: AppStatus.shared.textGreyColor),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            NumberPlus.getSecurityEmail(UserInfo.shared.username),
            style: TextStyle(
                fontSize: 16,
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailVerifyView(BuildContext context) {
    var itemSize = (MediaQuery.of(context).size.width - 112) / 6;
    const length = 6;
    var borderColor = AppStatus.shared.bgBlueColor;
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    var fillColor = _theme == AppTheme.light
        ? AppStatus.shared.bgGreyLightColor
        : AppStatus.shared.bgDarkGreyColor;
    final defaultPinTheme = PinTheme(
      width: itemSize,
      height: itemSize,
      margin: EdgeInsets.only(right: 8),
      textStyle: TextStyle(
        fontSize: 22,
        color: _theme == AppTheme.light
            ? AppStatus.shared.bgBlackColor
            : Colors.white,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return SizedBox(
      height: itemSize,
      child: Pinput(
        length: length,
        controller: _emailCodeController,
        focusNode: _emailfocusNode,
        defaultPinTheme: defaultPinTheme,
        onCompleted: (pin) {
          //
          _emailCode = pin;
          safetyController.add(0);
        },
        onChanged: (pin) {
          _emailCode = pin;
          safetyController.add(0);
        },
        focusedPinTheme: defaultPinTheme.copyWith(
          height: itemSize,
          width: itemSize,
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: borderColor),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: errorColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onTap: () {
          _safeScroController.animateTo(120,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
      ),
    );
  }

  Widget _buildeSendCodeView(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 48,
        child: ValueListenableBuilder<bool>(
          builder: (BuildContext context, bool value, Widget? child) {
            return SendCodeButton(1, true, true, Colors.transparent, () {
              isSent = true;
              safetyController.add(0);
              sendCodePressed(UserInfo.shared.username);
              FocusScope.of(context).unfocus();
            });
          },
          valueListenable: _sendCodeSuccess,
        ));
  }

  Future<bool> sendCodePressed(String address) async {
    return await presenter.sendCodePressed(address);
  }

  //提醒设置安全码
  showAlertDialog(BuildContext context, String title, String content) {
    String buttonTitle = "OK".tr();
    showDialog(
      context: context,
      builder: (_) {
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: Container(
            // height: height,
            width: MediaQuery.of(context).size.width - 88,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : ColorsUtil.hexColor(0x252525),
                ),
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      content.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        presenter.toSafetyPinPage(context);
                      },
                      child: Container(
                        height: 44,
                        width: MediaQuery.of(context).size.width - 88 - 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: AppStatus.shared.bgBlueColor,
                        ),
                        child: Center(
                          child: Text(
                            buttonTitle,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}

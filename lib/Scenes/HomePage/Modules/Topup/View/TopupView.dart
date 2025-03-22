import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucardtemp/Common/NumberPlus.dart';

import '../../../../../Common/ColorUtil.dart';
import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/UserInfo.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
import '../../Apply/Entity/CardInfoModel.dart';
import '../Presenter/TopupPresenter.dart';

class TopupView extends StatelessWidget {
  final TopupPresenter presenter;

  StreamController<int> streamController = StreamController.broadcast();
  StreamController<int> topupStreamController = StreamController.broadcast();

  ScrollController _scrollController = ScrollController();
  final TextEditingController _amoutController =
      TextEditingController(text: '');

  TopupView(this.presenter);

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor, //修改颜色
          ),
          elevation: 0,
          title: Text(
            "Top-up".tr(),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
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
          child: StreamBuilder<int>(
            stream: streamController.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container(
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgWhiteColor
                    : AppStatus.shared.bgBlackColor,
                height: MediaQuery.of(context).size.height,
                child: SafeArea(
                    child: Stack(
                  children: [
                    _buildCardInfoView(context),
                    Positioned(
                      child: _buildSubmitButton(context),
                      bottom: 50,
                      height: 44,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ],
                )),
              );
            },
          ),
        ),
      );
    });
  }

  //info
  Widget _buildCardInfoView(BuildContext context) {
    String cardNostr = presenter.cardModel.card_no;
    if (cardNostr.isNotEmpty) {
      if (cardNostr.length > 4) {
        cardNostr = cardNostr.substring(0, 4) +
            "****" +
            cardNostr.substring(cardNostr.length - 4, cardNostr.length);
      }
    }
    String cardBg = "";
    if (presenter.cardModel.level == 1) {
      cardBg = A.assets_topup_first_bg;
    } else if (presenter.cardModel.level == 2) {
      cardBg = A.assets_topup_second_bg;
    } else if (presenter.cardModel.level == 3) {
      cardBg = A.assets_topup_third_bg;
    } else if (presenter.cardModel.level == 4) {
      cardBg = A.assets_topup_forth_bg;
    }
    double amount = 0.0;
    double hkdAmount = 0.0;
    if (_amoutController.text.isEmpty) {
      amount = 1;
      hkdAmount = presenter.rate_usdt_hkd;
    } else {
      amount = double.parse(_amoutController.text);
      if (presenter.cardModel.currency == "USD" ||
          presenter.cardModel.currency == "USDC") {
        hkdAmount = amount;
      } else {
        hkdAmount =
            double.parse((amount * presenter.rate_usdt_hkd).toStringAsFixed(2));
      }
    }

    return Column(
      // shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 28),
          child: Container(
            height: 74,
            width: 74,
            decoration: BoxDecoration(
                color: AppStatus.shared.bgDarkGreyColor,
                borderRadius: BorderRadius.circular(37)),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(cardBg),
                  Image.asset(A.assets_topup_card_icon),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            cardNostr,
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            "${presenter.cardModel.card_type == "visa" ? "Visa" : presenter.cardModel.card_type == "master" ? "Mastercard" : "UnionPay"}",
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: Container(
            height: presenter.cardModel.service == 2 ? 200 : 128,
            decoration: BoxDecoration(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgGreyLightColor
                    : AppStatus.shared.bgDarkGreyColor,
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                _buildInputView(context),
                Center(
                  child: InkWell(
                    onTap: () {
                      _amoutController.text =
                          presenter.walletModel?.balance ?? "0.0";
                      streamController.add(0);
                    },
                    child: Container(
                      child: Text(
                        'Max'.tr(),
                        style: TextStyle(
                            color: AppStatus.shared.bgBlueColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: presenter.cardModel.service == 2,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "$amount ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : "USDT"} ≈ ${hkdAmount} ${presenter.cardModel.currency}",
                      style: TextStyle(
                          color: AppStatus.shared.textGreyColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Visibility(
                  visible: presenter.cardModel.service == 2,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Top-up fee: ${presenter.cardInfoModel?.recharge_fee}${presenter.cardInfoModel?.recharge_fee_unit} ${presenter.cardModel.currency}",
                      style: TextStyle(
                          color: AppStatus.shared.textGreyColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Minimum top up amount is".tr() +
                        " 15 ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : "USDT"}",
                    style: TextStyle(
                        color: AppStatus.shared.textGreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildDepositView(context),
        _buildNoteInfo(context),
      ],
    );
  }

  //输入金钱
  Widget _buildInputView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              textAlign: TextAlign.right,
              autocorrect: false,
              controller: _amoutController,
              textAlignVertical: TextAlignVertical.center,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,' + '${2}' + '}')),
              ],
              style: TextStyle(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "0.00",
                  hintStyle: TextStyle(
                      color: AppStatus.shared.textGreyColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w500)),
              onChanged: (text) {},
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                streamController.add(0);
              },
              onTap: () {},
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              (UserInfo.shared.email == AppStatus.shared.specialAccount)
                  ? "USD"
                  : "USDT",
              style: TextStyle(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }

  //deposit
  Widget _buildDepositView(BuildContext context) {
    String amout =
        "${presenter.walletModel?.balance ?? "0.0"} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : presenter.walletModel?.currency ?? "USDT"}";
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 32),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
            color: _theme == AppTheme.light
                ? AppStatus.shared.bgGreyLightColor
                : AppStatus.shared.bgDarkGreyColor,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount available'.tr(),
                    style: TextStyle(
                        color: AppStatus.shared.textGreyColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    amout,
                    style: TextStyle(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            Visibility(
              visible:
                  (UserInfo.shared.email != AppStatus.shared.specialAccount),
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                    presenter.depositPagePressed(context);
                  },
                  child: Container(
                    width: 84,
                    height: 36,
                    decoration: BoxDecoration(
                        color: AppStatus.shared.bgBlueColor,
                        borderRadius: BorderRadius.circular(18)),
                    child: Center(
                      child: Text(
                        'Deposit'.tr(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 20),
      child: Text(
        'Topup note'.tr(),
        style: TextStyle(color: AppStatus.shared.textGreyColor, fontSize: 12),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: InkWell(
        onTap: () {
          //
          FocusScope.of(context).unfocus();
          //充值金额
          double amout = double.parse(
              _amoutController.text.isEmpty ? "0.0" : _amoutController.text);
          //不得小于15
          if (amout < 15.0) {
            showDialog(
                context: context,
                builder: (_) {
                  return ShowMessage(
                      2,
                      "Minimum top up amount is".tr() +
                          " 15 ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : "USDT"}",
                      styleType: 1,
                      width: 257);
                });
            return;
          }
          //不得高于钱包余额
          double totalAmount =
              double.parse(presenter.walletModel?.balance ?? "0.0");
          if (amout > totalAmount) {
            showDialog(
                context: context,
                builder: (_) {
                  return ShowMessage(
                      2, "The quantity exceeds the account balance".tr(),
                      styleType: 1, width: 257);
                });
            return;
          }

          showTopupConfirmationDiolog(context);
        },
        child: Container(
          height: 44,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppStatus.shared.bgBlueColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              "Top up".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  //申请弹窗
  showTopupConfirmationDiolog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 308),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context2, StateSetter mystate) {
            return Container(
              decoration: BoxDecoration(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : ColorsUtil.hexColor(0x2E2E2E),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: _buildContent(context),
            );
          });
        }).whenComplete(() {});
  }

  Widget _buildContent(BuildContext context) {
    //卡信息
    String cardNostr = presenter.cardModel.card_no;
    if (cardNostr.isNotEmpty) {
      if (cardNostr.length > 4) {
        cardNostr = cardNostr.substring(0, 4) +
            "****" +
            cardNostr.substring(cardNostr.length - 4, cardNostr.length);
      }
    }
    String cardType = presenter.cardModel.card_type == "master"
        ? "Mastercard"
        : presenter.cardModel.card_type == "visa"
            ? "Visa"
            : "UnionPay";
    if (presenter.cardModel.card_no.isNotEmpty) {
      cardNostr = "$cardNostr ($cardType)";
    } else {
      cardNostr = cardType;
    }
    //充值金额
    double amout = double.parse(
        _amoutController.text.isEmpty ? "0.0" : _amoutController.text);

    //充值费用
    double rfee = double.parse(presenter.cardInfoModel?.recharge_fee ?? "0.0") /
        100.0 *
        amout;
    String rechargeFee = NumberPlus.displayPrice(rfee, "");
    //收到金额
    double receivedAmt = amout - rfee;
    return StreamBuilder<int>(
        stream: topupStreamController.stream,
        builder: (context, snapshot) {
          return Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Irrevocable after top up'.tr(),
                    style: TextStyle(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            cardNostr,
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Top-up'.tr(),
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Text(
                            '${_amoutController.text} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : "USDT"}',
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Fee1'.tr(),
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Text(
                            '-${rechargeFee} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : "USDT"}',
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Received'.tr(),
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          Spacer(),
                          Text(
                            '${receivedAmt} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : "USDT"}',
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 10, top: 30),
                        child: InkWell(
                          onTap: () {
                            //取消
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 44,
                            width: 100,
                            decoration: BoxDecoration(
                              color: (presenter.topuping)
                                  ? _theme == AppTheme.light
                                      ? AppStatus.shared.bgGreyLightColor
                                      : ColorsUtil.hexColor(0x1a1a1a)
                                  : _theme == AppTheme.light
                                      ? AppStatus.shared.bgGreyLightColor
                                      : AppStatus.shared.bgDarkGreyColor,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Center(
                              child: Text(
                                "Cancel".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: (presenter.topuping)
                                        ? AppStatus.shared.textGreyColor
                                        : _theme == AppTheme.light
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
                        padding:
                            const EdgeInsets.only(left: 10, right: 20, top: 30),
                        child: InkWell(
                          onTap: () {
                            if (presenter.topuping) {
                              return;
                            }
                            presenter.topuping = true;
                            topupStreamController.add(0);
                            //
                            String money = _amoutController.text;
                            presenter.topupSuccessPressed(context, money,
                                '${receivedAmt} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : "USDT"}');
                            // Navigator.pop(context);
                          },
                          child: Container(
                            height: 44,
                            width: 100,
                            decoration: BoxDecoration(
                              color: (presenter.topuping)
                                  ? ColorsUtil.hexColor(0x1241a5)
                                  : AppStatus.shared.bgBlueColor,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Center(
                              child: Text(
                                "Confirm".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: (presenter.topuping)
                                        ? ColorsUtil.hexColor(0x88a0d2)
                                        : Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}

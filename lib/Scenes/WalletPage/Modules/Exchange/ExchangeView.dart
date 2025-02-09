import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucardtemp/Common/NumberPlus.dart';
import 'package:ucardtemp/Model/WalletModel.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';
import 'ExchangePresenter.dart';

class ExchangeView extends StatelessWidget {
  final ExchangePresenter presenter;

  ExchangeView(this.presenter);
  StreamController<int> controller = StreamController.broadcast();

  final TextEditingController _amount1Controller =
      TextEditingController(text: '');
  final TextEditingController _amount2Controller =
      TextEditingController(text: '');

  String _amount1Str = '';
  String _amount2Str = '';

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
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
            'Exchange'.tr(),
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
        body: StreamBuilder<int>(
          stream: controller.stream,
          builder: (context, snapshot) {
            return Container(
              color: theme == AppTheme.light
                  ? AppStatus.shared.bgWhiteColor
                  : AppStatus.shared.bgBlackColor,
              child: SafeArea(
                child: Column(
                  children: [
                    _buildFirstView(context),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () {
                          presenter.isUsdcToUsdt = !presenter.isUsdcToUsdt;
                          _amount1Controller.text = '';
                          _amount2Controller.text = '';
                          controller.add(0);
                        },
                        child: Image.asset(
                          theme == AppTheme.light
                              ? A.assets_ArrowDownUp
                              : A.assets_exchange_arrow,
                          width: 31,
                          height: 31,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    _buildSecondView(context),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Rate：".tr()+"1 USDT ≈ ${1 * presenter.rate_usdt_usdc} USDC",
                        style: TextStyle(
                            color: AppStatus.shared.textGreyColor,
                            fontSize: 18),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (presenter.isUsdcToUsdt) {
                          presenter.exchangePressed(
                              context, "USDC", "USDT", _amount1Str);
                        } else {
                          presenter.exchangePressed(
                              context, "USDT", "USDC", _amount1Str);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppStatus.shared.bgBlueColor,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          height: 44,
                          child: Center(
                            child: Text(
                              "Exchange".tr(),
                              style: TextStyle(
                                  color: AppStatus.shared.bgWhiteColor,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildFirstView(BuildContext context) {
    WalletModel m = presenter.usdcModel;
    if (!presenter.isUsdcToUsdt) {
      m = presenter.usdtModel;
    }
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 30,
      ),
      child: Container(
        width: double.infinity,
        height: 126,
        decoration: BoxDecoration(
          color: _theme == AppTheme.light
              ? AppStatus.shared.bgGreyLightColor
              : AppStatus.shared.bgGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 16, top: 16),
                  child: Text(
                    "Available Balance：".tr() + "${m.balance + m.currency}",
                    style: TextStyle(
                        color: AppStatus.shared.textGreyColor, fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Image.asset(
                        presenter.isUsdcToUsdt
                            ? A.assets_exchange_usdc1
                            : A.assets_wallet_usdt_icon,
                        width: 24,
                        height: 24,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        presenter.isUsdcToUsdt ? 'USDC' : "USDT",
                        style: TextStyle(
                            color: _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Image.asset(
                        _theme == AppTheme.light
                            ? A.assets_PlayFill
                            : A.assets_exchange_up,
                        width: 8,
                        height: 6,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 16),
                    child: Container(
                      height: 30,
                      child: TextFormField(
                        textAlign: TextAlign.right,
                        autocorrect: false,
                        controller: _amount1Controller,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,' + '${5}' + '}')),
                        ],
                        style: TextStyle(
                            color: _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            bottom: 10,
                          ),
                          border: InputBorder.none,
                          hintText: "0.01-500,000",
                          hintStyle: TextStyle(
                              color: AppStatus.shared.textGreyColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (text) {
                          _amount1Str = text;
                          double amount1 = double.parse(_amount1Str);
                          if (presenter.isUsdcToUsdt) {
                            double changeAmount =
                                amount1 / presenter.rate_usdt_usdc;
                            _amount2Controller.text =
                                NumberPlus.displayNumber(changeAmount, 'USDT');
                          } else {
                            double changeAmount =
                                amount1 * presenter.rate_usdt_usdc;
                            _amount2Controller.text =
                                NumberPlus.displayNumber(changeAmount, 'USDC');
                          }
                        },
                        onTap: () {},
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 10,
              ),
              child: Row(
                children: [
                  Spacer(),
                  Container(
                    width: 60,
                    child: TextButton(
                      onPressed: () {
                        if (presenter.isUsdcToUsdt) {
                          _amount1Controller.text = presenter.usdcModel.balance;
                        } else {
                          _amount1Controller.text = presenter.usdtModel.balance;
                        }
                        controller.add(0);
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSecondView(BuildContext context) {
    WalletModel m = presenter.usdtModel;
    if (presenter.isUsdcToUsdt) {
      m = presenter.usdcModel;
    }
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
      ),
      child: Container(
        width: double.infinity,
        height: 106,
        decoration: BoxDecoration(
          color: _theme == AppTheme.light
              ? AppStatus.shared.bgGreyLightColor
              : AppStatus.shared.bgGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 36,
            ),
            Row(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Image.asset(
                        presenter.isUsdcToUsdt
                            ? A.assets_wallet_usdt_icon
                            : A.assets_exchange_usdc1,
                        width: 24,
                        height: 24,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        presenter.isUsdcToUsdt ? 'USDT' : 'USDC',
                        style: TextStyle(
                            color: _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Image.asset(
                        _theme == AppTheme.light
                            ? A.assets_PlayFill
                            : A.assets_exchange_up,
                        width: 8,
                        height: 6,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 16),
                    child: Container(
                      height: 30,
                      child: TextFormField(
                        textAlign: TextAlign.right,
                        autocorrect: false,
                        controller: _amount2Controller,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,' + '${5}' + '}')),
                        ],
                        style: TextStyle(
                            color: _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            bottom: 10,
                          ),
                          border: InputBorder.none,
                          hintText: "0.00001-500,000",
                          hintStyle: TextStyle(
                              color: AppStatus.shared.textGreyColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (text) {},
                        onTap: () {},
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

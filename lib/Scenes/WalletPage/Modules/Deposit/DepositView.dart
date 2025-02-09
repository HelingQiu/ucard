import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ucardtemp/Scenes/WalletPage/Modules/Deposit/QrcodeView.dart';
import '../../../../Common/ShowMessage.dart';
import '../../../../Common/StreamCenter.dart';
import '../../../../Data/AppStatus.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';
import '../../Entity/AddressModel.dart';
import 'DepositPresenter.dart';

class DepositView extends StatelessWidget {
  final DepositPresenter presenter;

  DepositView(this.presenter);

  bool isGenerated = false;
  bool showAddressQRView = false;

  int _selecedNetWork = 0;

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return StreamBuilder<int>(
          stream: StreamCenter.shared.depositStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.data == 1) {
              showAddressQRView = false;
            }
            if (presenter.addModel != null) {
              if (presenter.addModel!.address.isNotEmpty) {
                isGenerated = true;
              }
            }
            return showAddressQRView
                ? QrcodeView(presenter.addModel ?? AddressModel("", "", "", ""))
                : Scaffold(
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
                        'Deposit'.tr(),
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
                    body: Container(
                      color: theme == AppTheme.light
                          ? AppStatus.shared.bgWhiteColor
                          : AppStatus.shared.bgBlackColor,
                      child: SafeArea(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            _buildTopInfo(context),
                            _buildNetworkView(context),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, right: 16, top: 20),
                              child: Text(
                                'Warning: The deposit addresses of BEP20 and ERC20 networks are different'
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
                                'Deposit address'.tr(),
                                style: TextStyle(
                                  color: AppStatus.shared.textGreyColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            //
                            _buildGenerateView(context),
                            _buildQrcodeView(context),
                            _buildNoteInfoView(context),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          });
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
                    if (_selecedNetWork != 0) {
                      isGenerated = false;
                    }
                    _selecedNetWork = 0;
                    presenter.fetchDepositAddress(
                        presenter.currency, "BEP20", 0);
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
                    if (_selecedNetWork != 1) {
                      isGenerated = false;
                    }
                    _selecedNetWork = 1;
                    presenter.fetchDepositAddress(
                        presenter.currency, "ERC20", 0);
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
                    if (_selecedNetWork != 2) {
                      isGenerated = false;
                    }
                    _selecedNetWork = 2;
                    presenter.fetchDepositAddress(
                        presenter.currency, "TRC20", 0);
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

  //generate
  Widget _buildGenerateView(BuildContext context) {
    return Visibility(
      visible: !isGenerated,
      child: Padding(
        padding: EdgeInsets.only(top: 32),
        child: Column(
          children: [
            Image.asset(A.assets_wallet_deposit_generate),
            SizedBox(
              height: 32,
            ),
            InkWell(
              onTap: () {
                isGenerated = true;
                presenter.fetchDepositAddress(
                    presenter.currency,
                    _selecedNetWork == 0
                        ? "BEP20"
                        : _selecedNetWork == 1
                            ? "ERC20"
                            : 'TRC20',
                    1);
              },
              child: Container(
                width: 223,
                height: 36,
                decoration: BoxDecoration(
                    color: AppStatus.shared.bgBlueColor,
                    borderRadius: BorderRadius.circular(18)),
                child: Center(
                  child: Text(
                    'Click to generate address'.tr(),
                    style: TextStyle(
                        color: ColorsUtil.hexColor(0xFFFFFF, alpha: 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //qrcode
  Widget _buildQrcodeView(BuildContext context) {
    return Visibility(
      visible: isGenerated,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 20),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 32,
              height: 72,
              decoration: BoxDecoration(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgGreyLightColor
                      : AppStatus.shared.bgDarkGreyColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  presenter.addModel?.address ?? "",
                  style: TextStyle(
                      color: _theme == AppTheme.light
                          ? AppStatus.shared.bgBlackColor
                          : AppStatus.shared.bgWhiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Clipboard.setData(
                        ClipboardData(text: presenter.addModel?.address ?? ""))
                    .then((_) {
                  //
                  showAlertController(context);
                });
              },
              child: Container(
                width: 80,
                height: 36,
                decoration: BoxDecoration(
                    color: AppStatus.shared.bgBlueColor,
                    borderRadius: BorderRadius.circular(18)),
                child: Center(
                  child: Text(
                    'Copy'.tr(),
                    style: TextStyle(
                        color: ColorsUtil.hexColor(0xFFFFFF, alpha: 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            InkWell(
              onTap: () {
                showAddressQRView = true;
                StreamCenter.shared.depositStreamController.add(0);
              },
              child: Container(
                width: 164,
                height: 164,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: QrImageView(
                    data: presenter.addModel?.address ?? "",
                    size: 156,
                    version: 3,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Press to save'.tr(),
              style: TextStyle(
                  color: AppStatus.shared.textGreyColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  //note
  Widget _buildNoteInfoView(BuildContext context) {
    String note = presenter.addModel?.notice ?? "";
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 32),
      child: Text(
        note.tr(),
        style: TextStyle(
            color: AppStatus.shared.textGreyColor,
            fontWeight: FontWeight.w400,
            fontSize: 12),
      ),
    );
  }

  showAlertController(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) {
          return ShowMessage(1, "Copy to Clipboard".tr(),
              styleType: 1, width: 257, dismissSeconds: 2);
        });
  }
}

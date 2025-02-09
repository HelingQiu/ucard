import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../../Common/ColorUtil.dart';
import '../../../../../Common/CustomWidget.dart';
import '../../../../../Common/NumberPlus.dart';
import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/UserInfo.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
import '../../../../HomePage/Modules/Apply/Modules/ApplyUserInfo/CustomFormatter.dart';
import '../../../../WalletPage/Modules/Withdraw/QrcodeScanView.dart';
import 'SafeChainAddPresenter.dart';

class SafeChainAddView extends StatelessWidget {
  final SafeChainAddPresenter presenter;

  SafeChainAddView(this.presenter);

  StreamController<int> controller = StreamController.broadcast();

  ScrollController _scrollController = ScrollController();
  int _selecedNetWork = 0;

  final TextEditingController _addressController =
      TextEditingController(text: '');
  final TextEditingController _chainNameController =
      TextEditingController(text: '');

  final ValueNotifier<bool> _sendCodeSuccess = ValueNotifier<bool>(false);
  bool isSent = false;

  final TextEditingController _emailCodeController =
      TextEditingController(text: '');
  final _emailfocusNode = FocusNode();
  String _emailCode = "";

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
            'Safe Chain'.tr(),
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
            return GestureDetector(
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
                          _buildNetworkView(context),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 32),
                            child: Text(
                              'Chain Name'.tr(),
                              style: TextStyle(
                                color: AppStatus.shared.textGreyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          _buildChainNameView(context),
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
                          _buildAddressView(context),
                          SizedBox(
                            height: 20,
                          ),
                          _buildAccountsView(context),
                          SizedBox(
                            height: 20,
                          ),
                          _buildEmailVerifyView(context),
                          SizedBox(
                            height: 20,
                          ),
                          _buildeSendCodeView(context),
                          SizedBox(
                            height: 350,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 120,
                      child: Container(
                        color: theme == AppTheme.light
                            ? AppStatus.shared.bgWhiteColor
                            : ColorsUtil.hexColor(0x2e2e2e),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 10, top: 0),
                                child: InkWell(
                                  onTap: () {
                                    //取消
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 44,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: theme == AppTheme.light
                                          ? AppStatus.shared.bgGreyLightColor
                                          : AppStatus.shared.bgDarkGreyColor,
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Cancel".tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: theme == AppTheme.light
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
                                padding: const EdgeInsets.only(
                                    left: 10, right: 20, top: 0),
                                child: InkWell(
                                  onTap: () {
                                    //添加
                                    var agreement = presenter.blockchain;
                                    var alias = _chainNameController.text;
                                    var address = _addressController.text;
                                    var code = _emailCode;
                                    if (address.isEmpty) {
                                      showTopError(
                                          context,
                                          "Please enter Destination address"
                                              .tr());
                                      return;
                                    }
                                    if (code.isEmpty) {
                                      showTopError(
                                          context,
                                          "Please enter verification code"
                                              .tr());
                                      return;
                                    }
                                    presenter.addWhiteListPressed(context,
                                        agreement, address, alias, code);
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
                            )
                          ],
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

  Widget _buildTopInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 20),
      child: Text(
        'Add Safe Chain'.tr(),
        style: TextStyle(
            color: _theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor,
            fontWeight: FontWeight.w500,
            fontSize: 16),
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
                    controller.add(0);
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
                              color: ColorsUtil.hexColor(
                                  _selecedNetWork == 0
                                      ? 0xFFFFFF
                                      : _theme == AppTheme.light
                                          ? 0x000000
                                          : 0xFFFFFF,
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
                    controller.add(0);
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
                              color: ColorsUtil.hexColor(
                                  _selecedNetWork == 1
                                      ? 0xFFFFFF
                                      : _theme == AppTheme.light
                                          ? 0x000000
                                          : 0xFFFFFF,
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
                    controller.add(0);
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
                              color: ColorsUtil.hexColor(
                                  _selecedNetWork == 2
                                      ? 0xFFFFFF
                                      : _theme == AppTheme.light
                                          ? 0x000000
                                          : 0xFFFFFF,
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

  //链名
  Widget _buildChainNameView(BuildContext context) {
    if (presenter.initModel != null) {
      _chainNameController.text = presenter.initModel!.alias;
    }
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
            controller: _chainNameController,
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
                bottom: 15,
              ),
              border: InputBorder.none,
              hintText: "Type or long press to paste the name".tr(),
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14),

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

  //地址
  Widget _buildAddressView(BuildContext context) {
    if (presenter.initModel != null) {
      _addressController.text = presenter.initModel!.address;
    }
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
              hintText: "Type or long press to paste the address".tr(),
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14),
              suffixIcon: IconButton(
                icon: Image.asset(_theme == AppTheme.light
                    ? A.assets_scan_black
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

  //文本
  Widget _buildAccountsView(BuildContext context) {
    return Visibility(
      visible: isSent,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "A verification code is sent to".tr(),
              style: TextStyle(
                  fontSize: 16, color: AppStatus.shared.textGreyColor),
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
                      : AppStatus.shared.bgWhiteColor),
            ),
          ],
        ),
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
            : AppStatus.shared.bgWhiteColor,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Padding(
      padding: EdgeInsets.only(
        left: 8,
      ),
      child: SizedBox(
        height: itemSize,
        child: Pinput(
          length: length,
          controller: _emailCodeController,
          focusNode: _emailfocusNode,
          defaultPinTheme: defaultPinTheme,
          onCompleted: (pin) {
            //
            _emailCode = pin;
            controller.add(0);
          },
          onChanged: (pin) {
            _emailCode = pin;
            controller.add(0);
          },
          onTap: () {
            _scrollController.animateTo(220,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
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
              controller.add(0);
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

  showTopError(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) {
          return ShowMessage(2, message, styleType: 1, width: 257);
        });
  }
}

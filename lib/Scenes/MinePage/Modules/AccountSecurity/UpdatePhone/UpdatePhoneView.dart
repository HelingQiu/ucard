import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../../Common/CustomWidget.dart';
import '../../../../../Common/NumberPlus.dart';
import '../../../../../Common/ShowMessage.dart';
import '../../../../../Common/StreamCenter.dart';
import '../../../../../Common/TextImageButton.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/UserInfo.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
import 'UpdatePhonePresenter.dart';

class UpdatePhoneView extends StatelessWidget {
  final UpdatePhonePresenter presenter;

  //email
  bool isSent = false;
  //
  bool isSent1 = false;

  final ValueNotifier<bool> _sendCodeSuccess = ValueNotifier<bool>(true);

  StreamController<int> streamController = StreamController.broadcast();
  ScrollController _scrollController = ScrollController();

  final TextEditingController _oldPhoneCodeController =
      TextEditingController(text: '');
  final TextEditingController _phoneController =
      TextEditingController(text: '');
  final TextEditingController _phoneCodeController =
      TextEditingController(text: '');

  final _oldFocusNode = FocusNode();
  final _newFocusNode = FocusNode();

  String _oldCode = "";
  String _newCode = "";

  UpdatePhoneView(this.presenter);
  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: theme == AppTheme.light
            ? AppStatus.shared.bgWhiteColor
            : AppStatus.shared.bgBlackColor,
        appBar: AppBar(
          title: Text(
            "Update phone number".tr(),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
          elevation: 0,
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
        ),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 30,
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
                            height: 32,
                          ),
                          _buildPhoneInputView(context),
                          _buildPhoneInfoView(context),
                          _buildPhoneVerifyView(context),
                          SizedBox(
                            height: 20,
                          ),
                          _buildePhoneSendCodeView(context),
                          SizedBox(
                            height: 320,
                          ),
                        ],
                      ),
                    ),
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
              "+" + NumberPlus.getSecurityEmail(UserInfo.shared.phone),
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
          controller: _oldPhoneCodeController,
          focusNode: _oldFocusNode,
          defaultPinTheme: defaultPinTheme,
          onCompleted: (pin) {
            //
            _oldCode = pin;
            streamController.add(0);
          },
          onChanged: (pin) {
            _oldCode = pin;
            streamController.add(0);
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
              streamController.add(0);
              sendCodePressed(context, UserInfo.shared.phone);
              FocusScope.of(context).unfocus();
            });
          },
          valueListenable: _sendCodeSuccess,
        ));
  }

  Widget _buildPhoneInputView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              presenter.areaCodeButtonPressed(context);
            },
            child: Container(
              height: 48,
              width: 92,
              decoration: BoxDecoration(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgGreyLightColor
                    : AppStatus.shared.bgGreyColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: TextImageButton(
                  margin: 2,
                  type: TextIconButtonType.imageRight,
                  icon: Image.asset(_theme == AppTheme.light
                      ? A.assets_Polygon_1
                      : A.assets_home_bill_arrow),
                  text: Text(
                    // "+852".tr(),
                    UserInfo.shared.areaCode == null
                        ? "".tr()
                        : "+${UserInfo.shared.areaCode!.interarea}",
                    style: TextStyle(
                        fontSize: 16,
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor),
                  ),
                  onTap: () {
                    presenter.areaCodeButtonPressed(context);
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgGreyLightColor
                    : AppStatus.shared.bgGreyColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                textAlign: TextAlign.start,
                autocorrect: false,
                controller: _phoneController,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgBlackColor
                        : AppStatus.shared.bgWhiteColor),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    border: InputBorder.none,
                    hintText: "Phone Number".tr(),
                    hintStyle: TextStyle(
                        color: AppStatus.shared.textGreyColor, fontSize: 14)),
                onChanged: (text) {},
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
                onTap: () {
                  _scrollController.animateTo(120,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                // onFieldSubmitted: (_){
                //   FocusScope.of(context).unfocus();
                // },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInfoView(BuildContext context) {
    return Visibility(
      visible: isSent1,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
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
              "+${UserInfo.shared.areaCode?.interarea ?? ""} ${_phoneController.text}",
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

  Widget _buildPhoneVerifyView(BuildContext context) {
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
      padding: EdgeInsets.only(left: 8, top: 20),
      child: SizedBox(
        height: itemSize,
        child: Pinput(
          length: length,
          controller: _phoneCodeController,
          focusNode: _newFocusNode,
          defaultPinTheme: defaultPinTheme,
          onCompleted: (pin) {
            //
            _newCode = pin;
            streamController.add(0);
          },
          onChanged: (pin) {
            _newCode = pin;
            streamController.add(0);
          },
          onTap: () {
            _scrollController.animateTo(120,
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

  Widget _buildePhoneSendCodeView(BuildContext context) {
    String phoneStr = "";
    return Container(
        width: double.infinity,
        height: 48,
        child: ValueListenableBuilder<bool>(
          builder: (BuildContext context, bool value, Widget? child) {
            return SendCodeButton(
              1,
              false,
              true,
              Colors.transparent,
              () {
                UserInfo.shared.areaCode != null
                    ? phoneStr =
                        "${UserInfo.shared.areaCode!.interarea} ${_phoneController.text}"
                    : phoneStr = "";
                if (_phoneController.text.isNotEmpty) {
                  sendCodePressed(context, phoneStr);
                  isSent1 = true;
                  streamController.add(0);
                  FocusScope.of(context).unfocus();
                }
              },
              sendCodeSuccess: _phoneController.text.isNotEmpty,
            );
          },
          valueListenable: _sendCodeSuccess,
        ));
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: InkWell(
        onTap: () {
          submitButtonPressed(context);
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
              "Submit".tr(),
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

  Future<bool> sendCodePressed(BuildContext context, String address) async {
    return await presenter.sendCodePressed(address);
  }

  //提交
  submitButtonPressed(BuildContext context) async {
    String oldPhoneCode = _oldPhoneCodeController.text;
    String newPhoneNum = _phoneController.text;
    String newPhoneCode = _phoneCodeController.text;
    if (oldPhoneCode.isEmpty) {
      showTopError(context, "Please enter verification code".tr());
      return;
    }
    if (newPhoneNum.isEmpty) {
      showTopError(context, "Please enter phone number".tr());
      return;
    }
    if (newPhoneCode.isEmpty) {
      showTopError(context, "Please enter verification code".tr());
      return;
    }
    if (UserInfo.shared.areaCode == null) {
      showTopError(context, "Please select area code".tr());
      return;
    }

    String phoneStr = "";
    UserInfo.shared.areaCode != null
        ? phoneStr = "${UserInfo.shared.areaCode!.interarea} ${newPhoneNum}"
        : phoneStr = "";
    List list = [
      {
        "account": phoneStr,
        "type": 2,
        "code": newPhoneCode,
      },
      {
        "account": UserInfo.shared.phone,
        "type": 2,
        "code": oldPhoneCode,
      },
    ];
    presenter.ChangePhoneAction(context, list, phoneStr);
  }

  showTopError(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) {
          return ShowMessage(2, message, styleType: 1, width: 257);
        });
  }
}

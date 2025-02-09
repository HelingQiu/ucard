import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../../Common/CustomWidget.dart';
import '../../../../../Common/NumberPlus.dart';
import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/UserInfo.dart';
import '../../../../../main.dart';
import 'SafetyPinPresenter.dart';

class SafetyPinView extends StatelessWidget {
  final SafetyPinPresenter presenter;

  SafetyPinView(this.presenter);

  ScrollController _scrollController = ScrollController();
  StreamController<int> streamController = StreamController.broadcast();

  final TextEditingController _safetyPinCodeController =
      TextEditingController(text: '');
  final _safetyPinfocusNode = FocusNode();
  String _safetyPinCode = "";

  final TextEditingController _safetyPinAgainCodeController =
      TextEditingController(text: '');
  final _safetyPinAgainfocusNode = FocusNode();
  String _safetyPinAgainCode = "";

  bool isSent = false;
  final TextEditingController _emailCodeController =
      TextEditingController(text: '');
  final _emailfocusNode = FocusNode();
  String _emailCode = "";

  final ValueNotifier<bool> _sendCodeSuccess = ValueNotifier<bool>(false);

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: theme == AppTheme.light
            ? AppStatus.shared.bgWhiteColor
            : AppStatus.shared.bgBlackColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor, //修改颜色
          ),
          title: Text(
            "Safety Pin".tr(),
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
                          _buildSafetyPinView(context),
                          SizedBox(
                            height: 20,
                          ),
                          _buildSafetyPinAgainView(context),
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
                            height: 32,
                          ),
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
        left: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Your Safety Pin".tr(),
            style:
                TextStyle(fontSize: 16, color: AppStatus.shared.textGreyColor),
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
                streamController.add(0);
              },
              onChanged: (pin) {
                _safetyPinCode = pin;
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
        ],
      ),
    );
  }

  Widget _buildSafetyPinAgainView(BuildContext context) {
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
        left: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Again To Confirm".tr(),
            style:
                TextStyle(fontSize: 16, color: AppStatus.shared.textGreyColor),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: itemSize,
            child: Pinput(
              length: length,
              controller: _safetyPinAgainCodeController,
              focusNode: _safetyPinAgainfocusNode,
              defaultPinTheme: defaultPinTheme,
              onCompleted: (pin) {
                //
                _safetyPinAgainCode = pin;
                streamController.add(0);
              },
              onChanged: (pin) {
                _safetyPinAgainCode = pin;
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
        ],
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
            streamController.add(0);
          },
          onChanged: (pin) {
            _emailCode = pin;
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

  Widget _buildSubmitButton(BuildContext context) {
    bool clickDisable = false;
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (_safetyPinCode.isEmpty) {
            showTopError(context, "Please enter Safety Pin".tr());
            return;
          }
          if (_safetyPinAgainCode.isEmpty) {
            showTopError(context, "Please enter Again Safety Pin".tr());
            return;
          }
          if (_emailCode.isEmpty) {
            showTopError(context, "Please enter verification code".tr());
            return;
          }
          presenter.saveSafetyPinCode(
              context, _safetyPinCode, _safetyPinAgainCode, _emailCode);
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

  showTopError(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) {
          return ShowMessage(2, message, styleType: 1, width: 257);
        });
  }
}

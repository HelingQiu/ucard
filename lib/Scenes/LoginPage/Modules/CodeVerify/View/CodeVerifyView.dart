import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:pinput/pinput.dart';

import '../../../../../Common/CustomWidget.dart';
import '../../../../../Common/ShowMessage.dart';
import '../../../../../Common/StreamCenter.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../main.dart';
import '../Presenter/CodeVerifyPresenter.dart';

class CodeVerifyView extends StatelessWidget {
  final CodeVerifyPresenter presenter;
  // final TextEditingController _verificationController =
  //     TextEditingController(text: '');
  final controller = TextEditingController();
  final focusNode = FocusNode();

  bool isSent = false;
  String _code = "";
  final ValueNotifier<bool> _sendCodeSuccess = ValueNotifier<bool>(true);

  CodeVerifyView(this.presenter);

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme == AppTheme.light
            ? AppStatus.shared.bgWhiteColor
            : AppStatus.shared.bgBlackColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor, //修改颜色
          ),
          title: presenter.loginMethod == 0
              ? Text(
                  "Email Verification".tr(),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: theme == AppTheme.light
                          ? AppStatus.shared.bgBlackColor
                          : AppStatus.shared.bgWhiteColor),
                )
              : Text(
                  "Phone Verification".tr(),
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
          },
          child: Container(
              child: StreamBuilder<int>(
            stream: StreamCenter.shared.loginVerifyStreamController.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  _buildAccountsView(context),
                  SizedBox(
                    height: 20,
                  ),
                  _buildVerifyView(context),
                  SizedBox(
                    height: 20,
                  ),
                  _buildeSendCodeView(context),
                  _buildSubmitButton(context),
                ],
              ));
            },
          )),
        ),
      );
    });
  }

  Widget _buildAccountsView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "A verification code is sent to".tr(),
            style:
                TextStyle(fontSize: 16, color: AppStatus.shared.textGreyColor),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            " ${presenter.loginAccount}",
            style: TextStyle(
                fontSize: 16,
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyView(BuildContext context) {
    var itemSize = (MediaQuery.of(context).size.width - 120) / 6;
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
      padding: EdgeInsets.only(left: 20),
      child: SizedBox(
        height: itemSize,
        child: Pinput(
          length: length,
          controller: controller,
          focusNode: focusNode,
          defaultPinTheme: defaultPinTheme,
          onCompleted: (pin) {
            //
            _code = pin;
            StreamCenter.shared.loginVerifyStreamController.add(0);
          },
          onChanged: (pin) {
            _code = pin;
            StreamCenter.shared.loginVerifyStreamController.add(0);
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
          return SendCodeButton(
            1,
            true,
            true,
            Colors.transparent,
            () {
              isSent = true;
              StreamCenter.shared.loginVerifyStreamController.add(0);
              sendCodeButtonPressed(context);
            },
          );
        },
        valueListenable: _sendCodeSuccess,
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    bool clickDisable = false;
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 40),
      child: InkWell(
        onTap: () {
          if (_code.length == 6) {
            submitPressed(context, _code);
          }
        },
        child: Container(
          height: 44,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _code.length == 6
                ? AppStatus.shared.bgBlueColor
                : _theme == AppTheme.light
                    ? AppStatus.shared.bgGreyLightColor
                    : AppStatus.shared.bgDarkGreyColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              "Submit".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _code.length == 6
                      ? Colors.white
                      : AppStatus.shared.textGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  sendCodeButtonPressed(BuildContext context) async {
    _sendCodeSuccess.value = await presenter.sendCodePressed();
  }

  submitPressed(BuildContext context, String code) async {
    bool result = await presenter.loginVerifyPressed(context, code);
    if (result == true) {
      Navigator.pop(context);
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop(true);
      }
      StreamCenter.shared.refreshAllStreamController
          .add({"type": "index", "content": "0"});
      // showDialog(
      //     context: context,
      //     builder: (_) {
      //       return ShowMessage(1, "Login Success".tr(),
      //           dismissSeconds: 2, styleType: 1, width: 257);
      //     });
    }
  }

  showTopError(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) {
          return ShowMessage(2, message, styleType: 1, width: 257);
        });
  }
}

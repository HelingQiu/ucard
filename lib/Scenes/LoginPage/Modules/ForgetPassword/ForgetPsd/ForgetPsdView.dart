import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';
import 'dart:async';
import '../../../../../../Common/ShowMessage.dart';
import '../../../../../../Data/AppStatus.dart';
import '../../../../../main.dart';
import 'ForgetPsdPresenter.dart';

class ForgetPsdView extends StatelessWidget {
  final ForgetPsdPresenter presenter;

  final TextEditingController _newPasswordController =
      TextEditingController(text: '');
  final TextEditingController _confirmPasswordController =
      TextEditingController(text: '');

  StreamController<int> resetPsdStreamController = StreamController();

  String errorStr = '';

  ForgetPsdView(this.presenter);

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor, //修改颜色
          ),
          elevation: 0,
          centerTitle: false,
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          title: Text(
            "Forget Password".tr(),
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
          },
          child: Container(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgWhiteColor
                : AppStatus.shared.bgBlackColor,
            child: SafeArea(
              child: StreamBuilder<int>(
                stream: resetPsdStreamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return LayoutBuilder(builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                            minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NewPassowrdView(context),
                              ConfirmPassowrdView(context),
                              ErrorNewPsdView(context),
                              Container(
                                height: 60,
                              ),
                              SubmitButtonView(context),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget NewPassowrdView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 32),
      child: Container(
        height: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _theme == AppTheme.light
                ? AppStatus.shared.bgGreyLightColor
                : AppStatus.shared.bgGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            textAlign: TextAlign.start,
            autocorrect: false,
            obscureText: true,
            controller: _newPasswordController,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 15,
                  right: 5,
                  bottom: 14,
                ),
                border: InputBorder.none,
                hintText: "Please enter your new password".tr(),
                hintStyle: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 14)),
            onChanged: (text) {},
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  Widget ConfirmPassowrdView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        height: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _theme == AppTheme.light
                ? AppStatus.shared.bgGreyLightColor
                : AppStatus.shared.bgGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            textAlign: TextAlign.start,
            autocorrect: false,
            obscureText: true,
            controller: _confirmPasswordController,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 15,
                  right: 5,
                  bottom: 14,
                ),
                border: InputBorder.none,
                hintText: "Please confirm your new password".tr(),
                hintStyle: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 14)),
            onChanged: (text) {},
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  Widget ErrorNewPsdView(BuildContext context) {
    return Visibility(
      visible: errorStr.isNotEmpty,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: Text(
          errorStr,
          textAlign: TextAlign.start,
          style: TextStyle(color: ColorsUtil.hexColor(0xE85A6C), fontSize: 12),
        ),
      ),
    );
  }

  Widget SubmitButtonView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
      child: InkWell(
        onTap: () {
          //
          FocusScope.of(context).unfocus();
          String newPassword = _newPasswordController.text;
          String confirmPassword = _confirmPasswordController.text;
          if (newPassword == "" || confirmPassword == "") {
            errorStr = "Please enter password".tr();
            resetPsdStreamController.add(0);
          } else if (newPassword != confirmPassword) {
            errorStr = "The password you entered did not match".tr();
            resetPsdStreamController.add(0);
          } else {
            errorStr = "";
            resetPsdStreamController.add(0);
            //提交
            presenter.submitButtonPressed(context, newPassword);
          }
        },
        child: Container(
          height: 44,
          width: double.infinity,
          decoration: BoxDecoration(
            color: true
                ? AppStatus.shared.bgBlueColor
                : AppStatus.shared.bgDarkGreyColor,
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
}

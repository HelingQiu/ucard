import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../../../Common/StreamCenter.dart';
import '../../../../../Data/AppStatus.dart';
import '../Presenter/PasswordPresenter.dart';

class PasswordView extends StatelessWidget {
  final PasswordPresenter presenter;

  final TextEditingController _passwordController =
      TextEditingController(text: '');
  final TextEditingController _verifyPasswordControler =
      TextEditingController(text: '');
  final TextEditingController _inviteCodeControler =
      TextEditingController(text: '');

  ScrollController _scrollController = ScrollController();

  String errText = "The password you entered did not match";

  StreamController<int> psdStreamController = StreamController();

  PasswordView(this.presenter) {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Create a password".tr()),
        backgroundColor: AppStatus.shared.bgBlackColor,
      ),
      body: StreamBuilder<int>(
          stream: psdStreamController.stream,
          builder: (context, snapshot) {
            return Container(
              color: AppStatus.shared.bgBlackColor,
              child: SafeArea(
                child: ListView(
                  children: [
                    PasswordInputView(context),
                    VerifyPasswordInputView(context),
                    ErrorMessageRow(context),
                    InviteCodeView(context),
                    SignupButtonWidget(context),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget PasswordInputView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 168,
        left: 16,
        right: 16,
      ),
      child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppStatus.shared.bgGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            textAlign: TextAlign.start,
            autocorrect: false,
            obscureText: true,
            controller: _passwordController,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
                prefix: Container(
                  width: 15,
                ),
                suffix: Container(
                  width: 15,
                ),
                border: InputBorder.none,
                hintText: "Password".tr(),
                hintStyle: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 16)),
            onChanged: (text) {
              presenter.psd = text;
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
            onTap: () {
              _scrollController.animateTo(120,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
          )),
    );
  }

  Widget VerifyPasswordInputView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppStatus.shared.bgGreyColor,
          borderRadius: BorderRadius.circular(3),
        ),
        child: TextFormField(
            textAlign: TextAlign.start,
            autocorrect: false,
            obscureText: true,
            controller: _verifyPasswordControler,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
                prefix: Container(
                  width: 15,
                ),
                suffix: Container(
                  width: 15,
                ),
                border: InputBorder.none,
                hintText: "Repeat password".tr(),
                hintStyle: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 16)),
            onChanged: (text) {
              presenter.rePsd = text;
            },
            onTap: () {
              _scrollController.animateTo(120,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            }),
      ),
    );
  }

  Widget ErrorMessageRow(BuildContext context) {
    return Visibility(
      visible: presenter.showError,
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 16, right: 16),
        child: Text(
          errText,
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
      ),
    );
  }

  Widget InviteCodeView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppStatus.shared.bgGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
            textAlign: TextAlign.start,
            autocorrect: false,
            controller: _inviteCodeControler,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
                prefix: Container(
                  width: 15,
                ),
                suffix: Container(
                  width: 15,
                ),
                border: InputBorder.none,
                hintText: "Invitation Code (Optional)".tr(),
                hintStyle: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 16)),
            onChanged: (text) {
              presenter.inviteStr = text;
            },
            onTap: () {
              _scrollController.animateTo(200,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            }),
      ),
    );
  }

  Widget SignupButtonWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        //
        if (presenter.psd.isEmpty ||
            presenter.rePsd.isEmpty ||
            presenter.psd != presenter.rePsd) {
          presenter.showError = true;
          psdStreamController.add(0);
        } else {
          presenter.showError = false;
          psdStreamController.add(0);
          //下一步注册
          registerButtonPressed(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: 36, left: 16, right: 16),
        child: Container(
          height: 44,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppStatus.shared.bgBlueColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              "Sign up".tr(),
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

  registerButtonPressed(BuildContext context) async {
    List result = await presenter.registerButtonPressed(
        context, presenter.psd, presenter.rePsd, presenter.inviteStr);
    if (result[0] == 1) {
      //success
      login(context, presenter.account, presenter.psd);
    } else if (result[0] == 0) {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(0, result[1], styleType: 1, width: 257);
          });
    }
  }

  login(BuildContext context, String account, String password) async {
    List result = [];
    result = await presenter.login(context, account, password);
    if (result.isNotEmpty && result[0] == 1) {
      Navigator.pop(context);
      Navigator.pop(context);
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop(true);
      }
      StreamCenter.shared.refreshAllStreamController
          .add({"type": "index", "content": "0"});
      // showDialog(
      //     context: context,
      //     builder: (_) {
      //       return ShowMessage(result[0], result[1],
      //           dismissSeconds: 2, styleType: 1, width: 257);
      //     });
    }
  }
}

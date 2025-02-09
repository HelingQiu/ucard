import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_lifecycle/flutter_page_lifecycle.dart';
import 'package:pinput/pinput.dart';

import '../../../../../Common/CustomWidget.dart';
import '../../../../../Common/NumberPlus.dart';
import '../../../../../Common/ShowMessage.dart';
import '../../../../../Common/StreamCenter.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/UserInfo.dart';
import '../../../../../main.dart';
import '../../../../HomePage/Modules/Apply/Modules/ApplyUserInfo/CustomFormatter.dart';
import 'BindEmailPresenter.dart';

class BindEmailView extends StatelessWidget {
  final BindEmailPresenter presenter;

  bool isSent = false;
  bool isSent1 = false;

  final ValueNotifier<bool> _sendCodeSuccess = ValueNotifier<bool>(true);

  StreamController<int> streamController = StreamController.broadcast();
  ScrollController _scrollController = ScrollController();
  final TextEditingController _phoneCodeController =
      TextEditingController(text: '');
  final TextEditingController _newEmailController =
      TextEditingController(text: '');
  final TextEditingController _emailCodeController =
      TextEditingController(text: '');

  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  String _phoneCode = "";
  String _emailCode = "";

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  List<String> emailList = [
    "@gmail.com",
    "@icloud.com",
    "@hotmail.com",
    "@outlook.com",
    "@yahoo.com",
  ];

  BindEmailView(this.presenter);
  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    return PageLifecycle(
      stateChanged: (appear) {
        if (!appear) {
          hideOverView();
        }
      },
      child: BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
        _theme = theme;
        return Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: AppStatus.shared.bgBlackColor,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor, //修改颜色
            ),
            title: Text(
              "Connect email".tr(),
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
              hideOverView();
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
                            _buildPhoneVerifyView(context),
                            SizedBox(
                              height: 20,
                            ),
                            _buildeSendCodeView(context),
                            SizedBox(
                              height: 32,
                            ),
                            _buildEmailInputView(context),
                            _buildEmailInfoView(context),
                            _buildEmailVerifyView(context),
                            SizedBox(
                              height: 20,
                            ),
                            _buildeEmailCodeView(context),
                            SizedBox(
                              height: 380,
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
      }),
    );
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
      padding: EdgeInsets.only(
        left: 8,
      ),
      child: SizedBox(
        height: itemSize,
        child: Pinput(
          length: length,
          controller: _phoneCodeController,
          focusNode: _phoneFocusNode,
          defaultPinTheme: defaultPinTheme,
          onCompleted: (pin) {
            //
            _phoneCode = pin;
            streamController.add(0);
          },
          onChanged: (pin) {
            _phoneCode = pin;
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
          onTap: () {
            hideOverView();
          },
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
              hideOverView();
              sendCodePressed(UserInfo.shared.phone);
            });
          },
          valueListenable: _sendCodeSuccess,
        ));
  }

  Widget _buildEmailInputView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: CompositedTransformTarget(
        link: _layerLink,
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
            controller: _newEmailController,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontSize: 16),
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              CustomFormatter(),
            ],
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 15),
                border: InputBorder.none,
                hintText: "Email address".tr(),
                hintStyle: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 14)),
            onChanged: (text) {
              //
              if (text.isNotEmpty && text.indexOf("@") == text.length - 1) {
                debugPrint("当前输入文本$text");
                showOverView(context);
              } else {
                debugPrint("当前输入文本11111$text");
                hideOverView();
              }
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
            onTap: () {
              _scrollController.animateTo(120,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
          ),
        ),
      ),
    );
  }

  showOverView(BuildContext context) {
    _overlayEntry = createSelectPopupWindow();
    OverlayState? overlayState = Navigator.of(context).overlay;
    debugPrint("overlayState $overlayState");
    overlayState?.insert(_overlayEntry!);
  }

  hideOverView() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry createSelectPopupWindow() {
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return UnconstrainedBox(
        child: CompositedTransformFollower(
          offset: Offset(0, 10),
          link: _layerLink,
          targetAnchor: Alignment.bottomLeft,
          child: Material(
            color: AppStatus.shared.bgGreyColor,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: BoxConstraints(maxHeight: 180),
              width: MediaQuery.of(context).size.width - 32,
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
                bottom: 10,
              ),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: emailList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == emailList.length) {
                      return SizedBox(
                        height: 50,
                      );
                    }
                    String emailStr = emailList[index];
                    return InkWell(
                      onTap: () {
                        String account =
                            _newEmailController.text.replaceAll("@", "") +
                                emailStr;
                        _newEmailController.text = account;
                        streamController.add(0);
                        FocusScope.of(context).unfocus();
                        hideOverView();
                      },
                      child: SizedBox(
                        height: 34,
                        child: Row(
                          children: [
                            Text(
                              _newEmailController.text.replaceAll("@", ""),
                              style: TextStyle(
                                  color: AppStatus.shared.textGreyColor,
                                  fontSize: 14),
                            ),
                            Text(
                              emailStr,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
    return overlayEntry;
  }

  Widget _buildEmailInfoView(BuildContext context) {
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
              _newEmailController.text,
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
      padding: EdgeInsets.only(left: 8, top: 20),
      child: SizedBox(
        height: itemSize,
        child: Pinput(
          length: length,
          controller: _emailCodeController,
          focusNode: _emailFocusNode,
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
          onTap: () {
            hideOverView();
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

  Widget _buildeEmailCodeView(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 48,
        child: ValueListenableBuilder<bool>(
          builder: (BuildContext context, bool value, Widget? child) {
            return SendCodeButton(1, false, true, Colors.transparent, () {
              isSent1 = true;
              streamController.add(0);
              hideOverView();
              sendCodePressed(_newEmailController.text);
            });
          },
          valueListenable: _sendCodeSuccess,
        ));
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          hideOverView();
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

  Future<bool> sendCodePressed(String address) async {
    return await presenter.sendCodePressed(address);
  }

  submitButtonPressed(BuildContext context) async {
    String email = _newEmailController.text;
    if (_phoneCode.isEmpty) {
      showTopError(context, "Please enter verification code".tr());
      return;
    }
    if (email.isEmpty) {
      showTopError(context, "Please enter email".tr());
      return;
    }
    if (_emailCode.isEmpty) {
      showTopError(context, "Please enter verification code".tr());
      return;
    }
    List list = [
      {"account": email, "type": 1, "code": _emailCode},
      {"account": UserInfo.shared.phone, "type": 2, "code": _phoneCode}
    ];
    presenter.bindPhoneAction(context, list, email);
  }

  showTopError(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) {
          return ShowMessage(2, message, styleType: 1, width: 257);
        });
  }
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';
import 'package:ucardtemp/Common/TextImageButton.dart';
import 'dart:async';

import '../../../Common/CustomWidget.dart';
import '../../../Common/ShowMessage.dart';
import '../../../Common/StreamCenter.dart';
import '../../../Data/AppStatus.dart';
import '../../../Data/UserInfo.dart';
import '../../../gen_a/A.dart';
import '../../../main.dart';
import '../../HomePage/Modules/Apply/Modules/ApplyUserInfo/CustomFormatter.dart';
import '../Presenter/LoginPresenter.dart';

class LoginView extends StatelessWidget {
  final LoginPresenter presenter;

  TextEditingController _emailController =
      TextEditingController(text: UserInfo.shared.lastEmail);
  final TextEditingController _passwordController =
      TextEditingController(text: '');
  final TextEditingController _phoneController =
      TextEditingController(text: UserInfo.shared.lastPhone);
  final TextEditingController _verificationController =
      TextEditingController(text: '');

  ScrollController _scrollController = ScrollController();

  final ValueNotifier<bool> _sendCodeSuccess = ValueNotifier<bool>(true);

  StreamController<String> loginErrorStreamController = StreamController();

  String errText = "";

  LoginView(this.presenter) {
    debugPrint('Login view init');
  }
  String inputTip = "";
  OverlayEntry textFormOverlayEntry = new OverlayEntry(
    builder: (context) {
      return Container();
    },
  );

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  List<String> emailList = [
    "@gmail.com",
    "@icloud.com",
    "@hotmail.com",
    "@outlook.com",
    "@yahoo.com",
  ];

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    checkConnectStatus(context);
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return GestureDetector(
        onTap: () {
          hideOverView();
          FocusScope.of(context).unfocus();
          _scrollController.animateTo(0,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          body: Container(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgWhiteColor
                : AppStatus.shared.bgBlackColor,
            child: SafeArea(
              child: Stack(
                children: [
                  StreamBuilder<int>(
                    stream:
                        StreamCenter.shared.loginRefreshStreamController.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == 1) {
                        presenter.loginMethod = 0;
                      } else if (snapshot.data == 2) {
                        presenter.loginMethod = 1;
                      } else if (snapshot.data == 3) {
                        presenter.showPsd = false;
                      } else if (snapshot.data == 4) {
                        presenter.showPsd = true;
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        child: Column(
                          children: [
                            LoginColumn(context),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    width: width,
                    height: 50,
                    child: copyrightView(),
                  ),
                  Positioned(width: width, height: 50, child: TopView(context)),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  //顶部
  Widget TopView(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            hideOverView();
            FocusScope.of(context).unfocus();
            presenter.closeButtonPressed(context);
          },
          icon: Image.asset(_theme == AppTheme.light
              ? A.assets_login_close_black
              : A.assets_login_close),
        )
      ],
    );
  }

  Widget LoginColumn(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 12,
          child: Column(
            children: [
              Container(height: 50),
              LogoView(),
              LoginMethod(context),
              Container(
                height: 30,
              ),
              InputView(context),
              ErrorMessageRow(context),
              Container(
                height: 10,
              ),
              LoginButtonWidget(context),
              Container(
                height: 20,
              ),
              RegisterButtonWidget(context),
              Container(
                height: 300,
              ),
            ],
          ),
        ),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }

  Widget LogoView() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          children: [
            Spacer(),
            Image.asset(_theme == AppTheme.light
                ? A.assets_login_logo_black
                : A.assets_login_logo),
            Container(
              height: 12,
            ),
            Visibility(
                visible: _theme != AppTheme.light,
                child: Image.asset(A.assets_login_logo_name)),
            Spacer()
          ],
        ),
      ),
    );
  }

  Widget LoginMethod(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width - 120,
      decoration: BoxDecoration(
        color: _theme == AppTheme.light
            ? AppStatus.shared.bgGreyLightColor
            : AppStatus.shared.bgDarkGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
              child: InkWell(
            onTap: () {
              hideOverView();
              StreamCenter.shared.loginRefreshStreamController.add(1);
            },
            child: Container(
              decoration: BoxDecoration(
                color: presenter.loginMethod == 0
                    ? AppStatus.shared.bgBlueColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Email'.tr(),
                  style: TextStyle(
                      color: presenter.loginMethod == 0
                          ? AppStatus.shared.bgWhiteColor
                          : _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )),
          Expanded(
            child: InkWell(
              onTap: () {
                hideOverView();
                StreamCenter.shared.loginRefreshStreamController.add(2);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: presenter.loginMethod == 1
                      ? AppStatus.shared.bgBlueColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Phone'.tr(),
                    style: TextStyle(
                        color: presenter.loginMethod == 1
                            ? AppStatus.shared.bgWhiteColor
                            : _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget InputView(BuildContext context) {
    return presenter.loginMethod == 0
        ? EmailLoginInputView(context)
        : PhoneLoginInputView(context);
  }

  Widget EmailLoginInputView(BuildContext context) {
    return Column(
      children: [EmailInputView(context), PasswordInputView(context)],
    );
  }

  Widget PhoneLoginInputView(BuildContext context) {
    return Column(
      children: [
        // PhoneAreaCodeInputView(),
        PhoneInputView(context),
        PasswordInputView(context)
      ],
    );
  }

  Widget EmailInputView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0, bottom: 10),
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
            controller: _emailController,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              CustomFormatter(),
            ],
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 15),
                border: InputBorder.none,
                hintText: "Please enter your email".tr(),
                hintStyle: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 16)),
            onChanged: (text) {
              if (text.isNotEmpty && text.indexOf("@") == text.length - 1) {
                debugPrint("当前输入文本$text");
                showOverView(context);
              } else {
                debugPrint("当前输入文本11111$text");
                hideOverView();
              }
              removeErr();
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
            color: _theme == AppTheme.light
                ? ColorsUtil.hexColor(0xf2f2f2)
                : AppStatus.shared.bgGreyColor,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: BoxConstraints(maxHeight: 180),
              width: MediaQuery.of(context).size.width - 56,
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
                            _emailController.text.replaceAll("@", "") +
                                emailStr;
                        _emailController.text = account;
                        StreamCenter.shared.loginRefreshStreamController.add(0);
                        FocusScope.of(context).unfocus();
                        hideOverView();
                      },
                      child: SizedBox(
                        height: 34,
                        child: Row(
                          children: [
                            Text(
                              _emailController.text.replaceAll("@", ""),
                              style: TextStyle(
                                  color: AppStatus.shared.textGreyColor,
                                  fontSize: 14),
                            ),
                            Text(
                              emailStr,
                              style: TextStyle(
                                  color: _theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor,
                                  fontSize: 14),
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

  Widget PasswordInputView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 0),
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
            obscureText: presenter.showPsd ? false : true,
            controller: _passwordController,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15, bottom: 0),
                suffixIcon: GestureDetector(
                    onTap: () {
                      if (presenter.showPsd) {
                        StreamCenter.shared.loginRefreshStreamController.add(3);
                      } else {
                        StreamCenter.shared.loginRefreshStreamController.add(4);
                      }
                    },
                    child: Image.asset(presenter.showPsd
                        ? _theme == AppTheme.light
                            ? A.assets_visible_black
                            : A.assets_wallet_visible_open
                        : _theme == AppTheme.light
                            ? A.assets_unvisible_black
                            : A.assets_wallet_visible_close)),
                border: InputBorder.none,
                hintText: "Please enter password".tr(),
                hintStyle: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 16)),
            onChanged: (text) {
              removeErr();
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

  Widget PhoneInputView(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 0, bottom: 10),
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
                          color: AppStatus.shared.textGreyColor, fontSize: 16)),
                  onChanged: (text) {
                    removeErr();
                  },
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
      ),
    );
  }

  Widget ErrorMessageRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<String>(
              stream: loginErrorStreamController.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data != null) {
                  errText = snapshot.data;
                  return Text(
                    errText,
                    style: TextStyle(color: Colors.red),
                  );
                }
                return Container();
              }
              //Text('error message', style: TextStyle(color: Colors.red),),
              ),
        ),
        TextButton(
          onPressed: () {
            presenter.forgetButtonPressed(context);
          },
          child: Text(
            "Forgot Password?".tr(),
            style:
                TextStyle(color: AppStatus.shared.textGreyColor, fontSize: 14),
          ),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white)),
        )
      ],
    );
  }

  Widget LoginButtonWidget(BuildContext context) {
    bool clickDisable = false;
    return InkWell(
      onTap: () {
        hideOverView();
        FocusScope.of(context).unfocus();
        if (clickDisable == false) {
          loginButtonPressed(context);
        }
        clickDisable = true;
        Future.delayed(Duration(milliseconds: 500), () {
          clickDisable = false;
        });
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
            "Login".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget RegisterButtonWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        presenter.registerButtonPressed(context);
      },
      child: Container(
        height: 44,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _theme == AppTheme.light
              ? AppStatus.shared.bgGreyLightColor
              : AppStatus.shared.bgBlackColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(
            "Sign up".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppStatus.shared.bgBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget copyrightView() {
    return Center(
      child: Text(
        "Uollar limited Copyright".tr(),
        style: TextStyle(color: AppStatus.shared.textGreyColor),
      ),
    );
  }

  showRegister(BuildContext context) {
    presenter.registerButtonPressed(context);
  }

  loginButtonPressed(BuildContext context) async {
    debugPrint("loginButtonPressed");
    List result = [];
    if (presenter.loginMethod == 0) {
      presenter.loginButtonPressed(
          context, _emailController.text, _passwordController.text);
    } else {
      presenter.loginButtonPressed(
          context, _phoneController.text, _passwordController.text);
    }
    return;
  }

  removeErr() {
    if (errText != "") {
      loginErrorStreamController.add("");
    }
  }

  showTopError(BuildContext context, String err) {
    // AlertController.show("Fail".tr(), err.tr(), TypeAlert.error,);
    showDialog(
        context: context,
        builder: (_) {
          return ShowMessage(2, err.tr(), styleType: 1, width: 257);
        });
  }

  checkConnectStatus(BuildContext context) async {
    Future.delayed(Duration(milliseconds: 200), () {
      AppStatus.shared.checkConnectStatus(context);
    });
  }
}

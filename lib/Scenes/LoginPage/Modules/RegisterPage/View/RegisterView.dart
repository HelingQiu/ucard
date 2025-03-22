import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Common/ColorUtil.dart';
import '../../../../../Common/CustomWidget.dart';
import '../../../../../Common/ShowMessage.dart';
import '../../../../../Common/StreamCenter.dart';
import '../../../../../Common/TextImageButton.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/UserInfo.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
import '../../../../HomePage/Modules/Apply/Modules/ApplyUserInfo/CustomFormatter.dart';
import '../Presenter/RegisterPresenter.dart';

class RegisterView extends StatelessWidget {
  final RegisterPresenter presenter;

  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _phoneController =
      TextEditingController(text: '');
  final TextEditingController _emailVerificationController =
      TextEditingController(text: '');
  final TextEditingController _phoneVerificationController =
      TextEditingController(text: '');

  ScrollController _scrollController = ScrollController();

  final ValueNotifier<bool> _sendCodeSuccess = ValueNotifier<bool>(true);

  StreamController<String> registerErrorStreamController = StreamController();

  String errText = "";

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  List<String> emailList = [
    "@gmail.com",
    "@icloud.com",
    "@hotmail.com",
    "@outlook.com",
    "@yahoo.com",
  ];

  bool emailSendCodeButtonEnable = false;
  bool phoneSendCodeButtonEnable = false;

  StreamController<int> emailSendCodeStreamController =
      StreamController.broadcast();
  StreamController<int> phoneSendCodeStreamController =
      StreamController.broadcast();

  RegisterView(this.presenter, {Key? key}) : super(key: key) {
    // debugPrint('Login view init');
  }

  AppTheme _theme = AppTheme.dark;

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    checkConnectStatus(context);
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return Scaffold(
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
                GestureDetector(
                  onTap: () {
                    hideOverView();
                    FocusScope.of(context).unfocus();
                    _scrollController.animateTo(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: StreamBuilder<int>(
                      stream: StreamCenter
                          .shared.registerRefreshStreamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data == 1) {
                          presenter.registerMethod = 0;
                        } else if (snapshot.data == 2) {
                          presenter.registerMethod = 1;
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          controller: _scrollController,
                          child: Column(
                            children: [RegisterColumn(context)],
                          ),
                        );
                      }),
                ),
                Positioned(
                  bottom: 0,
                  width: width,
                  height: 50,
                  child: copyrightView(),
                ),
                Positioned(width: width, height: 50, child: TopView(context))
              ],
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

  Widget RegisterColumn(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 12,
          child: Column(
            children: [
              Container(height: 50),
              LogoView(),
              RegisterMethod(context),
              Container(
                height: 30,
              ),
              InputView(context),
              ErrorMessageRow(context),
              Container(
                height: 10,
              ),
              AgreementWidget(context),
              Container(
                height: 10,
              ),
              nextButtonWidget(context),
              Container(
                height: 20,
              ),
              LoginButtonWidget(context),
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
            Text(
              "UOK",
              style: TextStyle(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 40),
            ),
            // Image.asset(_theme == AppTheme.light
            //     ? A.assets_login_logo_black
            //     : A.assets_login_logo),
            Container(
              height: 12,
            ),
            // Visibility(
            //     visible: _theme != AppTheme.light,
            //     child: Image.asset(A.assets_login_logo_name)),
            Spacer()
          ],
        ),
      ),
    );
  }

  Widget RegisterMethod(BuildContext context) {
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
              StreamCenter.shared.registerRefreshStreamController.add(1);
            },
            child: Container(
              decoration: BoxDecoration(
                color: presenter.registerMethod == 0
                    ? AppStatus.shared.bgBlueColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Email'.tr(),
                  style: TextStyle(
                      color: presenter.registerMethod == 0
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
                StreamCenter.shared.registerRefreshStreamController.add(2);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: presenter.registerMethod == 1
                      ? AppStatus.shared.bgBlueColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Phone'.tr(),
                    style: TextStyle(
                        color: presenter.registerMethod == 1
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
    return presenter.registerMethod == 0
        ? EmailRegisterInputView(context)
        : PhoneRegisterInputView(context);
  }

  //邮件注册
  Widget EmailRegisterInputView(BuildContext context) {
    return Column(
      children: [
        EmailInputView(context),
        EmailVerificationCodeView(context),
      ],
    );
  }

  //电话注册
  Widget PhoneRegisterInputView(BuildContext context) {
    return Column(
      children: [
        PhoneInputView(context),
        PhoneVerificationCodeView(context),
      ],
    );
  }

  //邮件输入
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
                emailSendCodeButtonEnable = text != "";
                emailSendCodeStreamController.add(0);
                removeErr();
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              onTap: () {
                _scrollController.animateTo(120,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              },
            )),
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
                        StreamCenter.shared.registerRefreshStreamController
                            .add(0);
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

  //邮件验证码
  Widget EmailVerificationCodeView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _theme == AppTheme.light
              ? AppStatus.shared.bgGreyLightColor
              : AppStatus.shared.bgGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                    textAlign: TextAlign.start,
                    autocorrect: false,
                    controller: _emailVerificationController,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        border: InputBorder.none,
                        hintText: "Verification Code".tr(),
                        hintStyle: TextStyle(
                            color: AppStatus.shared.textGreyColor,
                            fontSize: 16)),
                    onChanged: (text) {
                      removeErr();
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    }),
              ),
              Expanded(
                flex: 1,
                child: ValueListenableBuilder<bool>(
                  builder: (BuildContext context, bool value, Widget? child) {
                    return StreamBuilder<int>(
                        stream: emailSendCodeStreamController.stream,
                        builder: (context, snapshot) {
                          return SendCodeButton(
                            0,
                            false,
                            emailSendCodeButtonEnable,
                            AppStatus.shared.bgBlueColor,
                            () {
                              FocusScope.of(context).unfocus();
                              if (_emailController.text.isEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return ShowMessage(
                                          0, "Please enter email".tr(),
                                          styleType: 1, width: 257);
                                    });
                                return;
                              }
                              sendCodeButtonPressed(context, 0);
                            },
                            sendCodeSuccess: _sendCodeSuccess.value,
                          );
                        });
                  },
                  valueListenable: _sendCodeSuccess,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //电话输入
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
                          color: AppStatus.shared.textGreyColor, fontSize: 16)),
                  onChanged: (text) {
                    phoneSendCodeButtonEnable = text != "";
                    phoneSendCodeStreamController.add(0);
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

  //电话验证码
  Widget PhoneVerificationCodeView(BuildContext context) {
    bool sendCodeButtonEnable =
        (_phoneController.text != "" && UserInfo.shared.areaCode != null);
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _theme == AppTheme.light
              ? AppStatus.shared.bgGreyLightColor
              : AppStatus.shared.bgGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                    textAlign: TextAlign.start,
                    autocorrect: false,
                    controller: _phoneVerificationController,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        border: InputBorder.none,
                        hintText: "Verification Code".tr(),
                        hintStyle: TextStyle(
                            color: AppStatus.shared.textGreyColor,
                            fontSize: 16)),
                    onChanged: (text) {
                      removeErr();
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    }),
              ),
              Expanded(
                flex: 1,
                child: ValueListenableBuilder<bool>(
                  builder: (BuildContext context, bool value, Widget? child) {
                    return StreamBuilder<int>(
                        stream: phoneSendCodeStreamController.stream,
                        builder: (context, snapshot) {
                          return SendCodeButton(
                            0,
                            false,
                            phoneSendCodeButtonEnable,
                            AppStatus.shared.bgBlueColor,
                            () {
                              FocusScope.of(context).unfocus();
                              if (_phoneController.text.isEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return ShowMessage(
                                          0, "Please enter phone number".tr(),
                                          styleType: 1, width: 257);
                                    });
                                return;
                              }
                              sendCodeButtonPressed(context, 1);
                            },
                            sendCodeSuccess: _sendCodeSuccess.value,
                          );
                        });
                  },
                  valueListenable: _sendCodeSuccess,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget ErrorMessageRow(BuildContext context) {
    return Container(
      height: 20,
      child: StreamBuilder<String>(
        stream: registerErrorStreamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            debugPrint("errText = $errText");
            if (snapshot.data == "") {
              errText = "";
            } else {
              errText = snapshot.data;
            }
          }
          return errText == ""
              ? Container()
              : Text(
                  errText,
                  style: TextStyle(color: Colors.red),
                );
        },
      ),
    );
  }

  Widget AgreementWidget(BuildContext context) {
    bool agree = presenter.agree;
    return BlocProvider(
      create: (_) => RegisterAgreeBloc(presenter),
      child: BlocBuilder<RegisterAgreeBloc, bool>(builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Container(
                width: 30,
                height: 40,
                alignment: Alignment.centerLeft,
                child: Image.asset(agree == true
                    ? A.assets_mine_lan_selected
                    : _theme == AppTheme.light
                        ? A.assets_mine_lan_normal
                        : A.assets_mine_lan_normal),
              ),
              onTap: () {
                agree = presenter.agreeButtonPressed();
                if (agree == true) {
                  context.read<RegisterAgreeBloc>().add(RegisterAgreedState());
                } else {
                  context
                      .read<RegisterAgreeBloc>()
                      .add(RegisterDisagreedState());
                }
              },
            ),
            Flexible(
                child: FittedBox(
              child: Row(
                children: [
                  Text("I have read and agreed the".tr(),
                      style: TextStyle(
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor)),
                  TextButton(
                    onPressed: () {
                      presenter.agreementButtonPressed(context);
                    },
                    child: Text(
                      "User Agreement".tr(),
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor)),
                  )
                ],
              ),
              fit: BoxFit.scaleDown,
            )),
          ],
        );
      }),
    );
  }

  //下一步
  Widget nextButtonWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        hideOverView();
        FocusScope.of(context).unfocus();

        String account = "";
        String smscode = "";
        if (presenter.registerMethod == 0) {
          account = _emailController.text;
          smscode = _emailVerificationController.text;
        } else {
          account = _phoneController.text;
          smscode = _phoneVerificationController.text;
        }

        presenter.nextPressed(context, account, smscode);
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
            "Next".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget LoginButtonWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        //
        presenter.loginButtonPressed(context);
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
            "Login".tr(),
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

  sendCodeButtonPressed(BuildContext context, int type) async {
    bool success = false;
    _sendCodeSuccess.value = true;
    if (type == 0) {
      success = await presenter.emailSendCodeButtonPressed(
          context, _emailController.text);
    } else {
      success = await presenter.phoneSendCodeButtonPressed(
          context, _phoneController.text);
    }
    _sendCodeSuccess.value = success;
    FocusScope.of(context).unfocus();
  }

  removeErr() {
    if (errText != "") {
      registerErrorStreamController.add("");
    }
  }

  checkConnectStatus(BuildContext context) async {
    Future.delayed(Duration(milliseconds: 200), () {
      AppStatus.shared.checkConnectStatus(context);
    });
  }
}

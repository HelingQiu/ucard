import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_lifecycle/flutter_page_lifecycle.dart';
import 'package:ucardtemp/Common/StringExtension.dart';

import '../../../../../Common/ColorUtil.dart';
import '../../../../../Common/ShowMessage.dart';
import '../../../../../Common/StreamCenter.dart';
import '../../../../../Common/TextImageButton.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/UserInfo.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
import '../../../../HomePage/Modules/Apply/Modules/ApplyUserInfo/CustomFormatter.dart';
import 'ForgetAccountPresenter.dart';

class ForgetAccountView extends StatelessWidget {
  final ForgetAccountPresenter presenter;

  final TextEditingController _emailController =
      TextEditingController(text: UserInfo.shared.lastEmail);
  final TextEditingController _phoneController =
      TextEditingController(text: UserInfo.shared.lastPhone);

  ForgetAccountView(this.presenter);

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
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return StreamBuilder<int>(
        stream: StreamCenter.shared.forgetRefreshStreamController.stream,
        builder: (context, snapshot) {
          return PageLifecycle(
            stateChanged: (appear) {
              if (!appear) {
                hideOverView();
                FocusScope.of(context).unfocus();
              }
            },
            child: GestureDetector(
              onTap: () {
                hideOverView();
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
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
                body: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 36,
                      ),
                      _buildAccountMethod(context),
                      SizedBox(
                        height: 36,
                      ),
                      _buildInputView(context),
                      SizedBox(
                        height: 70,
                      ),
                      _nextButtonView(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildAccountMethod(BuildContext context) {
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
              presenter.accountType = 0;
              StreamCenter.shared.forgetRefreshStreamController.add(0);
            },
            child: Container(
              decoration: BoxDecoration(
                color: presenter.accountType == 0
                    ? AppStatus.shared.bgBlueColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Email'.tr(),
                  style: TextStyle(
                      color: presenter.accountType == 0
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
                presenter.accountType = 1;
                StreamCenter.shared.forgetRefreshStreamController.add(0);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: presenter.accountType == 1
                      ? AppStatus.shared.bgBlueColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Phone'.tr(),
                    style: TextStyle(
                        color: presenter.accountType == 1
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

  Widget _buildInputView(BuildContext context) {
    return presenter.accountType == 0
        ? EmailInputView(context)
        : PhoneInputView(context);
  }

  Widget EmailInputView(BuildContext context) {
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
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
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

  Widget PhoneInputView(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                hideOverView();
                FocusScope.of(context).unfocus();
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
                  decoration: InputDecoration(
                      prefix: Container(
                        width: 15,
                      ),
                      suffix: Container(
                        width: 15,
                      ),
                      border: InputBorder.none,
                      hintText: "Phone Number".tr(),
                      hintStyle: TextStyle(
                          color: AppStatus.shared.textGreyColor, fontSize: 16)),
                  onChanged: (text) {},
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextButtonView(BuildContext context) {
    String account = presenter.accountType == 0
        ? _emailController.text
        : _phoneController.text;
    return InkWell(
      onTap: () {
        String error = "";
        if (presenter.accountType == 0) {
          if (account.isEmpty) {
            error = "No email".tr();
          } else if (account.isValidEmail() == false) {
            error = "Wrong email".tr();
          }
        } else {
          if (UserInfo.shared.areaCode == null) {
            error = "No area code".tr();
          } else if (account.isEmpty) {
            error = "No phone number".tr();
          } else {
            account =
                "${UserInfo.shared.areaCode!.interarea.replaceAll("+", "")} $account";
          }
        }
        if (error != "") {
          showError(context, error);
          return;
        }
        //下一步
        presenter.nextButtonPressed(context, account);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
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
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  showError(BuildContext context, String err) {
    showDialog(
        context: context,
        builder: (_) {
          return ShowMessage(2, err.tr(), styleType: 1, width: 257);
        });
  }
}

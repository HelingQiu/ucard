import "dart:io" show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_lifecycle/flutter_page_lifecycle.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/AccountSecurity/BindEmail/BindEmailBuilder.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/AccountSecurity/DeleteAccountVerify/Builder/DeleteVerifyBuilder.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/AccountSecurity/SafetyPin/SafetyPinBuilder.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/AccountSecurity/UpdatePhone/UpdatePhoneBuilder.dart';

import '../../../../Common/NumberPlus.dart';
import '../../../../Common/ShowMessage.dart';
import '../../../../Data/AppStatus.dart';
import '../../../../Data/UserInfo.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';
import 'BindPhone/BindPhoneBuilder.dart';
import 'ChangePassword/Builder/ChangePasswordBuilder.dart';
import 'UpdateEmail/UpdateEmailBuilder.dart';

class AccountAndSecurityPage extends StatefulWidget {
  @override
  AccountAndSecurityPageState createState() => AccountAndSecurityPageState();
}

class AccountAndSecurityPageState extends State<AccountAndSecurityPage> {
  /// 本地认证框架
  final LocalAuthentication auth = LocalAuthentication();

  /// 是否有可用的生物识别技术
  bool _canCheckBiometrics = false;

  ///是否已经打开开关
  bool _switchFlag = false;

  //是否同意删除账号
  bool agreeDeleteAccount = false;

  final TextEditingController _passwordController =
      TextEditingController(text: '');
  String _pwdStr = "";

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    getSwitchFlag();
  }

  @override
  void dispose() {
    super.dispose();
  }

  AppTheme _theme = AppTheme.dark;
  @override
  Widget build(BuildContext context) {
    return PageLifecycle(stateChanged: (appear) {
      if (appear) {
        setState(() {});
      }
    }, child: BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, theme) {
        _theme = theme;
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor, //修改颜色
            ),
            elevation: 0,
            title: Text(
              "Account security".tr(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor),
            ),
            backgroundColor: theme == AppTheme.light
                ? AppStatus.shared.bgWhiteColor
                : AppStatus.shared.bgBlackColor,
          ),
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          body: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              color: theme == AppTheme.light
                  ? AppStatus.shared.bgWhiteColor
                  : AppStatus.shared.bgBlackColor,
              child: Column(
                children: [
                  EmailView(context),
                  PhoneView(context),
                  ChangePassword(context),
                  setSafetyPin(context),
                  BiometricsView(context),
                  Expanded(
                      child: Column(
                    children: [Spacer(), CancellationButton(context)],
                  )),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  Widget EmailView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (UserInfo.shared.email != "" && UserInfo.shared.phone != "") {
          //跳转到修改邮箱
          showUpdateEmailPhoneDiolog(context, 0);
        } else if (UserInfo.shared.email != "" && UserInfo.shared.phone == "") {
          showAlertDialog(context);
        } else {
          //跳转到绑定邮箱
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BindEmailBuilder('').scene));
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Email2".tr(),
                      style: TextStyle(
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      (UserInfo.shared.email != "")
                          ? NumberPlus.getSecurityEmail(UserInfo.shared.email)
                          : "To be connected".tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppStatus.shared.textGreyColor, fontSize: 14),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget PhoneView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (UserInfo.shared.phone != "" && UserInfo.shared.email != "") {
          //跳转到修改手机
          showUpdateEmailPhoneDiolog(context, 1);
        } else if (UserInfo.shared.phone != "" && UserInfo.shared.email == "") {
          showAlertDialog(context);
        } else {
          //跳转到绑定手机
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BindPhoneBuilder('').scene));
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Phone number2".tr(),
                      style: TextStyle(
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      (UserInfo.shared.phone != "")
                          ? "+${NumberPlus.getSecurityEmail(UserInfo.shared.phone)}"
                          : "To be connected".tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppStatus.shared.textGreyColor, fontSize: 14),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ChangePassword(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChangePasswordBuilder().scene));
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Change password".tr(),
                      style: TextStyle(
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 14),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setSafetyPin(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSafetyPinDiolog(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Safety Pin".tr(),
                      style: TextStyle(
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 14),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //面容id
  Widget BiometricsView(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    Platform.isAndroid ? "Touch ID".tr() : "Face ID".tr(),
                    style: TextStyle(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        fontSize: 14),
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                      activeColor: AppStatus.shared.bgBlueColor,
                      trackColor: const Color.fromRGBO(169, 169, 169, 1),
                      thumbColor: Colors.white,
                      value: _switchFlag,
                      onChanged: (value) {
                        //
                        if (!_canCheckBiometrics) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return ShowMessage(
                                    2,
                                    "Please go to System to set up your".tr() +
                                        "${Platform.isAndroid ? "Touch ID".tr() : "Face ID".tr()}"
                                            .tr(),
                                    dismissSeconds: 2,
                                    styleType: 1,
                                    width: 257);
                              });
                          return;
                        }
                        if (_switchFlag) {
                          showPwdContentView(context);
                        } else {
                          //打开生物识别
                          showPwdContentView(context);
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget CancellationButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDeleteAccountDiolog(context);
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: Center(
          child: Text(
            "Delete account".tr(),
            style: TextStyle(color: AppStatus.shared.bgBlueColor, fontSize: 16),
          ).tr(),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    String str1 = "Please bind mobile phone/email first".tr();

    String buttonTitle = "OK".tr();

    showDialog(
        context: context,
        builder: (_) {
          return UnconstrainedBox(
            constrainedAxis: Axis.vertical,
            child: SizedBox(
              width: 287,
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromRGBO(31, 45, 78, 1),
                  ),
                  // margin:EdgeInsetsDirectional.only(top: 39) ,
                  padding: EdgeInsets.only(top: 34, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        str1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          // decoration: TextDecoration.none
                        ),
                      ),
                      SizedBox(
                        height: 47,
                      ),
                      Container(
                        width: 247,
                        height: 44,
                        child: ElevatedButton(
                          child: SizedBox(
                            child: Text(
                              buttonTitle,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppStatus.shared.bgBlueColor),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  //face底部弹窗
  showPwdContentView(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.68),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return Container(
              decoration: BoxDecoration(
                  color: AppStatus.shared.bgBlackColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CloseButtonView(context),
                  PasswordInputView(context),
                  SureButtonWidget(context),
                  // const SizedBox(
                  //   height: 20,
                  // )
                ],
              ),
            );
          });
        }).whenComplete(() {
      _pwdStr = "";
      _passwordController.text = "";
    });
  }

  Widget CloseButtonView(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Verify password".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Positioned(
            right: 10,
            child: IconButton(
                onPressed: () {
                  _pwdStr = "";
                  _passwordController.text = _pwdStr;
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, color: Colors.white, size: 24)),
          )
        ],
      ),
    );
  }

  Widget PasswordInputView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Container(
          height: 48,
          child: DecoratedBox(
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
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 15),
                  border: InputBorder.none,
                  hintText: "Enter your password".tr(),
                  hintStyle: TextStyle(color: AppStatus.shared.textGreyColor)),
              onChanged: (text) {
                _pwdStr = text;
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
            ),
          )),
    );
  }

  Widget SureButtonWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, left: 20, right: 20, bottom: 20),
      child: Container(
          height: 44,
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: null,
              backgroundColor:
                  MaterialStateProperty.all(AppStatus.shared.bgBlueColor),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            onPressed: () async {
              //调用接口验证
              //去生物识别
              if (_pwdStr.isEmpty) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return ShowMessage(2, "No password".tr(),
                          dismissSeconds: 2, styleType: 1, width: 257);
                    });
                return;
              }
              String result = await LoginCenter().verifyPwd(
                  UserInfo.shared.username,
                  UserInfo.shared.email != "" ? 1 : 2,
                  _pwdStr);
              if (result.isEmpty) {
                Navigator.of(context).pop();
                if (_switchFlag) {
                  setState(() {
                    setSwitchFlag(false);
                    setDonotTip();
                  });
                } else {
                  //去生物识别
                  bool isSuccess = await authenticate();
                  debugPrint("识别结果：$isSuccess");
                  setSwitchFlag(isSuccess);
                }
              } else {
                showDialog(
                    context: context,
                    builder: (_) {
                      return ShowMessage(2, result,
                          dismissSeconds: 2, styleType: 1, width: 257);
                    });
              }
            },
            child: SizedBox(
              width: 100,
              child: Text(
                "Confirm".tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )),
    );
  }

  //删除账号弹窗
  //是否同意
  Widget deleteAccountAgreementWidget(
      BuildContext context, StateSetter mystate) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            child: Container(
              width: 30,
              height: 40,
              alignment: Alignment.centerLeft,
              child: Image.asset(agreeDeleteAccount == true
                  ? A.assets_mine_lan_selected
                  : A.assets_mine_lan_normal),
            ),
            onTap: () {
              agreeDeleteAccount = !agreeDeleteAccount;
              mystate(() {});
            },
          ),
          Expanded(
            child: Text('Delete agreement'.tr(),
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white, fontSize: 14))
                .tr(),
          ),
        ],
      ),
    );
  }

  //底部按钮
  Widget deleteAccountBottomView(BuildContext context, StateSetter mystate) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          deleteAccountAgreementWidget(context, mystate),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
                  child: InkWell(
                    onTap: () {
                      //确认删除
                      if (agreeDeleteAccount) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DeleteVerifyBuilder().scene));
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return ShowMessage(2, 'Please agree'.tr(),
                                  dismissSeconds: 2, styleType: 1, width: 257);
                            });
                      }
                    },
                    child: Container(
                      height: 44,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          "Confirm design".tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20, top: 10),
                  child: InkWell(
                    onTap: () {
                      //取消删除
                      Navigator.pop(context);
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
                          "Back".tr(),
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
        ],
      ),
    );
  }

  //safepin
  showSafetyPinDiolog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 165),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return Container(
              decoration: BoxDecoration(
                  color: ColorsUtil.hexColor(0x2E2E2E),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: safetyPinBottomView(context),
            );
          });
        }).whenComplete(() {});
  }

  //pin弹窗文案
  Widget safetyPinBottomView(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            'SafetyPinDialog'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10, top: 30),
                  child: InkWell(
                    onTap: () {
                      //取消
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 44,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel".tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20, top: 30),
                  child: InkWell(
                    onTap: () {
                      //跳转
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SafetyPinBuilder().scene));
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
        ],
      ),
    );
  }

  showDeleteAccountDiolog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 165),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return Container(
              decoration: BoxDecoration(
                  color: ColorsUtil.hexColor(0x2E2E2E),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: deleteAccountBottomView(context, mystate),
            );
          });
        }).whenComplete(() {});
  }

  ///是否确认更新邮箱 ///是否确认更新手机号 0-email 1-phone
  showUpdateEmailPhoneDiolog(BuildContext context, int type) {
    var title = '';
    var content = '';
    if (type == 0) {
      title = 'Confirm to update your email address?';
      content = 'Confirm update address note';
    } else {
      title = 'Confirm to update your phone number?';
      content = "Confirm update phone note";
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 234),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return Container(
              decoration: BoxDecoration(
                  color: ColorsUtil.hexColor(0x2E2E2E),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child:
                  _buildEmailPhoneDialogContent(context, type, title, content),
            );
          });
        }).whenComplete(() {});
  }

  Widget _buildEmailPhoneDialogContent(
      BuildContext context, int type, String title, String content) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              title.tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Text(
              content.tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
                  child: InkWell(
                    onTap: () {
                      //取消
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 44,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel".tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20, top: 10),
                  child: InkWell(
                    onTap: () {
                      //确认
                      Navigator.pop(context);
                      if (type == 0) {
                        //更新邮箱
                        if (UserInfo.shared.phone != "" &&
                            UserInfo.shared.email != "") {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UpdateEmailBuilder().scene));
                        } else {}
                      } else {
                        //更新手机号
                        if (UserInfo.shared.phone != "" &&
                            UserInfo.shared.email != "") {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UpdatePhoneBuilder().scene));
                        } else {}
                      }
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
        ],
      ),
    );
  }

  /// 检查是否有可用的生物识别技术
  Future<Null> _checkBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  //去识别
  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
          localizedReason: 'biometrics please'.tr(),
          options: const AuthenticationOptions(
              biometricOnly: true, useErrorDialogs: true, stickyAuth: true));
    } on PlatformException catch (e) {
      debugPrint("authenticate: $e");
      return false;
    }
  }

  //获取本地开关数据
  void getSwitchFlag() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    bool flag = perf.getBool("BiometricsFlag") ?? false;
    setState(() {
      _switchFlag = flag;
    });
  }

  //设置本地开关
  void setSwitchFlag(bool flag) async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    perf.setBool("BiometricsFlag", flag);
    setState(() {
      _switchFlag = flag;
    });
  }

  //设置不在打开app提示
  void setDonotTip() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    perf.setBool("first finger", true);
  }

  refreshKyc() async {
    await LoginCenter().fetchUserInfo();
    setState(() {});
  }
}

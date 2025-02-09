import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_lifecycle/flutter_page_lifecycle.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';
import 'package:ucardtemp/Data/UserInfo.dart';

import '../../../Common/Notification.dart';
import '../../../Common/NumberPlus.dart';
import '../../../Common/StreamCenter.dart';
import '../../../Data/AppStatus.dart';
import '../../../gen_a/A.dart';
import '../../../main.dart';
import '../Presenter/MinePresenter.dart';

class MineView extends StatelessWidget {
  final MinePresenter presenter;

  StreamController<int> langStream = StreamController.broadcast();
  AppTheme _theme = AppTheme.dark;

  MineView(this.presenter);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(
        builder: (context, theme) {
          _theme = theme;
          return PageLifecycle(
              stateChanged: (appear) {
                if (appear) {
                  if (UserInfo.shared.isLoggedin) {
                    LoginCenter().fetchUserInfo();
                    StreamCenter.shared.profileStreamController.add(0);
                  }
                }
              },
              child: StreamBuilder<int>(
                stream: StreamCenter.shared.profileStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == 2) {
                    //注销后发送消息
                    Future.delayed(const Duration(milliseconds: 1000)).then((value) => {
                      LoginPageNotification().dispatch(context),
                      //通知弹出弹窗
                      Future.delayed(const Duration(microseconds: 500))
                          .then((value) => {
                        StreamCenter.shared.refreshAllStreamController
                            .add({'type': 'deleteDialog'})
                      })
                    });
                  }
                  return Scaffold(
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      iconTheme: IconThemeData(
                        color: theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor, //修改颜色
                      ),
                      elevation: 0,
                      centerTitle: false,
                      toolbarHeight: 40,
                      backgroundColor: theme == AppTheme.light
                          ? AppStatus.shared.bgWhiteColor
                          : AppStatus.shared.bgBlackColor,
                      title: Text(
                        'Settings'.tr(),
                        style: TextStyle(
                            fontSize: 18,
                            color: theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor),
                      ),
                    ),
                    body: Container(
                      color: theme == AppTheme.light
                          ? AppStatus.shared.bgWhiteColor
                          : AppStatus.shared.bgBlackColor,
                      child: ListView(
                        children: [
                          _buildTopView(context, theme),
                          _buildGeneralView(context),
                          _buildSupportView(context),
                          _buildVersionView(),
                          _buildLoginOutView(context),
                        ],
                      ),
                    ),
                  );
                }
              )
          );

        });
  }

  //顶部
  Widget _buildTopView(BuildContext context, AppTheme theme) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 20),
      child: InkWell(
        onTap: () {
          if (UserInfo.shared.isLoggedin) {
            //安全设置
            presenter.accountSecrityPressed(context);
          } else {
            presenter.loginPressed(context);
          }
        },
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgGreyLightColor
                : AppStatus.shared.bgDarkGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: UserInfo.shared.isLoggedin
              ? _buildLoginedView(context, theme)
              : _buildUnLoginedView(context, theme),
        ),
      ),
    );
  }

  //已经登录
  Widget _buildLoginedView(BuildContext context, AppTheme theme) {
    String account = '';
    if (UserInfo.shared.email != "") {
      account = NumberPlus.getSecurityEmail(UserInfo.shared.email);
    } else if (UserInfo.shared.phone != "") {
      account = "+" + NumberPlus.getSecurityEmail(UserInfo.shared.phone);
    }
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Image.asset(A.assets_mine_profile_default),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          account,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor,
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Image.asset(theme == AppTheme.light
              ? A.assets_Group_39918
              : A.assets_mine_arrow_right),
        ),
      ],
    );
  }

  //未登录
  Widget _buildUnLoginedView(BuildContext context, AppTheme theme) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Image.asset(A.assets_mine_profile_default),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          'Login/Register'.tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor,
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Image.asset(_theme == AppTheme.light
              ? A.assets_Group_39918
              : A.assets_mine_arrow_right),
        ),
      ],
    );
  }

  //general
  Widget _buildGeneralView(BuildContext context) {
    presenter.getLangData(context);
    String kycStatus = UserInfo.shared.isKycVerified == 1
        ? "Verified".tr()
        : (UserInfo.shared.isKycVerified == 2
            ? "Verifying".tr()
            : (UserInfo.shared.isKycVerified == 3
                ? "Verify fail".tr()
                : "Not Verified".tr()));
    bool showKyc = (UserInfo.shared.isKycVerified == 1 ||
            UserInfo.shared.isKycVerified == 2 ||
            UserInfo.shared.isKycVerified == 3)
        ? false
        : true;
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppStatus.shared.textGreyColor,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgGreyLightColor
                  : AppStatus.shared.bgDarkGreyColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                InkWell(
                    onTap: () {
                      presenter.kycButtonPressed(context);
                    },
                    child: _buildCell(
                        context,
                        _theme == AppTheme.light
                            ? A.assets_Group_39916
                            : A.assets_mine_kyc_icon,
                        'KYC',
                        kycStatus,
                        showKyc)),
                InkWell(
                  onTap: () {
                    if (UserInfo.shared.isLoggedin) {
                      presenter.cardSettingButtonPressed(context);
                    } else {
                      presenter.loginPressed(context);
                    }
                  },
                  child: _buildCell(
                      context,
                      _theme == AppTheme.light
                          ? A.assets_Group_39917
                          : A.assets_card_setting_icon,
                      'Card settings',
                      '',
                      true),
                ),
                InkWell(
                  onTap: () {
                    if (UserInfo.shared.isLoggedin) {
                      presenter.safeChainButtonPressed(context);
                    } else {
                      presenter.loginPressed(context);
                    }
                  },
                  child: _buildCell(
                      context,
                      _theme == AppTheme.light
                          ? A.assets_Group_39919
                          : A.assets_mine_safechain,
                      'Safe Chain',
                      '',
                      true),
                ),
                InkWell(
                  onTap: () {
                    presenter.languageButtonPressed(context);
                  },
                  child: StreamBuilder<int>(
                      stream: langStream.stream,
                      builder: (context, snapshot) {
                        return _buildCell(
                            context,
                            _theme == AppTheme.light
                                ? A.assets_Group_39920
                                : A.assets_mine_language_icon,
                            'Language',
                            presenter.langStr,
                            true);
                      }),
                ),
                InkWell(
                  onTap: () {
                    presenter.lightModeButtonPressed(context);
                  },
                  child: StreamBuilder<int>(
                      stream: langStream.stream,
                      builder: (context, snapshot) {
                        return _buildCell(
                            context,
                            _theme == AppTheme.light
                                ? A.assets_Group_39920
                                : A.assets_mine_language_icon,
                            'Light Mode',
                            '',
                            true);
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Support
  Widget _buildSupportView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Support'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppStatus.shared.textGreyColor,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgGreyLightColor
                  : AppStatus.shared.bgDarkGreyColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                InkWell(
                    onTap: () {
                      presenter.helpCenterButtonPressed(context);
                    },
                    child: _buildCell(
                        context,
                        _theme == AppTheme.light
                            ? A.assets_Group_39921
                            : A.assets_mine_help_icon,
                        'Help center',
                        '',
                        true)),
                InkWell(
                  onTap: () {
                    presenter.contactusButtonPressed(context);
                  },
                  child: _buildCell(
                      context,
                      _theme == AppTheme.light
                          ? A.assets_Group_39922
                          : A.assets_mine_contact_icon,
                      'Contact us',
                      '',
                      true),
                ),
                InkWell(
                  onTap: () {
                    presenter.agreementButtonPressed(context);
                  },
                  child: _buildCell(
                      context,
                      _theme == AppTheme.light
                          ? A.assets_Group_39923
                          : A.assets_mine_service_icon,
                      'Service agreements',
                      '',
                      true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //版本号
  Widget _buildVersionView() {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Center(
        child: Text(
          'Version ${AppStatus.shared.versionNumber}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppStatus.shared.textGreyColor,
          ),
        ),
      ),
    );
  }

  //退出按钮
  Widget _buildLoginOutView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 16, right: 16),
      child: InkWell(
        onTap: () {
          if (UserInfo.shared.isLoggedin) {
            //退出登录时初始化一下消息
            UserInfo.shared.isUnread = false;
            StreamCenter.shared.unReadMsgStreamController.add(0);
            LoginCenter().signOut(tabbarIndex: 3);
          } else {
            presenter.loginPressed(context);
          }
        },
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppStatus.shared.bgDarkGreyColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              UserInfo.shared.isLoggedin ? 'Sign out'.tr() : 'Login'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: UserInfo.shared.isLoggedin
                    ? ColorsUtil.hexColor(0xE85A6C)
                    : AppStatus.shared.bgBlueColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //公共cell
  Widget _buildCell(BuildContext context, String imageStr, String name,
      String rightName, bool showArrow) {
    return Container(
      height: 52,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 18),
            child: Image.asset(imageStr),
          ),
          SizedBox(
            width: 18,
          ),
          Text(
            name.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Text(
              rightName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppStatus.shared.textGreyColor,
              ),
            ),
          ),
          Visibility(
              visible: !showArrow,
              child: Container(
                width: 10,
              )),
          Visibility(
            visible: showArrow,
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Image.asset(_theme == AppTheme.light
                  ? A.assets_Group_39918
                  : A.assets_mine_arrow_right),
            ),
          ),
        ],
      ),
    );
  }
}

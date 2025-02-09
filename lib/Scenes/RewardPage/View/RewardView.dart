import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_lifecycle/flutter_page_lifecycle.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ucardtemp/Scenes/RewardPage/Entity/MyawardsModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Common/ColorUtil.dart';
import '../../../Common/ShowMessage.dart';
import '../../../Common/StreamCenter.dart';
import '../../../Common/TextImageButton.dart';
import '../../../Data/AppStatus.dart';
import '../../../Data/UserInfo.dart';
import '../../../gen_a/A.dart';
import '../../../main.dart';
import '../Presenter/RewardPresenter.dart';

class RewardView extends StatelessWidget {
  final RewardPresenter presenter;

  RewardView(this.presenter);

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return PageLifecycle(
        stateChanged: (appear) {
          debugPrint("RewardView is ${appear ? "appeared" : "disappeared"}");
          if (appear) {
            presenter.getAwards();
            presenter.fetchMyawardsList();
          }
        },
        child: Scaffold(
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
              'My awards'.tr(),
              style: TextStyle(
                  fontSize: 18,
                  color: theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor),
            ),
          ),
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          body: StreamBuilder<int>(
            stream: StreamCenter.shared.rewardStreamController.stream,
            builder: (context, snapshot) {
              return Container(
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgWhiteColor
                    : AppStatus.shared.bgBlackColor,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Image.asset(A.assets_rewards_graphic),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _buildCopyBtn(context),
                        _buildInviteBtn(context),
                        _buildTotalView(context),
                        _buildInviteDataView(context),
                        _buildeToppedUpView(context),
                        _buildRecordListView(context),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  //复制
  Widget _buildCopyBtn(BuildContext context) {
    String mycode = presenter.awardModel?.my_code ?? "12345ABC";
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: mycode));
          showDialog(
              context: context,
              builder: (_) {
                return ShowMessage(2, 'Copy to Clipboard'.tr(),
                    styleType: 1, width: 257);
              });
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgGreyLightColor
                  : AppStatus.shared.bgDarkGreyColor,
              borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: TextImageButton(
              margin: 2,
              type: TextIconButtonType.imageRight,
              icon: Image.asset(A.assets_reward_copy),
              text: Text(
                mycode,
                style: TextStyle(
                    fontSize: 15, color: ColorsUtil.hexColor(0x579DFF)),
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: mycode));
                showDialog(
                    context: context,
                    builder: (_) {
                      return ShowMessage(2, 'Copy to Clipboard'.tr(),
                          styleType: 1, width: 257);
                    });
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser() async {
    /// 先判断是否可以launch url
    if (!await launchUrl(Uri.parse("http://card.uollar.io/download"),
        mode: LaunchMode.externalApplication)) {
      /// 如果可以则启动
      throw Exception('Could not launch');
    }
  }

  //邀请
  Widget _buildInviteBtn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: InkWell(
        onTap: () {
          // _launchInBrowser();
          // showAlertDialog(context, "Invite now".tr(),
          //     presenter.awardModel?.share ?? "", true);
          Share.share(presenter.awardModel?.share ?? "");
        },
        child: Container(
          height: 44,
          decoration: BoxDecoration(
              color: AppStatus.shared.bgBlueColor,
              borderRadius: BorderRadius.circular(22)),
          child: Center(
            child: Text(
              "Invite now".tr(),
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

  //邀请金额
  Widget _buildTotalView(BuildContext context) {
    String totalMoney = presenter.awardModel?.total_money ?? "0.00";
    String currency = (UserInfo.shared.email == AppStatus.shared.specialAccount)
        ? "USD"
        : presenter.awardModel?.currency ?? "USDT";
    String rate = presenter.awardModel?.awards_rate ?? "0.0%";

    int show_award = presenter.awardModel?.show_award ?? 0;

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 30),
      child: Container(
          child: Column(
        children: [
          Text(
            "Total awards".tr(),
            style:
                TextStyle(color: AppStatus.shared.textGreyColor, fontSize: 14),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "${totalMoney} ${currency}",
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 8,
          ),
          Visibility(
            visible: show_award == 1,
            child: Container(
              height: 24,
              width: 200,
              // margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgGreyLightColor
                      : AppStatus.shared.bgDarkGreyColor,
                  borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Text(
                  "Invitation rewards".tr() + "：${rate}",
                  style: TextStyle(
                    color: ColorsUtil.hexColor(0x579DFF),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  //邀请数据
  Widget _buildInviteDataView(BuildContext context) {
    int invited = presenter.awardModel?.invited ?? 0;
    int applied = presenter.awardModel?.applied ?? 0;
    return InkWell(
      onTap: () {
        presenter.referralsPressed(context);
      },
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Container(
          height: 82,
          decoration: BoxDecoration(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgGreyLightColor
                  : AppStatus.shared.bgDarkGreyColor,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Invited".tr(),
                      style: TextStyle(
                          color: AppStatus.shared.textGreyColor, fontSize: 14),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "$invited",
                      style: TextStyle(
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Container(
                  width: 1,
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Applied".tr(),
                      style: TextStyle(
                          color: AppStatus.shared.textGreyColor, fontSize: 14),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "$applied",
                      style: TextStyle(
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Topped up
  Widget _buildeToppedUpView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 20, right: 16),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextImageButton(
              margin: 4,
              type: TextIconButtonType.imageRight,
              icon: Image.asset(_theme == AppTheme.light
                  ? A.assets_info_black
                  : A.assets_reward_info),
              text: Text(
                'Topped up'.tr(),
                style: TextStyle(
                    fontSize: 15,
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgBlackColor
                        : AppStatus.shared.bgWhiteColor),
              ),
              onTap: () {
                showAlertDialog(context, "Invitation to Upgrade".tr(),
                    "Invitation note".tr(), false);
              },
            ),
            _buildProgressView(context),
          ],
        ),
      ),
    );
  }

  //进度
  Widget _buildProgressView(BuildContext context) {
    var lineWidth =
        (MediaQuery.of(context).size.width - 50 - 32 * 3 - 44 - 18) / 3.0 - 5;

    //计算进度条
    double blueLineWidth = 0;
    double total = MediaQuery.of(context).size.width - 50 - 20;
    double topped = (presenter.toppedNum).toDouble();
    double first = (presenter.firstNum).toDouble();
    double second = (presenter.secondNum).toDouble();
    double third = (presenter.thirdNum).toDouble();
    double forth = (presenter.forthNum).toDouble();
    //位置
    double position = 32 + lineWidth / 2;
    if (presenter.toppedNum == presenter.firstNum) {
      blueLineWidth = 0;
    } else if (presenter.toppedNum < presenter.secondNum) {
      blueLineWidth = lineWidth * (topped - first) / (second - first) + 32;
      position = 32 + lineWidth / 2;
    } else if (presenter.toppedNum == presenter.secondNum) {
      blueLineWidth = lineWidth + 32;
    } else if (presenter.toppedNum < presenter.thirdNum) {
      blueLineWidth = lineWidth * (topped - second) / (third - second) +
          32 * 2 +
          lineWidth +
          9;
      position = 32 * 2 + (lineWidth - 9) / 2 + lineWidth;
    } else if (presenter.toppedNum == presenter.thirdNum) {
      blueLineWidth = lineWidth * 2 + 32 * 2 + 18;
    } else if (presenter.toppedNum < presenter.forthNum) {
      blueLineWidth = lineWidth * (topped - third) / (forth - third) +
          32 * 3 +
          lineWidth * 2 +
          18;
      position = 32 * 3 + (lineWidth + 9) / 2 + lineWidth * 2;
    } else {
      blueLineWidth = total;
    }
    print(
        'total + ${total} + blueline + ${blueLineWidth} + topped + ${topped} + forth + ${forth}');
    return Padding(
      padding: EdgeInsets.only(left: 9, right: 9, top: 30),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 38),
            child: Container(
              color: AppStatus.shared.bgDarkGreyColor,
              height: 2,
              width: (MediaQuery.of(context).size.width - 50 - 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 38),
            child: Container(
              color: ColorsUtil.hexColor(0x579DFF),
              height: 2,
              width: blueLineWidth,
            ),
          ),
          Visibility(
            visible: (presenter.toppedNum != presenter.firstNum &&
                presenter.toppedNum != presenter.secondNum &&
                presenter.toppedNum != presenter.thirdNum &&
                presenter.toppedNum != presenter.forthNum),
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: position),
              child: Text(
                '${presenter.toppedNum}',
                style: TextStyle(
                    fontSize: 16, color: ColorsUtil.hexColor(0x579DFF)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    '${presenter.firstNum}',
                    style: TextStyle(
                        fontSize: (presenter.toppedNum == presenter.firstNum)
                            ? 16
                            : 12,
                        color: (presenter.toppedNum == presenter.firstNum)
                            ? ColorsUtil.hexColor(0x579DFF)
                            : _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor),
                  ),
                  SizedBox(
                    height: (presenter.toppedNum == presenter.firstNum) ? 4 : 8,
                  ),
                  Container(
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgGreyLightColor
                        : AppStatus.shared.bgBlackColor,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (presenter.toppedNum > presenter.firstNum)
                            ? Color.fromRGBO(136, 182, 231, 1)
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 2,
                          color: (presenter.toppedNum > presenter.firstNum)
                              ? ColorsUtil.hexColor(0x579DFF)
                              : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_topup_reward_black1
                            : A.assets_reward_topup1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Sliver'.tr(),
                    style: TextStyle(
                        fontSize: 12, color: AppStatus.shared.textGreyColor),
                  ),
                ],
              ),
              Container(
                width: lineWidth,
                // height: 2,
                // color: AppStatus.shared.bgDarkGreyColor,
              ),
              Column(
                children: [
                  Text(
                    '${presenter.secondNum}',
                    style: TextStyle(
                        fontSize: (presenter.toppedNum == presenter.secondNum)
                            ? 16
                            : 12,
                        color: (presenter.toppedNum == presenter.secondNum)
                            ? ColorsUtil.hexColor(0x579DFF)
                            : _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor),
                  ),
                  SizedBox(
                    height:
                        (presenter.toppedNum == presenter.secondNum) ? 4 : 8,
                  ),
                  Container(
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgGreyLightColor
                        : AppStatus.shared.bgBlackColor,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (presenter.toppedNum >= presenter.secondNum)
                            ? Color.fromRGBO(225, 199, 128, 1)
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 2,
                          color: (presenter.toppedNum >= presenter.secondNum)
                              ? ColorsUtil.hexColor(0x579DFF)
                              : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_topup_reward_black1
                            : A.assets_reward_topup1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Gold'.tr(),
                    style: TextStyle(
                        fontSize: 12, color: AppStatus.shared.textGreyColor),
                  ),
                ],
              ),
              Container(
                width: lineWidth,
                // height: 2,
                // color: AppStatus.shared.bgDarkGreyColor,
              ),
              Column(
                children: [
                  Text(
                    '${presenter.thirdNum}',
                    style: TextStyle(
                        fontSize: (presenter.toppedNum == presenter.thirdNum)
                            ? 16
                            : 12,
                        color: (presenter.toppedNum == presenter.thirdNum)
                            ? ColorsUtil.hexColor(0x579DFF)
                            : _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor),
                  ),
                  SizedBox(
                    height: (presenter.toppedNum == presenter.thirdNum) ? 4 : 8,
                  ),
                  Container(
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgGreyLightColor
                        : AppStatus.shared.bgBlackColor,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (presenter.toppedNum >= presenter.thirdNum)
                            ? Color.fromRGBO(196, 196, 196, 1)
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 2,
                          color: (presenter.toppedNum >= presenter.thirdNum)
                              ? ColorsUtil.hexColor(0x579DFF)
                              : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_topup_reward_black1
                            : A.assets_reward_topup1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Platinum'.tr(),
                    style: TextStyle(
                        fontSize: 12, color: AppStatus.shared.textGreyColor),
                  ),
                ],
              ),
              Container(
                width: lineWidth,
                // height: 2,
                // color: AppStatus.shared.bgDarkGreyColor,
              ),
              Column(
                children: [
                  Text(
                    '${presenter.forthNum}',
                    style: TextStyle(
                        fontSize: (presenter.toppedNum >= presenter.forthNum)
                            ? 16
                            : 12,
                        color: (presenter.toppedNum >= presenter.forthNum)
                            ? ColorsUtil.hexColor(0x579DFF)
                            : _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor),
                  ),
                  SizedBox(
                    height: (presenter.toppedNum >= presenter.forthNum) ? 0 : 2,
                  ),
                  Container(
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgGreyLightColor
                        : AppStatus.shared.bgBlackColor,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (presenter.toppedNum >= presenter.forthNum)
                            ? Color.fromRGBO(63, 78, 101, 1)
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          width: 2,
                          color: (presenter.toppedNum >= presenter.forthNum)
                              ? ColorsUtil.hexColor(0x579DFF)
                              : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_topup_reward_black2
                            : A.assets_reward_topup2),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Black'.tr(),
                    style: TextStyle(
                        fontSize: 12, color: AppStatus.shared.textGreyColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  //记录
  Widget _buildRecordListView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rewards'.tr(),
            style: TextStyle(
                fontSize: 16,
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
          SizedBox(
            height: 20,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: presenter.awardsList.length,
            itemBuilder: (context, index) {
              MyawardsModel model = presenter.awardsList[index];
              return GestureDetector(
                onTap: () {},
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(
                      left: 0, right: 16, top: 10, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(
                              model.user_name,
                              style: TextStyle(
                                  color: _theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              model.created_at,
                              style: TextStyle(
                                  color: AppStatus.shared.textGreyColor,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      //右边
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "+${model.money} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : model.currency}",
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  //弹窗
  showAlertDialog(
      BuildContext context, String title, String content, bool copy) {
    String buttonTitle = "OK".tr();
    showDialog(
      context: context,
      builder: (_) {
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: Container(
            // height: height,
            width: MediaQuery.of(context).size.width - 88,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorsUtil.hexColor(0x252525),
                ),
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Future.delayed(Duration(seconds: 0)).then((value) {
                          if (copy) {
                            Clipboard.setData(ClipboardData(
                                text: presenter.awardModel?.share ?? ""));
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return ShowMessage(
                                      2, 'Copy to Clipboard'.tr(),
                                      styleType: 1, width: 257);
                                });
                          }
                        });
                      },
                      child: Container(
                        height: 44,
                        width: MediaQuery.of(context).size.width - 88 - 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: AppStatus.shared.bgBlueColor,
                        ),
                        child: Center(
                          child: Text(
                            buttonTitle,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
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
      },
    );
  }
}

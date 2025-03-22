import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/UserInfo.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
import '../../Apply/Entity/CardInfoModel.dart';
import '../Presenter/UpgradePresenter.dart';

class UpgradeView extends StatelessWidget {
  final UpgradePresenter presenter;

  StreamController<int> streamController = StreamController.broadcast();
  StreamController<int> upgradeStreamController = StreamController.broadcast();

  ScrollController _scrollController = ScrollController();
  final TextEditingController _cardNameController =
      TextEditingController(text: '');

  UpgradeView(this.presenter);

  //当前选择的卡片等级
  int _currentPageIndex = 0;

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor, //修改颜色
          ),
          elevation: 0,
          title: Text(
            "Upgrade".tr(),
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
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
                          _buildPageIndexView(context),
                          SizedBox(
                            height: 17,
                          ),
                          _buildCardsView(context),
                          SizedBox(
                            height: 10,
                          ),
                          _buildCardNameView(context),
                          SizedBox(
                            height: 20,
                          ),
                          _buildCell(context, 0),
                          _buildCell(context, 1),
                          _buildCell(context, 2),
                          _buildCell(context, 3),
                          _buildCell(context, 4),
                          SizedBox(
                            height: 370,
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
    });
  }

  //指示器
  Widget _buildPageIndexView(BuildContext context) {
    if (presenter.configModels.length < 2) {
      return Container();
    }
    var lineWidth =
        MediaQuery.of(context).size.width / presenter.configModels.length;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(presenter.configModels.length, (i) {
          return Container(
            width: lineWidth,
            height: 2,
            decoration: BoxDecoration(
                color: _currentPageIndex == i
                    ? AppStatus.shared.bgBlueColor
                    : _theme == AppTheme.light
                        ? AppStatus.shared.bgGreyLightColor
                        : AppStatus.shared.bgDarkGreyColor),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCardsView(BuildContext context) {
    if (presenter.configModels.isEmpty) {
      return Container();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 190,
      child: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              _currentPageIndex = index;
              streamController.add(0);
            },
            scrollDirection: Axis.horizontal,
            children: presenter.configModels.map((element) {
              String cardBg = '';
              if (element.level == 1) {
                cardBg = A.assets_home_sliver_bg;
              } else if (element.level == 2) {
                cardBg = A.assets_home_gold_bg;
              } else if (element.level == 3) {
                cardBg = A.assets_home_platinum_bg;
              } else {
                cardBg = A.assets_home_black_bg;
              }
              return Center(
                child: Container(
                  child: Stack(
                    children: [
                      ClipRRect(
                          child: Image.asset(cardBg),
                          borderRadius: BorderRadius.circular(10)),
                      // Positioned(
                      //   child: Image.asset(A.assets_home_ucard_logo),
                      //   left: 20,
                      //   top: 18,
                      // ),
                      Positioned(
                        child:
                            Image.asset(presenter.cardModel.card_type == 'visa'
                                ? A.assets_home_visa_icon2
                                : presenter.cardModel.card_type == 'master'
                                    ? A.assets_home_master_icon2
                                    : A.assets_union_card),
                        right: 20,
                        bottom: 18,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardNameView(BuildContext context) {
    if (presenter.configModels.isEmpty) {
      return Container();
    }
    CardInfoModel m = presenter.configModels[_currentPageIndex];
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Center(
        child: Text(
          m.level_name,
          style: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor,
              fontWeight: FontWeight.w700,
              fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildCell(BuildContext context, int type) {
    if (presenter.configModels.isEmpty) {
      return Container();
    }
    CardInfoModel m = presenter.configModels[_currentPageIndex];
    String title = '';
    String content = '';
    if (type == 0) {
      title = 'Fee'.tr();
      content =
          '${m.recharge_fee} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : m.recharge_fee_unit}';
    } else if (type == 1) {
      title = 'Invitation Reward'.tr();
      content =
          '${m.recommend_fee} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : m.recommend_fee_unit}';
    } else if (type == 2) {
      title = 'Card limit (month)'.tr();
      content =
          '${m.month_limit} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : m.month_limit_unit}';
    } else if (type == 3) {
      title = 'Monthly fee'.tr();
      content =
          '${m.month_fee} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : m.month_fee_unit}';
    } else if (type == 4) {
      title = 'Upgrade fee'.tr();
      content =
          '${m.upgrade_fee} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : m.upgrade_fee_unit}';
    }
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Container(
        height: 37,
        width: MediaQuery.of(context).size.width - 32,
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              child: Image.asset(_theme == AppTheme.light
                  ? A.assets_question_black
                  : A.assets_apply_info),
              onTap: () {
                //
                if (type == 0) {
                  showAlertDialog(
                    context,
                    'Fee',
                    'Fee alert',
                  );
                } else if (type == 1) {
                  showAlertDialog(
                    context,
                    'Invitation reward',
                    'Invitation alert',
                  );
                } else if (type == 2) {
                  showAlertDialog(
                    context,
                    'Card limit (month)',
                    'Card limit alert',
                  );
                } else if (type == 3) {
                  showAlertDialog(
                    context,
                    'Monthly fee',
                    'Monthly fee alert',
                  );
                } else if (type == 4) {
                  showAlertDialog(
                    context,
                    'Upgrade fee',
                    'Upgrade fee alert',
                  );
                }
              },
            ),
            Spacer(),
            Text(
              content,
              style: TextStyle(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: InkWell(
        onTap: () {
          //
          showActivationConfirmationDiolog(context);
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
              "Apply".tr(),
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

  //弹窗
  showAlertDialog(BuildContext context, String title, String content) {
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
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : ColorsUtil.hexColor(0x252525),
                ),
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      content.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
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

  //申请弹窗
  showActivationConfirmationDiolog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 232),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context2, StateSetter mystate) {
            return Container(
              decoration: BoxDecoration(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : ColorsUtil.hexColor(0x2E2E2E),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: _buildContent(context),
            );
          });
        }).whenComplete(() {});
  }

  Widget _buildContent(BuildContext context) {
    String amout =
        "${presenter.walletModel?.balance ?? "0.0"} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : presenter.walletModel?.currency ?? "USDT"}";
    CardInfoModel m = presenter.configModels[_currentPageIndex];
    String upgradeFee =
        "-${m.upgrade_fee} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : m.upgrade_fee_unit}";
    return StreamBuilder<int>(
        stream: upgradeStreamController.stream,
        builder: (context, snapshot) {
          return Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Upgrade Confirmation'.tr(),
                    style: TextStyle(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Balance'.tr(),
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Text(
                            amout,
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Upgrade fee'.tr(),
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Text(
                            upgradeFee,
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 10, top: 30),
                        child: InkWell(
                          onTap: () {
                            //取消
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 44,
                            width: 100,
                            decoration: BoxDecoration(
                              color: (presenter.upgrading)
                                  ? _theme == AppTheme.light
                                      ? AppStatus.shared.bgGreyLightColor
                                      : ColorsUtil.hexColor(0x1a1a1a)
                                  : _theme == AppTheme.light
                                      ? AppStatus.shared.bgGreyLightColor
                                      : AppStatus.shared.bgDarkGreyColor,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Center(
                              child: Text(
                                "Cancel".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: (presenter.upgrading)
                                        ? AppStatus.shared.textGreyColor
                                        : _theme == AppTheme.light
                                            ? AppStatus.shared.bgBlackColor
                                            : AppStatus.shared.bgWhiteColor,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 20, top: 30),
                        child: InkWell(
                          onTap: () {
                            if (presenter.upgrading) {
                              return;
                            }
                            presenter.upgrading = true;
                            upgradeStreamController.add(0);
                            //升级
                            // Navigator.pop(context);
                            presenter.applyConfirmPressed(context, m.level);
                          },
                          child: Container(
                            height: 44,
                            width: 100,
                            decoration: BoxDecoration(
                              color: (presenter.upgrading)
                                  ? ColorsUtil.hexColor(0x1241a5)
                                  : AppStatus.shared.bgBlueColor,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Center(
                              child: Text(
                                "Confirm".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: (presenter.upgrading)
                                        ? ColorsUtil.hexColor(0x88a0d2)
                                        : Colors.white,
                                    fontSize: 14),
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
        });
  }
}

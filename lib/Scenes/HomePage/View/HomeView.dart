import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_lifecycle/flutter_page_lifecycle.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';
import 'package:ucardtemp/Common/DatePicker/date_picker_theme.dart';
import 'package:ucardtemp/Data/AppStatus.dart';
import 'package:ucardtemp/Scenes/HomePage/Entity/MycardsModel.dart';
import 'package:ucardtemp/Scenes/HomePage/Entity/SettlementModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../Common/DatePicker/date_picker.dart';
import '../../../Common/ShowMessage.dart';
import '../../../Common/StreamCenter.dart';
import '../../../Common/TextImageButton.dart';
import '../../../Data/UserInfo.dart';
import '../../../gen_a/A.dart';
import '../../../main.dart';
import '../Presenter/HomePresenter.dart';
import 'package:badges/badges.dart' as badges;

class HomeView extends StatelessWidget {
  final HomePresenter presenter;
  HomeView(this.presenter);

  //是否显示金额
  bool showMoney = true;
  //是否显示卡信息
  bool showCardInfo = false;
  //当前选择的卡片
  int _currentPageIndex = 0;
  //翻转卡片
  FlipCardController _controller = FlipCardController();
  PageController _pageController1 = PageController();
  PageController _pageController2 = PageController();

  StreamController<int> streamController = StreamController.broadcast();

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return PageLifecycle(
        stateChanged: (appear) {
          if (appear) {
            presenter.fetchMycardsList();
            debugPrint('调用了==================');
            presenter.searchUnReadMsg();
          } else {
            showCardInfo = false;
            if (_currentPageIndex != 0) {
              _currentPageIndex = 0;
              presenter.settleMentList.clear();
            }
            StreamCenter.shared.homeStreamController.add(0);
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
              'My cards'.tr(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor),
            ),
            actions: [
              StreamBuilder<int>(
                stream: StreamCenter.shared.homeStreamController.stream,
                builder: (context, snapshot) {
                  return Visibility(
                    visible: UserInfo.shared.isLoggedin,
                    child: Container(
                      height: 30,
                      width: 40,
                      child: TextButton(
                        onPressed: () {
                          //
                          showMoney = !showMoney;
                          StreamCenter.shared.homeStreamController.add(0);
                        },
                        child: Image.asset(showMoney
                            ? theme == AppTheme.light
                                ? A.assets_unvisible_black
                                : A.assets_home_visible_close
                            : theme == AppTheme.light
                                ? A.assets_visible_black
                                : A.assets_home_visible_open),
                      ),
                    ),
                  );
                },
              ),
              StreamBuilder<int>(
                stream: StreamCenter.shared.unReadMsgStreamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Container(
                    // color: Colors.red,
                    height: 30,
                    width: 40,
                    child: TextButton(
                      onPressed: () {
                        //
                        presenter.notificationButtonPressed(context);
                      },
                      child: badges.Badge(
                        position: badges.BadgePosition.topEnd(
                          top: 0,
                          end: 0,
                        ),
                        // padding: EdgeInsets.all(3),
                        showBadge: UserInfo.shared.isUnread,
                        // toAnimate: false,
                        child: Image.asset(
                          theme == AppTheme.light
                              ? A.assets_Group_40089
                              : A.assets_home_notice,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
          body: StreamBuilder<int>(
            stream: StreamCenter.shared.homeStreamController.stream,
            builder: (context, snapshot) {
              if (UserInfo.shared.isLoggedin) {
                presenter.searchUnReadMsg();
              }
              return Container(
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgWhiteColor
                    : AppStatus.shared.bgBlackColor,
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildPageIndexView(context),
                      Container(
                        height: 17,
                      ),
                      _buildCardView(context),
                      _buildBtnRow(context),
                      // _buildBillRow(context),
                      // (UserInfo.shared.isLoggedin &&
                      //         presenter.settleMentList.isNotEmpty)
                      //     ? _buildBillListView(context)
                      //     : _buildNodataView(context),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  updateCardData() {
    _currentPageIndex = 0;
    if (presenter.models.isNotEmpty && presenter.models.length > 1) {
      debugPrint("ddddsssss==========");
      _pageController1.jumpToPage(0);
    }
    StreamCenter.shared.homeStreamController.add(0);
  }

  //指示器
  Widget _buildPageIndexView(BuildContext context) {
    if (presenter.models.length < 2) {
      return Container();
    }
    var lineWidth = MediaQuery.of(context).size.width / presenter.models.length;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(presenter.models.length, (i) {
          return Container(
            width: lineWidth,
            height: 2,
            decoration: BoxDecoration(
                color: _currentPageIndex == i
                    ? AppStatus.shared.bgBlueColor
                    : AppStatus.shared.bgDarkGreyColor),
          );
        }).toList(),
      ),
    );
  }

  //轮播卡片
  Widget _buildCardView(BuildContext context) {
    if (!UserInfo.shared.isLoggedin) {
      return Container(
        height: 184.0 / 327 * (MediaQuery.of(context).size.width - 40),
        width: (MediaQuery.of(context).size.width - 40),
        child: Stack(
          children: [
            Container(
              child: Center(
                child: Stack(
                  children: [
                    ClipRRect(
                        child: Image.asset(
                          A.assets_home_sliver_bg,
                          width: (MediaQuery.of(context).size.width - 40),
                          height: 184.0 /
                              327 *
                              (MediaQuery.of(context).size.width - 40),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    // Positioned(
                    //   child: Image.asset(A.assets_home_ucard_logo),
                    //   left: 20,
                    //   top: 18,
                    // ),
                    Positioned(
                      left: 24,
                      top: 184.0 /
                              327 *
                              (MediaQuery.of(context).size.width - 40) /
                              2 -
                          33.0 / 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(33.0 / 2),
                        child: InkWell(
                          onTap: () {
                            presenter.loginPressed(context);
                          },
                          child: Container(
                            width: 85,
                            height: 33,
                            color: ColorsUtil.hexColor(0xffffff, alpha: 0.16),
                            child: Center(
                              child: Text(
                                'Login'.tr(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (presenter.models.isEmpty) {
      return _emptyCardView(context);
    }
    return FlipCard(
      controller: _controller,
      flipOnTouch: false,
      front: _buildFrontView(context),
      back: _buildBackView(context),
    );
  }

  Widget _emptyCardView(BuildContext context) {
    return Container(
      height: 184.0 / 327 * (MediaQuery.of(context).size.width - 40),
      width: (MediaQuery.of(context).size.width - 40),
      child: Stack(
        children: [
          Container(
            child: Center(
              child: Stack(
                children: [
                  ClipRRect(
                      child: Image.asset(
                        A.assets_home_sliver_bg,
                        width: (MediaQuery.of(context).size.width - 40),
                        height: 184.0 /
                            327 *
                            (MediaQuery.of(context).size.width - 40),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  // Positioned(
                  //   child: Image.asset(A.assets_home_ucard_logo),
                  //   left: 20,
                  //   top: 18,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontView(BuildContext context) {
    // if (presenter.models.isEmpty) {
    //   _pageController1.jumpTo(0);
    //   return Container();
    // }
    return Container(
      height: 184.0 / 327 * (MediaQuery.of(context).size.width - 40),
      width: (MediaQuery.of(context).size.width),
      child: Stack(
        children: [
          PageView.builder(
            itemCount: presenter.models.length,
            controller: _pageController1,
            onPageChanged: (index) {
              _currentPageIndex = index;
              _pageController2.jumpToPage(index);
              MycardsModel m = presenter.models[_currentPageIndex];
              DateFormat dateFormat = DateFormat("yyyy-MM");
              String dateTime = dateFormat.format(presenter.selectTime);
              presenter.fetchMysettlementList(m.card_order, dateTime, 1);
              StreamCenter.shared.homeStreamController.add(0);
            },
            scrollDirection: Axis.horizontal,
            itemBuilder: (context1, index) {
              if (presenter.models.isEmpty) {
                return _emptyCardView(context);
              }
              MycardsModel element = presenter.models[index];
              String cardBg = '';
              String cardNo = element.card_no;
              if (cardNo.isEmpty) {
                cardNo = '';
              }
              if (element.level == 1) {
                cardBg = A.assets_home_first_card_bg;
              } else if (element.level == 2) {
                cardBg = A.assets_home_second_card_bg;
              } else if (element.level == 3) {
                cardBg = A.assets_home_third_card_bg;
              } else {
                cardBg = A.assets_home_forth_card_bg;
              }

              return Center(
                child: Container(
                  child: Stack(
                    children: [
                      ClipRRect(
                          child: element.img_card_bg.isNotEmpty ? Image.network(element.img_card_bg,width: (MediaQuery.of(context).size.width - 40),
                            height: 184.0 /
                                327 *
                                (MediaQuery.of(context).size.width - 40),
                            fit: BoxFit.fill,) : Image.asset(
                            cardBg,
                            width: (MediaQuery.of(context).size.width - 40),
                            height: 184.0 /
                                327 *
                                (MediaQuery.of(context).size.width - 40),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      Positioned(
                        child: Image.asset(A.assets_home_ucard_logo),
                        right: 20,
                        top: 18,
                      ),
                      Visibility(
                        visible: element.img_left_top.isNotEmpty,
                        child: Positioned(
                          child: Image.network(element.img_left_top),
                          left: 20,
                          top: 18,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Visibility(
                        visible: element.img_card_center.isNotEmpty,
                        child: Positioned(
                          child: Image.network(element.img_card_center),
                          top: 45,
                          left: (MediaQuery.of(context).size.width - 136) / 2,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Visibility(
                        visible: showMoney,
                        child: Positioned(
                          left: 20,
                          top: 190 / 2 - 10,
                          child: Text(
                            '\$ ${element.balance}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Row(
                          children: [
                            Visibility(visible: element.img_left_bottom.isNotEmpty,child: Image.network(element.img_left_bottom, width: 40,
                              height: 40,),),
                            SizedBox(width: element.img_left_bottom.isNotEmpty ? 10 : 0,),
                            Visibility(
                              visible: element.hide_name == 0,
                              child: Text(
                                element.card_name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        left: 20,
                        bottom: 22,
                      ),
                      Positioned(
                        child: Image.asset(element.card_type == 'master'
                            ? A.assets_home_master_icon2
                            : A.assets_home_visa_icon2),
                        right: 20,
                        bottom: 18,
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

  Widget _buildBackView(BuildContext context) {
    // if (presenter.models.isEmpty) {
    //   _pageController2.jumpTo(0);
    //   return Container();
    // }
    return Container(
      height: 184.0 / 327 * (MediaQuery.of(context).size.width - 40),
      width: (MediaQuery.of(context).size.width - 40),
      child: Stack(
        children: [
          PageView.builder(
            itemCount: presenter.models.length,
            controller: _pageController2,
            onPageChanged: (index) {
              _currentPageIndex = index;
              _pageController1.jumpToPage(index);
              MycardsModel m = presenter.models[_currentPageIndex];
              DateFormat dateFormat = DateFormat("yyyy-MM");
              String dateTime = dateFormat.format(presenter.selectTime);
              presenter.fetchMysettlementList(m.card_order, dateTime, 1);
              StreamCenter.shared.homeStreamController.add(0);
            },
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (presenter.models.isEmpty) {
                return _emptyCardView(context);
              }
              MycardsModel element = presenter.models[index];
              String cardBg = '';
              String cardNo = element.card_no;
              if (cardNo.isEmpty) {
                cardNo = '';
              }
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
                          child: Image.asset(
                            cardBg,
                            width: (MediaQuery.of(context).size.width - 40),
                            height: 184.0 /
                                327 *
                                (MediaQuery.of(context).size.width - 40),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      // Positioned(
                      //   child: Image.asset(A.assets_home_ucard_logo),
                      //   left: 20,
                      //   top: 18,
                      // ),

                      //当前的卡信息
                      Positioned(
                        left: 20,
                        top: 190 / 2 - 10,
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: cardNo));
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return ShowMessage(
                                      2, 'Copy to Clipboard'.tr(),
                                      styleType: 1, width: 257);
                                });
                          },
                          child: Row(
                            children: [
                              Text(
                                AppStatus.shared.meet4AddBlank(cardNo),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Visibility(
                                  visible: cardNo.isNotEmpty,
                                  child:
                                      Image.asset(A.assets_mine_contact_copy)),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (element.expiry_date.isNotEmpty),
                        child: Positioned(
                          left: 20,
                          bottom: 20,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expiry Date'.tr(),
                                    style: TextStyle(
                                        color: ColorsUtil.hexColor(0xffffff,
                                            alpha: 0.8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "${element.expiry_month}/${element.expiry_year}",
                                    style: TextStyle(
                                        color: ColorsUtil.hexColor(0xffffff,
                                            alpha: 1),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 48,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    element.card_type == 'master'
                                        ? 'CVC2'
                                        : "CVV2",
                                    style: TextStyle(
                                        color: ColorsUtil.hexColor(0xffffff,
                                            alpha: 0.8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "${element.card_cvv}",
                                    style: TextStyle(
                                        color: ColorsUtil.hexColor(0xffffff,
                                            alpha: 1),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        child: Image.asset(element.card_type == 'master'
                            ? A.assets_home_master_icon2
                            : A.assets_home_visa_icon2),
                        right: 20,
                        bottom: 18,
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

  //按钮
  Widget _buildBtnRow(BuildContext context) {
    var isPhysialCard = true;
    var width = (MediaQuery.of(context).size.width - 20) / 4;
    if (width < 50) {
      width = 70;
    }
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 32, bottom: 14),
      child: Wrap(
        spacing: 0,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: [
          SizedBox(
            width: width,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : AppStatus.shared.bgBlackColor,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 3, right: 3)),
              onPressed: () {
                presenter.applyButtonPressed(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgGreyLightColor
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(24)),
                    child: Center(
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_apply_black
                            : A.assets_home_apply)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      "Apply".tr(),
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 11,
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: width,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : AppStatus.shared.bgBlackColor,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 3, right: 3)),
              onPressed: () {
                //
                if (presenter.models.isNotEmpty) {
                  MycardsModel item = presenter.models[_currentPageIndex];
                  presenter.topupButtonPressed(context, item);
                } else {
                  //请先申请卡片
                  if (UserInfo.shared.isLoggedin) {
                    showTopError(context, 'Please apply card');
                  } else {
                    presenter.loginPressed(context);
                  }
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgGreyLightColor
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(24)),
                    child: Center(
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_topup_black
                            : A.assets_home_topup)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      "Top-up".tr(),
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 11,
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: width,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : AppStatus.shared.bgBlackColor,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 3, right: 3)),
              onPressed: () {
                if (presenter.models.isNotEmpty) {
                  MycardsModel item = presenter.models[_currentPageIndex];
                  if (item.level == 4) {
                    showTopError(context, 'No need');
                  } else {
                    presenter.upgradeButtonPressed(context, item);
                  }
                } else {
                  //请先申请卡片
                  if (UserInfo.shared.isLoggedin) {
                    showTopError(context, 'Please apply card');
                  } else {
                    presenter.loginPressed(context);
                  }
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgGreyLightColor
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(24)),
                    child: Center(
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_update_black
                            : A.assets_home_upgrade)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      "Upgrade".tr(),
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 11,
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: width,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : AppStatus.shared.bgBlackColor,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 3, right: 3)),
              onPressed: () {
                if (UserInfo.shared.isLoggedin) {
                  if (presenter.models.isNotEmpty) {
                    showCardInfo = !showCardInfo;
                    _controller.toggleCard();
                    if (showCardInfo) {
                      Future.delayed(const Duration(seconds: 30)).then((value) {
                        if (showCardInfo) {
                          _controller.toggleCard();
                          showCardInfo = !showCardInfo;
                        }
                      });
                    }
                  } else {
                    //请先申请卡片
                    showTopError(context, 'Please apply card');
                  }
                } else {
                  presenter.loginPressed(context);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgGreyLightColor
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(24)),
                    child: Center(
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_safecode_black
                            : A.assets_home_detail)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      "Detail".tr(),
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 11,
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: width,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : AppStatus.shared.bgBlackColor,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 3, right: 3)),
              onPressed: () {
                if (UserInfo.shared.isLoggedin) {
                  if (presenter.models.isNotEmpty) {
                    //
                  } else {
                    //请先申请卡片
                    showTopError(context, 'Please apply card');
                  }
                } else {
                  presenter.loginPressed(context);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgGreyLightColor
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(24)),
                    child: Center(
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_transfer_icon
                            : A.assets_transfer_icon)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      "Transfer".tr(),
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 11,
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: width,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : AppStatus.shared.bgBlackColor,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 3, right: 3)),
              onPressed: () {
                presenter.applyButtonPressed(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgGreyLightColor
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(24)),
                    child: Center(
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_freeze_icon
                            : A.assets_freeze_icon)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      "Freeze".tr(),
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 11,
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: width,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : AppStatus.shared.bgBlackColor,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 3, right: 3)),
              onPressed: () {
                presenter.applyButtonPressed(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgGreyLightColor
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(24)),
                    child: Center(
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_modify_icon
                            : A.assets_modify_icon)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      "Modify Pin".tr(),
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 11,
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: width,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : AppStatus.shared.bgBlackColor,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 3, right: 3)),
              onPressed: () {
                presenter.gotoBillPage(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgGreyLightColor
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(24)),
                    child: Center(
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_bill_icon
                            : A.assets_bill_icon)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      "Bill".tr(),
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 11,
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //账单
  Widget _buildBillRow(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy-MM");
    String dateTime = dateFormat.format(presenter.selectTime);
    return Container(
      margin: EdgeInsets.only(left: 15, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bill'.tr(),
            style: TextStyle(
                fontSize: 16,
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontWeight: FontWeight.w500),
          ),
          Container(
            width: 107,
            height: 32,
            decoration: BoxDecoration(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgGreyLightColor
                    : AppStatus.shared.bgDarkGreyColor,
                borderRadius: BorderRadius.circular(16)),
            child: Center(
              child: TextImageButton(
                margin: 2,
                type: TextIconButtonType.imageRight,
                icon: Image.asset(_theme == AppTheme.light
                    ? A.assets_Polygon_1
                    : A.assets_home_bill_arrow),
                text: Text(
                  dateTime,
                  style: TextStyle(
                      fontSize: 15,
                      color: _theme == AppTheme.light
                          ? AppStatus.shared.bgBlackColor
                          : AppStatus.shared.bgWhiteColor),
                ),
                onTap: () {
    if (UserInfo.shared.isLoggedin) {
      showDateDiolog(context);
    }else{
      presenter.loginPressed(context);
    }

                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //账单列表
  Widget _buildBillListView(BuildContext context) {
    MycardsModel m = presenter.models[_currentPageIndex];
    return Expanded(
      child: EasyRefresh(
        header: MaterialHeader(),
        footer: MaterialFooter(),
        onRefresh: () async {
          await presenter.getSettlementData(m);
        },
        onLoad: () {
          presenter.getSettlementMoreData(m);
          if (!presenter.hasMore) {
            return IndicatorResult.noMore;
          }
        },
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              // scrollDirection: Axis.horizontal,
              itemCount: presenter.settleMentList.length,
              itemBuilder: (context, index) {
                SettlementModel item = presenter.settleMentList[index];
                var billAmt = "";
                var transAmt = "";
                var rightContent = "";
                if (item.isCredit == "1") {
                  //@account
                  if (UserInfo.shared.email == AppStatus.shared.specialAccount) {
                    billAmt = "+${item.billCurrencyAmt} USD";
                    transAmt = "+${item.transCurrencyAmt} USD";
                  } else {
                    billAmt = "+${item.billCurrencyAmt} ${item.billCurrency}";
                    transAmt = "+${item.transCurrencyAmt} ${item.transCurrency}";
                  }
                  rightContent = "Permission".tr();
                } else {
                  //@account
                  if (UserInfo.shared.email == AppStatus.shared.specialAccount) {
                    billAmt = "-${item.billCurrencyAmt} USD";
                    transAmt = "-${item.transCurrencyAmt} USD";
                  } else {
                    billAmt = "-${item.billCurrencyAmt} ${item.billCurrency}";
                    transAmt = "-${item.transCurrencyAmt} ${item.transCurrency}";
                  }

                  rightContent = "Consumption".tr();
                }
                double bot =
                    (presenter.settleMentList.length == index - 1) ? 20.0 : 0.0;
                return InkWell(
                  onTap: () {
                    //
                    presenter.detailButtonPressed(context, item);
                  },
                  child: Container(
                    height: 80,
                    margin:
                        EdgeInsets.only(left: 15, right: 15, top: 20, bottom: bot),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                item.merchantName,
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
                                billAmt,
                                style: TextStyle(
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : AppStatus.shared.bgWhiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                transAmt,
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
                              rightContent,
                              style: TextStyle(
                                  color: _theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              item.settleDate,
                              style: TextStyle(
                                  color: AppStatus.shared.textGreyColor,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            InkWell(
              onTap: () async {
                MycardsModel m = presenter.models[_currentPageIndex];
                DateFormat dateFormat = DateFormat("yyyy-MM");
                String dateTime = dateFormat.format(presenter.selectTime);
                String url = await presenter.downPressed(m.card_order, dateTime, presenter.currentPage);
                print("url is ${url}");
                launchUrlString(url, mode: LaunchMode.externalApplication);
              },
              child: Container(
                height: 44,
                width: 150,
                decoration: BoxDecoration(
                  color: AppStatus.shared.bgBlueColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text("Download Bill".tr(), style: TextStyle(color: AppStatus.shared.bgWhiteColor),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //日期弹窗
  showDateDiolog(BuildContext context) {
    DatePicker.showDatePicker(context,
        minDateTime: DateTime(2021, 1, 01),
        maxDateTime: DateTime.now(),
        dateFormat: "yyyy-MM",
        initialDateTime: presenter.selectTime,
        pickerMode: DateTimePickerMode.date,
        pickerTheme: DateTimePickerTheme(
          backgroundColor: _theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : ColorsUtil.hexColor(0x252525),
          confirmTextStyle: TextStyle(
              color: AppStatus.shared.bgWhiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w500),
          titleHeight: 44,
          pickerHeight: 217,
          itemTextStyle: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ), onConfirm: (date, list) {
      debugPrint('select time $date, $list');
      presenter.selectTime = date;
      StreamCenter.shared.homeStreamController.add(0);
      MycardsModel m = presenter.models[_currentPageIndex];
      presenter.getSettlementData(m);
    });
    return;
  }

  Widget _buildNodataView(BuildContext context) {
    return Container(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(A.assets_ucard_nodata),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "No data  ".tr(),
              style: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  showTopError(BuildContext context, String err) {
    // AlertController.show("Fail".tr(), err.tr(), TypeAlert.error,);
    showDialog(
        context: context,
        builder: (_) {
          return ShowMessage(2, err.tr(), styleType: 1, width: 257);
        });
  }
}

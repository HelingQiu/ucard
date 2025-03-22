import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_lifecycle/flutter_page_lifecycle.dart';
import 'package:pinput/pinput.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';
import 'package:ucardtemp/Common/DatePicker/date_picker_theme.dart';
import 'package:ucardtemp/Data/AppStatus.dart';
import 'package:ucardtemp/Scenes/HomePage/Entity/MycardsModel.dart';
import 'package:ucardtemp/Scenes/HomePage/Entity/SettlementModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../Common/CustomWidget.dart';
import '../../../Common/DatePicker/date_picker.dart';
import '../../../Common/NumberPlus.dart';
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

  StreamController<int> safetyController = StreamController.broadcast();
  final TextEditingController _safetyPinCodeController =
      TextEditingController(text: '');
  final _safetyPinfocusNode = FocusNode();
  String _safetyPinCode = "";

  bool isSent = false;
  final TextEditingController _emailCodeController =
      TextEditingController(text: '');
  final _emailfocusNode = FocusNode();
  String _emailCode = "";

  final ValueNotifier<bool> _sendCodeSuccess = ValueNotifier<bool>(false);

  ScrollController _safeScroController = ScrollController();

  ScrollController _modifyScroController = ScrollController();
  final TextEditingController _oldPasswordController =
      TextEditingController(text: '');
  final TextEditingController _newPasswordController =
      TextEditingController(text: '');
  final TextEditingController _confirmPasswordController =
      TextEditingController(text: '');

  ScrollController _transferScroController = ScrollController();
  final TextEditingController _cardNumberController =
      TextEditingController(text: '');
  final TextEditingController _amountController =
      TextEditingController(text: '');

  StreamController<int> cardNumController = StreamController.broadcast();

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
              // presenter.settleMentList.clear();
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
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Image.asset(
                          A.assets_cloud,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Positioned(
                        left: -120,
                        right: 0,
                        bottom: -140,
                        child: Image.asset(
                          A.assets_piggybank,
                        ),
                      ),
                      Column(
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
                          // Spacer(),
                          // Stack(
                          //   children: [
                          //
                          //     Image.asset(A.assets_piggybank),
                          //   ],
                          // ),
                        ],
                      ),
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
      if (_pageController1.positions.isNotEmpty) {
        _pageController1.jumpToPage(0);
      }
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
                          A.assets_phycial_card_bg,
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
    return InkWell(
      onTap: () {
        showCardInfo = !showCardInfo;
        _controller.toggleCard();
        if (showCardInfo) {
          Future.delayed(const Duration(seconds: 30)).then((value) {
            if (showCardInfo) {
              _controller.toggleCard();
              showCardInfo = !showCardInfo;
              presenter.showCardNum = false;
            }
          });
        }
      },
      child: FlipCard(
        controller: _controller,
        flipOnTouch: false,
        front: _buildFrontView(context),
        back: _buildBackView(context),
      ),
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
                        A.assets_phycial_card_bg,
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
              presenter.showCardNum = false;
              // MycardsModel m = presenter.models[_currentPageIndex];
              // DateFormat dateFormat = DateFormat("yyyy-MM");
              // String dateTime = dateFormat.format(presenter.selectTime);
              // presenter.fetchMysettlementList(m.card_order, dateTime, 1);
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
              if (element.service == 2) {
                cardBg = A.assets_phycial_card_bg;
              } else if (element.service == 3) {
                cardBg = A.assets_phycial_card_bg;
              }
              debugPrint("home imagebg is ${element.img_card_bg}");
              String statusStr = "";
              if (element.status == "WA") {
                statusStr = "Under review".tr();
              } else if (element.status == "WS") {
                statusStr = "To be mailed".tr();
              } else if (element.status == "P") {
                statusStr = "No card printed".tr();
              } else if (element.status == "E") {
                statusStr = "Unsold".tr();
              } else if (element.status == "N") {
                statusStr = "Not activated".tr();
              } else if (element.status == "A") {
                statusStr = "Activated".tr();
              } else if (element.status == "X") {
                statusStr = "Expired".tr();
              } else if (element.status == "T") {
                statusStr = "Switched to another card".tr();
              } else if (element.status == "K") {
                statusStr = "Report loss verbally".tr();
              } else if (element.status == "L") {
                statusStr = "Formal report of loss".tr();
              } else if (element.status == "R") {
                statusStr = "Card returned".tr();
              } else if (element.hold_status == "H") {
                statusStr = "Free".tr();
              }
              debugPrint(
                  "status is $statusStr serviec is ${element.service} card name is ${element.card_name}");
              return Center(
                child: Container(
                  child: Stack(
                    children: [
                      ClipRRect(
                          child: element.img_card_bg.isNotEmpty
                              ? Image.network(
                                  element.img_card_bg,
                                  width:
                                      (MediaQuery.of(context).size.width - 40),
                                  height: 184.0 /
                                      327 *
                                      (MediaQuery.of(context).size.width - 40),
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  cardBg,
                                  width:
                                      (MediaQuery.of(context).size.width - 40),
                                  height: 184.0 /
                                      327 *
                                      (MediaQuery.of(context).size.width - 40),
                                  fit: BoxFit.fill,
                                ),
                          borderRadius: BorderRadius.circular(10)),
                      Visibility(
                        visible: element.service == 1,
                        child: Positioned(
                          child: Text(
                            "UOK",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          left: 20,
                          top: 18,
                        ),
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
                            element.service == 1
                                ? '\$ ${element.balance}'
                                : '${element.currency} ${element.balance}',
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
                            Visibility(
                              visible: element.img_left_bottom.isNotEmpty,
                              child: Image.network(
                                element.img_left_bottom,
                                width: 40,
                                height: 40,
                              ),
                            ),
                            SizedBox(
                              width:
                                  element.img_left_bottom.isNotEmpty ? 10 : 0,
                            ),
                            Visibility(
                              visible: element.hide_name == 0 &&
                                  element.service == 1,
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
                      Visibility(
                        visible: element.service == 2 || element.service == 3,
                        child: Positioned(
                          left: 20,
                          bottom: 20,
                          child: Text(
                            statusStr,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Image.asset(element.card_type == 'visa'
                            ? A.assets_home_visa_icon2
                            : element.card_type == 'master'
                                ? A.assets_home_master_icon2
                                : A.assets_union_card),
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
              // presenter.fetchMysettlementList(m.card_order, dateTime, 1);
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
                cardBg = A.assets_home_first_card_bg;
              } else if (element.level == 2) {
                cardBg = A.assets_home_second_card_bg;
              } else if (element.level == 3) {
                cardBg = A.assets_home_third_card_bg;
              } else {
                cardBg = A.assets_home_forth_card_bg;
              }
              if (element.service == 2) {
                cardBg = A.assets_phycial_card_bg;
              } else if (element.service == 3) {
                cardBg = A.assets_phycial_card_bg;
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
                      Visibility(
                        visible: element.service == 1,
                        child: Positioned(
                          child: Text(
                            "UOK",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          left: 20,
                          top: 18,
                        ),
                      ),

                      //当前的卡信息
                      Positioned(
                        left: 20,
                        top: 190 / 2 - 10,
                        child: StreamBuilder<int>(
                            stream: cardNumController.stream,
                            builder: (context, snapshot) {
                              return Row(
                                children: [
                                  Text(
                                    (!presenter.showCardNum &&
                                            element.service != 1 &&
                                            cardNo.isNotEmpty)
                                        ? AppStatus.shared
                                            .meet4AddBlankAndHide(cardNo)
                                        : AppStatus.shared
                                            .meet4AddBlank(cardNo),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Visibility(
                                    visible: cardNo.isNotEmpty &&
                                        element.service != 1,
                                    child: InkWell(
                                      onTap: () {
                                        if (!presenter.showCardNum) {
                                          if (UserInfo.shared.has_safe_pin !=
                                              1) {
                                            showSafeAlertDialog(
                                                context,
                                                "Notes",
                                                "You have not set up your payment safety pin.");
                                            return;
                                          }
                                          showDisplayCardNumberView(context);
                                        } else {
                                          presenter.showCardNum = false;
                                          cardNumController.sink.add(0);
                                        }
                                      },
                                      child: Image.asset(!presenter.showCardNum
                                          ? A.assets_visible_eyes
                                          : A.assets_un_visible_eyes),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Visibility(
                                      visible: cardNo.isNotEmpty,
                                      child: InkWell(
                                          onTap: () {
                                            Clipboard.setData(
                                                ClipboardData(text: cardNo));
                                            showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return ShowMessage(2,
                                                      'Copy to Clipboard'.tr(),
                                                      styleType: 1, width: 257);
                                                });
                                          },
                                          child: Image.asset(
                                              A.assets_mine_contact_copy))),
                                ],
                              );
                            }),
                      ),
                      // StreamBuilder(
                      //     stream: cardNumController.stream,
                      //     builder: (context, snapshot) {
                      //       return Visibility(
                      //           visible: presenter.showCardNum &&
                      //               element.service == 3,
                      //           child: Positioned(
                      //             left: 30,
                      //             bottom: 50,
                      //             child: Text(
                      //               "${'Pin:'.tr()}${presenter.card33Model?.pin}",
                      //               style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.w500),
                      //             ),
                      //           ));
                      //     }),
                      StreamBuilder<int>(
                          stream: cardNumController.stream,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: (element.expiry_date.isNotEmpty ||
                                  (presenter.showCardNum &&
                                      element.service != 1 &&
                                      (presenter.card33Model?.valid_thre ?? '')
                                          .isNotEmpty)),
                              child: Positioned(
                                left: 20,
                                bottom: 20,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Expiry Date'.tr(),
                                          style: TextStyle(
                                              color: ColorsUtil.hexColor(
                                                  0xffffff,
                                                  alpha: 0.8),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          element.service == 1
                                              ? "${element.expiry_month}/${element.expiry_year}"
                                              : "${presenter.card33Model?.valid_thre}",
                                          style: TextStyle(
                                              color: ColorsUtil.hexColor(
                                                  0xffffff,
                                                  alpha: 1),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 28,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          element.card_type == 'master'
                                              ? 'CVC2'
                                              : "CVV2",
                                          style: TextStyle(
                                              color: ColorsUtil.hexColor(
                                                  0xffffff,
                                                  alpha: 0.8),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          element.service == 1
                                              ? "${element.card_cvv}"
                                              : "${presenter.card33Model?.cvv}",
                                          style: TextStyle(
                                              color: ColorsUtil.hexColor(
                                                  0xffffff,
                                                  alpha: 1),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 28,
                                    ),
                                    Visibility(
                                      visible: element.service == 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pin".tr(),
                                            style: TextStyle(
                                                color: ColorsUtil.hexColor(
                                                    0xffffff,
                                                    alpha: 0.8),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            "${presenter.card33Model?.pin}",
                                            style: TextStyle(
                                                color: ColorsUtil.hexColor(
                                                    0xffffff,
                                                    alpha: 1),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                      Positioned(
                        child: Image.asset(element.card_type == 'visa'
                            ? A.assets_home_visa_icon2
                            : element.card_type == 'master'
                                ? A.assets_home_master_icon2
                                : A.assets_union_card),
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
    if (presenter.models.isEmpty) {
      return _buildPhysialBtn(context);
    }
    MycardsModel m = presenter.models[_currentPageIndex];
    var isPhysialCard = m.service;
    var width = (MediaQuery.of(context).size.width - 20) / 4;
    if (width < 50) {
      width = 70;
    }
    if (isPhysialCard == 1) {
      //虚拟卡
      return _buildVisualBtn(context);
    }
    return _buildPhysialBtn(context);
  }

  Widget _buildPhysialBtn(BuildContext context) {
    MycardsModel m = MycardsModel(
        "",
        "",
        0,
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        0,
        0,
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        1,
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "");
    if (presenter.models.isNotEmpty) {
      m = presenter.models[_currentPageIndex];
    }
    // MycardsModel m = presenter.models[_currentPageIndex];
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
                if (UserInfo.shared.isKycVerified != 1 &&
                    AppStatus.shared.withdrawWithoutKyc == false) {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return ShowMessage(2,
                            "Please Complete Identity Verification First".tr(),
                            dismissSeconds: 2, styleType: 1, width: 257);
                      });
                  return;
                }
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
                if (UserInfo.shared.isLoggedin) {
                  if (UserInfo.shared.has_safe_pin != 1) {
                    showSafeAlertDialog(context, "Notes",
                        "You have not set up your payment safety pin.");
                    return;
                  }
                  if (presenter.models.isNotEmpty) {
                    if (m.status == "N") {
                      showSafetyAuthView(context, 1);
                    } else {
                      //
                    }
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
                            ? A.assets_topup_black
                            : m.status == "N" && m.hold_status != "H"
                                ? A.assets_active_icon
                                : A.assets_unactive_icon)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      "Activate".tr(),
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
                if (UserInfo.shared.isLoggedin) {
                  if (m.hold_status == "H") {
                    showTopError(context, 'Please unfreeze card');
                    return;
                  } else {
                    if (presenter.models.isNotEmpty) {
                      MycardsModel item = presenter.models[_currentPageIndex];
                      if (item.status == "A" && m.hold_status != "H") {
                        presenter.topupButtonPressed(context, item);
                      }
                    }
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
                            ? A.assets_topup_black
                            : m.status == "A" && m.hold_status != "H"
                                ? A.assets_home_topup
                                : A.assets_un_topup_icon)),
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
                if (UserInfo.shared.isLoggedin) {
                  if (presenter.models.isNotEmpty) {
                    if (UserInfo.shared.has_safe_pin != 1) {
                      showSafeAlertDialog(context, "Notes",
                          "You have not set up your payment safety pin.");
                      return;
                    }
                    MycardsModel item = presenter.models[_currentPageIndex];
                    if (item.status == "A" &&
                        (item.hold_status == "R" || item.hold_status == "N")) {
                      showFreezeDialog(context);
                    } else if (item.status == "A" && item.hold_status == "H") {
                      showSafetyAuthView(context, 2);
                    }
                  } else {
                    //请先申请卡片
                    if (UserInfo.shared.isLoggedin) {
                      showTopError(context, 'Please apply card');
                    } else {
                      presenter.loginPressed(context);
                    }
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
                            ? A.assets_update_black
                            : (m.status == "A" &&
                                    (m.hold_status == "R" ||
                                        m.hold_status == "N" ||
                                        m.hold_status == "H"))
                                ? A.assets_freeze_icon
                                : A.assets_unfreeze_icon)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      (m.status == "A" && m.hold_status == "H")
                          ? "UnFreeze".tr()
                          : "Freeze".tr(),
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
                  if (UserInfo.shared.has_safe_pin != 1) {
                    showSafeAlertDialog(context, "Notes",
                        "You have not set up your payment safety pin.");
                    return;
                  }
                  if (presenter.models.isNotEmpty) {
                    MycardsModel item = presenter.models[_currentPageIndex];
                    if (item.status == "A" && m.hold_status != "H") {
                      showSafetyAuthView(context, 4);
                    } else if (item.status == "K" ||
                        item.status == "L" && m.hold_status != "H") {
                      showSafetyAuthView(context, 3);
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
                            : (m.status == "A" ||
                                        m.status == "K" ||
                                        m.status == "L") &&
                                    m.hold_status != "H"
                                ? A.assets_lost_icon
                                : A.assets_unlock_icon)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      (m.status == "K" || m.status == "L")
                          ? "UnLost".tr()
                          : "Lost".tr(),
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
                  if (UserInfo.shared.has_safe_pin != 1) {
                    showSafeAlertDialog(context, "Notes",
                        "You have not set up your payment safety pin.");
                    return;
                  }
                  if (presenter.models.isNotEmpty) {
                    //
                    if (m.status == "A" && m.hold_status != "H") {
                      showTransferDialog(context);
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
                            ? A.assets_transfer_icon
                            : m.status == "A" && m.hold_status != "H"
                                ? A.assets_untransfer_icon
                                : A.assets_real_trans_icon)),
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
                if (UserInfo.shared.isLoggedin) {
                  if (UserInfo.shared.has_safe_pin != 1) {
                    showSafeAlertDialog(context, "Notes",
                        "You have not set up your payment safety pin.");
                    return;
                  }
                  if (m.status == "A" && m.hold_status != "H") {
                    showModifyPinDialog(context);
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
                            ? A.assets_modify_icon
                            : m.status == "A" && m.hold_status != "H"
                                ? A.assets_modify_icon
                                : A.assets_unmodifypin_icon)),
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
                if (m.status == "A") {
                  presenter.gotoBillPage(context, m);
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
                            ? A.assets_bill_icon
                            : m.status == "A"
                                ? A.assets_bill_icon
                                : A.assets_unbill_icon)),
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

  Widget _buildVisualBtn(BuildContext context) {
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
                presenter.gotoCardSetting(context);
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
                      "Settings".tr(),
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
                MycardsModel item = presenter.models[_currentPageIndex];
                presenter.gotoBillPage(context, item);
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

  // //账单
  // Widget _buildBillRow(BuildContext context) {
  //   DateFormat dateFormat = DateFormat("yyyy-MM");
  //   String dateTime = dateFormat.format(presenter.selectTime);
  //   return Container(
  //     margin: EdgeInsets.only(left: 15, right: 10, top: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           'Bill'.tr(),
  //           style: TextStyle(
  //               fontSize: 16,
  //               color: _theme == AppTheme.light
  //                   ? AppStatus.shared.bgBlackColor
  //                   : AppStatus.shared.bgWhiteColor,
  //               fontWeight: FontWeight.w500),
  //         ),
  //         Container(
  //           width: 107,
  //           height: 32,
  //           decoration: BoxDecoration(
  //               color: _theme == AppTheme.light
  //                   ? AppStatus.shared.bgGreyLightColor
  //                   : AppStatus.shared.bgDarkGreyColor,
  //               borderRadius: BorderRadius.circular(16)),
  //           child: Center(
  //             child: TextImageButton(
  //               margin: 2,
  //               type: TextIconButtonType.imageRight,
  //               icon: Image.asset(_theme == AppTheme.light
  //                   ? A.assets_Polygon_1
  //                   : A.assets_home_bill_arrow),
  //               text: Text(
  //                 dateTime,
  //                 style: TextStyle(
  //                     fontSize: 15,
  //                     color: _theme == AppTheme.light
  //                         ? AppStatus.shared.bgBlackColor
  //                         : AppStatus.shared.bgWhiteColor),
  //               ),
  //               onTap: () {
  //                 if (UserInfo.shared.isLoggedin) {
  //                   showDateDiolog(context);
  //                 } else {
  //                   presenter.loginPressed(context);
  //                 }
  //               },
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

  ////按钮弹窗

  //安全码
  showSafetyAuthView(BuildContext context, int type) async {
    var title = "";
    if (type == 1) {
      title = "Credit Card Authorization".tr();
    } else if (type == 2) {
      title = "Unfreeze Account Authorization".tr();
    } else if (type == 3) {
      title = "Unlost Account Authorization".tr();
    } else if (type == 4) {
      title = "Lost Account Authorization".tr();
    } else if (type == 5) {
      title = "Modify PIN Account Authorization".tr();
    } else if (type == 6) {
      title = "Transfer Account Authorization".tr();
    }
    if (type == 1) {
      presenter.startSendCode(30);
    } else if (type == 2) {
      presenter.startSendCode(31);
    } else if (type == 3) {
      presenter.startSendCode(33);
    } else if (type == 4) {
      presenter.startSendCode(32);
    } else if (type == 5) {
      presenter.startSendCode(35);
    } else if (type == 6) {
      presenter.startSendCode(34);
    }
    MycardsModel m = presenter.models[_currentPageIndex];
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 620, minWidth: double.infinity),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return StreamBuilder<int>(
                stream: safetyController.stream,
                builder: (context3, snapshot) {
                  return Container(
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgWhiteColor
                            : ColorsUtil.hexColor(0x2E2E2E),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                title,
                                style: TextStyle(
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : AppStatus.shared.bgWhiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            controller: _safeScroController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSafetyPinView(context, type),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildAccountsView(context),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildEmailVerifyView(context),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildeSendCodeView(context, type),
                                SizedBox(
                                  height: 10,
                                ),
                                Visibility(
                                  visible: type == 2 || type == 3,
                                  child: Center(
                                    child: Text(
                                      type == 2
                                          ? "${"Unfreeze Fee:".tr()} ${m.unfreeze_fee} ${m.unfreeze_fee_unit}"
                                          : "${"Unlost Fee:".tr()} ${m.unlost_fee} ${m.unlost_fee_unit}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: type == 2 || type == 3,
                                  child: SizedBox(
                                    height: 10,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    String code = _emailCode;
                                    String safePin = _safetyPinCode;
                                    if (safePin.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            String error = "";
                                            if (type == 3 ||
                                                type == 4 ||
                                                type == 6) {
                                              error =
                                                  "Please enter card pin".tr();
                                            } else {
                                              error = "Please enter Safety Pin"
                                                  .tr();
                                            }
                                            return ShowMessage(2, error,
                                                styleType: 1, width: 257);
                                          });
                                      return;
                                    } else if (code.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return ShowMessage(
                                                2,
                                                "Please enter verification code"
                                                    .tr(),
                                                styleType: 1,
                                                width: 257);
                                          });
                                      return;
                                    }

                                    if (type == 1) {
                                      Map result = await presenter.active33Card(
                                          m.card_order, code, safePin);
                                      Navigator.pop(context);
                                      if (result["code"] == 200) {
                                        showAlertDialog(
                                            context,
                                            "Congratulations!".tr(),
                                            "Your card activation is successful."
                                                .tr());
                                        presenter.fetchMycardsList();
                                        _safetyPinCodeController.text = "";
                                        _emailCodeController.text = "";
                                      } else {
                                        showTopError(context, result["msg"]);
                                        _safetyPinCodeController.text = "";
                                        _emailCodeController.text = "";
                                      }
                                    } else if (type == 2) {
                                      Map result =
                                          await presenter.unfreeze33Card(
                                              m.card_order, code, safePin);
                                      Navigator.pop(context);
                                      if (result["code"] == 200) {
                                        showAlertDialog(
                                            context,
                                            "Congratulations!".tr(),
                                            "Successful unfreeze!".tr());
                                        presenter.fetchMycardsList();
                                        _safetyPinCodeController.text = "";
                                        _emailCodeController.text = "";
                                      } else {
                                        showTopError(context, result["msg"]);
                                        _safetyPinCodeController.text = "";
                                        _emailCodeController.text = "";
                                      }
                                    } else if (type == 3) {
                                      Map result = await presenter.unlost33Card(
                                          m.card_order, code, safePin);
                                      Navigator.pop(context);
                                      if (result["code"] == 200) {
                                        showAlertDialog(
                                            context,
                                            "Congratulations!".tr(),
                                            "Successful unlost!".tr());
                                        presenter.fetchMycardsList();
                                        _safetyPinCodeController.text = "";
                                        _emailCodeController.text = "";
                                      } else {
                                        showTopError(context, result["msg"]);
                                        _safetyPinCodeController.text = "";
                                        _emailCodeController.text = "";
                                      }
                                    } else if (type == 4) {
                                      Map result = await presenter.lost33Card(
                                          m.card_order, code, safePin);
                                      Navigator.pop(context);
                                      if (result["code"] == 200) {
                                        showAlertDialog(
                                            context,
                                            "Congratulations!".tr(),
                                            "Successful lost!".tr());
                                        presenter.fetchMycardsList();
                                        _safetyPinCodeController.text = "";
                                        _emailCodeController.text = "";
                                      } else {
                                        showTopError(context, result["msg"]);
                                        _safetyPinCodeController.text = "";
                                        _emailCodeController.text = "";
                                      }
                                    } else if (type == 5) {
                                      String oldPin =
                                          _oldPasswordController.text;
                                      String newPin =
                                          _newPasswordController.text;
                                      String newPinC =
                                          _confirmPasswordController.text;
                                      Map result = await presenter.modpin33Card(
                                          m.card_order,
                                          code,
                                          oldPin,
                                          newPin,
                                          newPinC,
                                          safePin);
                                      Navigator.pop(context);
                                      if (result["code"] == 200) {
                                        showAlertDialog(
                                            context,
                                            "Congratulations!".tr(),
                                            "Successful PIN Modification!"
                                                .tr());
                                        presenter.fetchMycardsList();
                                        _oldPasswordController.text = "";
                                        _newPasswordController.text = "";
                                        _confirmPasswordController.text = "";
                                      } else {
                                        showTopError(context, result["msg"]);
                                        _oldPasswordController.text = "";
                                        _newPasswordController.text = "";
                                        _confirmPasswordController.text = "";
                                      }
                                    } else if (type == 6) {
                                      String cardNum =
                                          _cardNumberController.text;
                                      String amount = _amountController.text;

                                      Map result =
                                          await presenter.transfer33Card(
                                              m.card_order,
                                              code,
                                              safePin,
                                              cardNum,
                                              amount);
                                      Navigator.pop(context);
                                      if (result["code"] == 200) {
                                        showAlertDialog(
                                            context,
                                            "Congratulations!".tr(),
                                            "Successful transfer!".tr());
                                        presenter.fetchMycardsList();
                                        _cardNumberController.text = "";
                                        _amountController.text = "";
                                        _safetyPinCodeController.text = "";
                                        _emailCodeController.text = "";
                                      } else {
                                        showTopError(context, result["msg"]);
                                        _cardNumberController.text = "";
                                        _amountController.text = "";
                                        _safetyPinCodeController.text = "";
                                        _emailCodeController.text = "";
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AppStatus.shared.bgBlueColor,
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Submit".tr(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 200,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          });
        }).whenComplete(() {}).then((value) {
      _safetyPinCodeController.text = "";
      _emailCodeController.text = "";
      _cardNumberController.text = "";
      _amountController.text = "";
      _oldPasswordController.text = "";
      _newPasswordController.text = "";
      _confirmPasswordController.text = "";
    });
  }

  Widget _buildSafetyPinView(BuildContext context, int type) {
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
            : Colors.white,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    String title = "";
    if (type == 3 || type == 4 || type == 6) {
      title = "Enter Your Card Pin".tr();
    } else {
      title = "Enter Your Safety Pin".tr();
    }
    return Padding(
      padding: EdgeInsets.only(
        left: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                TextStyle(fontSize: 14, color: AppStatus.shared.textGreyColor),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: itemSize,
            child: Pinput(
              length: length,
              controller: _safetyPinCodeController,
              focusNode: _safetyPinfocusNode,
              defaultPinTheme: defaultPinTheme,
              onCompleted: (pin) {
                //
                _safetyPinCode = pin;
                safetyController.add(0);
              },
              onChanged: (pin) {
                _safetyPinCode = pin;
                safetyController.add(0);
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
        ],
      ),
    );
  }

  //文本
  Widget _buildAccountsView(BuildContext context) {
    return Visibility(
      visible: isSent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "A verification code is sent to".tr(),
            style:
                TextStyle(fontSize: 14, color: AppStatus.shared.textGreyColor),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            NumberPlus.getSecurityEmail(UserInfo.shared.username),
            style: TextStyle(
                fontSize: 16,
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : Colors.white),
          ),
        ],
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
            : Colors.white,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return SizedBox(
      height: itemSize,
      child: Pinput(
        length: length,
        controller: _emailCodeController,
        focusNode: _emailfocusNode,
        defaultPinTheme: defaultPinTheme,
        onCompleted: (pin) {
          //
          _emailCode = pin;
          safetyController.add(0);
        },
        onChanged: (pin) {
          _emailCode = pin;
          safetyController.add(0);
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
          _safeScroController.animateTo(120,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
      ),
    );
  }

  Widget _buildeSendCodeView(BuildContext context, int type) {
    int codeType = 30;
    if (type == 1) {
      codeType = 30;
    } else if (type == 2) {
      codeType = 31;
    } else if (type == 3) {
      codeType = 33;
    } else if (type == 4) {
      codeType = 32;
    } else if (type == 5) {
      codeType = 35;
    }
    return Container(
        width: double.infinity,
        height: 48,
        child: ValueListenableBuilder<bool>(
          builder: (BuildContext context, bool value, Widget? child) {
            return SendCodeButton(codeType, true, true, Colors.transparent, () {
              isSent = true;
              safetyController.add(0);
              // sendCodePressed(UserInfo.shared.username);
              FocusScope.of(context).unfocus();
            });
          },
          valueListenable: _sendCodeSuccess,
        ));
  }

  showFreezeDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 320, minWidth: double.infinity),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return StreamBuilder<int>(
                stream: safetyController.stream,
                builder: (context1, snapshot) {
                  return Container(
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgWhiteColor
                            : ColorsUtil.hexColor(0x2E2E2E),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Freeze".tr(),
                                style: TextStyle(
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : AppStatus.shared.bgWhiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            controller: _safeScroController,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(_theme == AppTheme.light
                                          ? A.assets_warning_black
                                          : A.assets_warning_icon),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Freezing a card causes failed orders, causing transaction failure or additional fees for declined transactions."
                                              .tr(),
                                          style: TextStyle(
                                              color: _theme == AppTheme.light
                                                  ? AppStatus
                                                      .shared.bgBlackColor
                                                  : Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Once the one-key card lock function is enabled, you will not be able to use this card, but it will not affect other cards. If you want to cancel the one-key card lock function, you can enable it here again."
                                        .tr(),
                                    style: TextStyle(
                                        color: _theme == AppTheme.light
                                            ? AppStatus.shared.bgBlackColor
                                            : Colors.white,
                                        fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color:
                                                  AppStatus.shared.bgGreyColor,
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Cancel".tr(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            MycardsModel m = presenter
                                                .models[_currentPageIndex];
                                            Map result = await presenter
                                                .freeze33Card(m.card_order);
                                            Navigator.pop(context);
                                            if (result["code"] == 200) {
                                              showAlertDialog(
                                                  context,
                                                  "Freeze".tr(),
                                                  "Successful freeze!".tr());

                                              presenter.fetchMycardsList();
                                            } else {
                                              showTopError(
                                                  context, result["msg"]);
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color:
                                                  AppStatus.shared.bgBlueColor,
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Freeze".tr(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          });
        }).whenComplete(() {});
  }

  //弹窗
  showAlertDialog(BuildContext context, String title, String content,
      {bool isPhycialSuccess = false}) {
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

  //modify pin first view
  showModifyPinDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 700, minWidth: double.infinity),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return StreamBuilder<int>(
                stream: safetyController.stream,
                builder: (context3, snapshot) {
                  return Container(
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgWhiteColor
                            : ColorsUtil.hexColor(0x2E2E2E),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Modify PIN".tr(),
                                style: TextStyle(
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : AppStatus.shared.bgWhiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            controller: _modifyScroController,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(_theme == AppTheme.light
                                          ? A.assets_warning_black
                                          : A.assets_warning_icon),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Reminder".tr(),
                                          style: TextStyle(
                                              color: _theme == AppTheme.light
                                                  ? AppStatus
                                                      .shared.bgBlackColor
                                                  : Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Enter Old Password:".tr(),
                                    style: TextStyle(
                                        color: _theme == AppTheme.light
                                            ? AppStatus.shared.bgBlackColor
                                            : Colors.white,
                                        fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  OldPassowrdView(context),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Enter New Password:".tr(),
                                    style: TextStyle(
                                        color: _theme == AppTheme.light
                                            ? AppStatus.shared.bgBlackColor
                                            : Colors.white,
                                        fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  NewPassowrdView(context),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Confirm New Password:".tr(),
                                    style: TextStyle(
                                        color: _theme == AppTheme.light
                                            ? AppStatus.shared.bgBlackColor
                                            : Colors.white,
                                        fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ConfirmPassowrdView(context),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            _oldPasswordController.text = "";
                                            _newPasswordController.text = "";
                                            _confirmPasswordController.text =
                                                "";
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color:
                                                  AppStatus.shared.bgGreyColor,
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Cancel".tr(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            //
                                            String oldPin =
                                                _oldPasswordController.text;
                                            String newPin =
                                                _newPasswordController.text;
                                            String newPinC =
                                                _confirmPasswordController.text;
                                            String error = "";
                                            if (oldPin.isEmpty) {
                                              error =
                                                  "Please enter old pin".tr();
                                            } else if (newPin.isEmpty) {
                                              error =
                                                  "Please enter new pin".tr();
                                            } else if (newPinC.isEmpty) {
                                              error =
                                                  "Please confirm new pin".tr();
                                            }
                                            if (error.isNotEmpty) {
                                              showTopError(context, error);
                                              return;
                                            }
                                            Navigator.pop(context);
                                            showSafetyAuthView(context, 5);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color:
                                                  AppStatus.shared.bgBlueColor,
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Confirm".tr(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          });
        }).whenComplete(() {});
  }

  Widget OldPassowrdView(BuildContext context) {
    return Container(
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
          obscureText: true,
          controller: _oldPasswordController,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 15,
                right: 5,
                bottom: 14,
              ),
              border: InputBorder.none,
              hintText: "Password".tr(),
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14)),
          onChanged: (text) {},
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
            _modifyScroController.animateTo(0,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          onTap: () {
            _modifyScroController.animateTo(120,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
        ),
      ),
    );
  }

  Widget NewPassowrdView(BuildContext context) {
    return Container(
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
          obscureText: true,
          controller: _newPasswordController,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 15,
                right: 5,
                bottom: 14,
              ),
              border: InputBorder.none,
              hintText: "Password".tr(),
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14)),
          onChanged: (text) {},
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
            _modifyScroController.animateTo(0,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          onTap: () {
            _modifyScroController.animateTo(120,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
        ),
      ),
    );
  }

  Widget ConfirmPassowrdView(BuildContext context) {
    return Container(
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
          obscureText: true,
          controller: _confirmPasswordController,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 15,
                right: 5,
                bottom: 14,
              ),
              border: InputBorder.none,
              hintText: "Password".tr(),
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14)),
          onChanged: (text) {},
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
            _modifyScroController.animateTo(0,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          onTap: () {
            _modifyScroController.animateTo(220,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
        ),
      ),
    );
  }

  //卡卡转账
  showTransferDialog(BuildContext context) {
    MycardsModel model = presenter.models[_currentPageIndex];
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 650, minWidth: double.infinity),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return StreamBuilder<int>(
                stream: safetyController.stream,
                builder: (context3, snapshot) {
                  return Container(
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgWhiteColor
                            : ColorsUtil.hexColor(0x2E2E2E),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Transfer".tr(),
                                style: TextStyle(
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : AppStatus.shared.bgWhiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Amount available".tr(),
                                style: TextStyle(
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : AppStatus.shared.textGreyColor,
                                    fontSize: 13),
                              ),
                              Text("${model.balance}${model.currency}",
                                  style: TextStyle(
                                      color: _theme == AppTheme.light
                                          ? AppStatus.shared.bgBlackColor
                                          : Colors.white,
                                      fontSize: 16)),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "To:".tr(),
                                style: TextStyle(
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : Colors.white,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(child: _buildCardNumView(context3)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Amount:".tr(),
                                style: TextStyle(
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : Colors.white,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(child: _buildAmountView(context3)),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                model.currency,
                                style: TextStyle(
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : Colors.white,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  _amountController.text = model.balance;
                                },
                                child: Text(
                                  "Max",
                                  style: TextStyle(
                                      color: AppStatus.shared.bgBlueColor,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Transfer fee:".tr(),
                                style: TextStyle(
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : Colors.white,
                                    fontSize: 13),
                              ),
                              Text(
                                "${model.card_transfer_fee}${model.card_transfer_fee_unit}",
                                style: TextStyle(
                                    color: AppStatus.shared.bgBlueColor,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Transfer fee will be deducted from your account balance."
                                .tr(),
                            style: TextStyle(
                                color: AppStatus.shared.textGreyColor,
                                fontSize: 13),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: AppStatus.shared.bgGreyColor,
                                          borderRadius:
                                              BorderRadius.circular(22),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Cancel".tr(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        //
                                        String amount = _amountController.text;
                                        String cardNum =
                                            _cardNumberController.text;
                                        String error = "";
                                        if (cardNum.isEmpty) {
                                          error =
                                              "Please enter Card Number".tr();
                                        } else if (amount.isEmpty) {
                                          error = "Please enter Amount".tr();
                                        }
                                        if (error.isNotEmpty) {
                                          showTopError(context, error);
                                          return;
                                        }
                                        Navigator.pop(context);
                                        showSafetyAuthView(context, 6);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: AppStatus.shared.bgBlueColor,
                                          borderRadius:
                                              BorderRadius.circular(22),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Confirm".tr(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          });
        }).whenComplete(() {});
  }

  Widget _buildCardNumView(BuildContext context) {
    return Container(
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
          obscureText: false,
          controller: _cardNumberController,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 15,
                right: 5,
                bottom: 14,
              ),
              border: InputBorder.none,
              hintText: "Card Number".tr(),
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14)),
          onChanged: (text) {},
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
            _transferScroController.animateTo(0,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          onTap: () {
            _transferScroController.animateTo(220,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
        ),
      ),
    );
  }

  Widget _buildAmountView(BuildContext context) {
    return Container(
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
          obscureText: false,
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(r'^\d+\.?\d{0,' + '${5}' + '}')),
          ],
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 15,
                right: 5,
                bottom: 14,
              ),
              border: InputBorder.none,
              hintText: "0.00".tr(),
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14)),
          onChanged: (text) {},
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
            _transferScroController.animateTo(0,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          onTap: () {
            _transferScroController.animateTo(220,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
        ),
      ),
    );
  }

  //cardnumber
  showDisplayCardNumberView(BuildContext context) async {
    var title = "Diaplay Card Number".tr();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 440, minWidth: double.infinity),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return StreamBuilder<int>(
                stream: safetyController.stream,
                builder: (context3, snapshot) {
                  return Container(
                    decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgWhiteColor
                            : ColorsUtil.hexColor(0x2E2E2E),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                title,
                                style: TextStyle(
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : AppStatus.shared.bgWhiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            controller: _safeScroController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSafetyPinView(context, 1),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () async {
                                    String safePin = _safetyPinCode;
                                    if (safePin.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            String error =
                                                "Please enter Safety Pin".tr();
                                            return ShowMessage(2, error,
                                                styleType: 1, width: 257);
                                          });
                                      return;
                                    }
                                    MycardsModel model =
                                        presenter.models[_currentPageIndex];
                                    Map result =
                                        await presenter.showCardDetail33(
                                            model.card_order, safePin);
                                    if (result["code"] == 200) {
                                      presenter.showCardNum = true;
                                      var model =
                                          Card33InfoModel.parse(result["data"]);
                                      debugPrint(
                                          "string is ${result["data"]} ----model is ${model.valid_thre}--${model.cvv}");
                                      presenter.card33Model = model;
                                      cardNumController.sink.add(0);
                                      Navigator.pop(context);
                                      _safetyPinCodeController.text = "";
                                    } else {
                                      showTopError(context, result["msg"]);
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AppStatus.shared.bgBlueColor,
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Submit".tr(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 200,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          });
        }).whenComplete(() {});
  }

  //提醒设置安全码
  showSafeAlertDialog(BuildContext context, String title, String content) {
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
                        Navigator.pop(context);
                        presenter.toSafetyPinPage(context);
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

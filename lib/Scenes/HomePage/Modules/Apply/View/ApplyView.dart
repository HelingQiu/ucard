import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_lifecycle/flutter_page_lifecycle.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';
import 'package:ucardtemp/Data/UserInfo.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Entity/CardInfoModel.dart';

import '../../../../../Common/NumberPlus.dart';
import '../../../../../Common/TextImageButton.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
import '../Presenter/ApplyPresenter.dart';

class ApplyView extends StatelessWidget {
  final ApplyPresenter presenter;

  StreamController<int> streamController = StreamController.broadcast();
  StreamController<int> applyStreamController = StreamController.broadcast();

  final TextEditingController _phoneController =
      TextEditingController(text: '');

  ScrollController _scrollController = ScrollController();
  final TextEditingController _cardNameController =
      TextEditingController(text: '');

  ApplyView(this.presenter);

  //当前选择的卡片等级
  int _currentPageIndex = 0;

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return PageLifecycle(
        stateChanged: (appear) {
          if (appear) {
            streamController.add(0);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor, //修改颜色
            ),
            elevation: 0,
            title: Text(
              "Apply".tr(),
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
                            _buildCardTypeView(context),
                            SizedBox(
                              height: 2,
                            ),
                            presenter.currentCard == 0
                                ? _buildPageIndexView(context)
                                : SizedBox(),
                            SizedBox(
                              height: 17,
                            ),
                            presenter.currentCard == 0
                                ? _buildCardsView(context)
                                : _buildPhysicalCardView(context),
                            SizedBox(
                              height: 10,
                            ),
                            presenter.currentCard == 0
                                ? _buildCardNameView(context)
                                : _buildPhycialCardName(),
                            SizedBox(
                              height: 20,
                            ),
                            presenter.currentCard == 0
                                ? SizedBox()
                                : Column(
                                    children: [
                                      _buildAddress(context, 0),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      _buildAddress(context, 1),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      _buildAddress(context, 2),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                            presenter.currentCard == 0
                                ? SizedBox()
                                : PhoneInputView(context),
                            _buildCell(context, 0),
                            _buildCell(context, 1),
                            _buildCell(context, 2),
                            _buildCell(context, 3),
                            presenter.currentCard == 0
                                ? _buildCell(context, 4)
                                : SizedBox(),
                            presenter.currentCard == 0
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 10),
                                    child: Text(
                                      'The application Fee note'.tr() +
                                          "${presenter.models.isNotEmpty ? presenter.models[_currentPageIndex].first_limit_fee : ""}" +
                                          "The application Fee note1".tr(),
                                      style: TextStyle(
                                          color: AppStatus.shared.textGreyColor,
                                          fontSize: 12),
                                    ),
                                  )
                                : SizedBox(),
                            presenter.currentCard == 0
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Name'.tr(),
                                          style: TextStyle(
                                              color: theme == AppTheme.light
                                                  ? AppStatus
                                                      .shared.bgBlackColor
                                                  : AppStatus
                                                      .shared.bgWhiteColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '（optional）'.tr(),
                                          style: TextStyle(
                                              color: AppStatus
                                                  .shared.textGreyColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            presenter.currentCard == 0
                                ? _buildCardnameView(context)
                                : SizedBox(),
                            presenter.currentCard == 0
                                ? _buildProtocol(context)
                                : SizedBox(),
                            presenter.currentCard == 0
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Text(
                                      "Card Application Fee ".tr(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                            presenter.currentCard == 0
                                ? SizedBox()
                                : _buildCell(context, 5),
                            presenter.currentCard == 0
                                ? SizedBox()
                                : _buildCell(context, 6),
                            presenter.currentCard == 0
                                ? SizedBox()
                                : _buildCell(context, 7),
                            presenter.currentCard == 1
                                ? _buildProtocol(context)
                                : SizedBox(),
                            SizedBox(
                              height: 300,
                              // height:
                              //     presenter.card.cardType != "visa" ? 300 : 200,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Container(
                            height: 114,
                            color: theme == AppTheme.light
                                ? AppStatus.shared.bgWhiteColor
                                : AppStatus.shared.bgBlackColor,
                            child: presenter.currentCard == 0
                                ? _buildSubmitButton(context)
                                : _buildSaveButton(context)),
                        bottom: 0,
                        height: 114,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  )),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCardTypeView(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Color(0xff232323),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              presenter.currentCard = 0;
              streamController.add(0);
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: presenter.currentCard == 0
                    ? Color(0xff2369FF)
                    : Color(0xff232323),
              ),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Image.asset(A.assets_virtual_card),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Virtual Card"),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              presenter.currentCard = 1;
              streamController.add(0);
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: presenter.currentCard == 0
                    ? Color(0xff232323)
                    : Color(0xff2369FF),
              ),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Image.asset(A.assets_physical_card),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Physical Card"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
                    : _theme == AppTheme.light
                        ? AppStatus.shared.bgGreyLightColor
                        : AppStatus.shared.bgDarkGreyColor),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCardsView(BuildContext context) {
    if (presenter.models.isEmpty) {
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
            children: presenter.models.map((element) {
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
                        child: Image.asset(presenter.card.cardType == 'master'
                            ? A.assets_home_master_icon2
                            : A.assets_home_visa_icon2),
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

  //
  Widget _buildPhysicalCardView(BuildContext context) {
    return Center(
      child: Container(
        child: Stack(
          children: [
            ClipRRect(
                child: Image.asset(A.assets_home_sliver_bg),
                borderRadius: BorderRadius.circular(10)),
            Positioned(
              child: Image.asset(presenter.card.cardType == 'master'
                  ? A.assets_home_master_icon2
                  : A.assets_home_visa_icon2),
              right: 20,
              bottom: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardNameView(BuildContext context) {
    if (presenter.models.isEmpty) {
      return Container();
    }
    CardInfoModel m = presenter.models[_currentPageIndex];
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

  //
  Widget _buildPhycialCardName() {
    return Center(
      child: Column(
        children: [
          Text(
            "Physical Card",
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Limit of 100,000 HKD",
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontWeight: FontWeight.w400,
                fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(BuildContext context, int type) {
    if (presenter.models.isEmpty) {
      return Container();
    }
    CardInfoModel m = presenter.models[_currentPageIndex];
    String title = '';
    String content = '';
    //@account
    if (type == 0) {
      title = 'Fee'.tr();
      content =
          '${m.recharge_fee} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : m.recharge_fee_unit}';
    } else if (type == 1) {
      title = 'Invitation reward'.tr();
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
      title = 'Activation fee'.tr();
      content =
          '${m.open_fee} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : m.open_fee_unit}';
    } else if (type == 5) {
      title = 'Sub-Total'.tr();
      content =
          '0 ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : m.open_fee_unit}';
    } else if (type == 6) {
      title = 'Shipping Fee'.tr();
      content =
          '0 ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : m.open_fee_unit}';
    } else if (type == 7) {
      title = 'Pay'.tr();
      content =
          '0 ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : m.open_fee_unit}';
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
              child: Visibility(
                visible: type != 5 && type != 6 && type != 7,
                child: Image.asset(_theme == AppTheme.light
                    ? A.assets_question_black
                    : A.assets_apply_info),
              ),
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
                    'Activation fee',
                    'Activation fee alert',
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

  //
  Widget _buildAddress(BuildContext context, int addressType) {
    String title = "";
    String address = "";
    if (addressType == 0) {
      title = "Shipping To";
      address =
          "Emily Wong Flat/Room 1503, 15/F 1238 King's Road North Point, Hong Kong";
    } else if (addressType == 1) {
      title = "Mailing To";
    } else if (addressType == 2) {
      title = "Residential Address";
    }
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              presenter.gotoAddressInfoPage(context, addressType);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Image.asset(A.assets_mine_arrow_right)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: address.isNotEmpty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xff232323),
                  ),
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                  child: Text(address),
                ),
                Image.asset(A.assets_reward_copy),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget PhoneInputView(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 0, bottom: 10, left: 16, right: 16),
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
                  onChanged: (text) {},
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

  Widget _buildCardnameView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: _theme == AppTheme.light
              ? AppStatus.shared.bgGreyLightColor
              : AppStatus.shared.bgGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          textAlign: TextAlign.start,
          autocorrect: false,
          controller: _cardNameController,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor,
              fontSize: 16),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, right: 15, bottom: 12),
              border: InputBorder.none,
              hintText: "Enter name".tr(),
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14)),
          onChanged: (text) {
            //
          },
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
            _scrollController.animateTo(0,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          onTap: () {
            _scrollController.animateTo(220,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
        ),
      ),
    );
  }

  Widget _buildProtocol(BuildContext context) {
    //协议说明文案
    String userPrivateProtocol = 'Apply agreement'.tr();

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 28),
      child: InkWell(
        onTap: () {
          presenter.agreementButtonPressed(context);
        },
        child: Container(
          child: RichText(
            //必传文本
            text: TextSpan(
              text: "Please read the ".tr(),
              style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontSize: 12,
                height: 1.5,
                decoration: TextDecoration.underline,
              ),
              //手势监听
              // recognizer: ,
              children: [
                TextSpan(
                  text: "${"Application Card Agreement".tr()}",
                  style: TextStyle(
                      color: AppStatus.shared.bgBlueColor,
                      decoration: TextDecoration.underline,
                      fontSize: 12),
                ),
                TextSpan(
                  text: userPrivateProtocol,
                  style: TextStyle(
                      color: _theme == AppTheme.light
                          ? AppStatus.shared.bgBlackColor
                          : AppStatus.shared.bgWhiteColor,
                      decoration: TextDecoration.underline,
                      fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 50, top: 20),
      child: InkWell(
        onTap: () {
          //
          FocusScope.of(context).unfocus();
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

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 50, top: 20),
      child: InkWell(
        onTap: () {
          //
          FocusScope.of(context).unfocus();
          showActivationConfirmationDiolog(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff232323),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    "Cancel".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppStatus.shared.bgBlueColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    "Pay".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
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
    CardInfoModel m = presenter.models[_currentPageIndex];
    String amout =
        "${presenter.walletModel?.balance ?? "0.0"} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : presenter.walletModel?.currency ?? "USDT"}";
    return StreamBuilder<int>(
        stream: applyStreamController.stream,
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
                    'Activation Confirmation'.tr(),
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
                            'Activation fee'.tr(),
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Text(
                            '-${m.open_fee} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : m.open_fee_unit}',
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
                              color: (presenter.applying)
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
                                    color: (presenter.applying)
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
                            if (presenter.applying) {
                              return;
                            }
                            presenter.applying = true;
                            applyStreamController.add(0);
                            //申请
                            // Navigator.pop(context);
                            String cardName = _cardNameController.text;
                            int level = m.level;
                            presenter.applyConfirmPressed(
                                context, level, cardName, m.level_name);
                          },
                          child: Container(
                            height: 44,
                            width: 100,
                            decoration: BoxDecoration(
                              color: (presenter.applying)
                                  ? ColorsUtil.hexColor(0x1241a5)
                                  : AppStatus.shared.bgBlueColor,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Center(
                              child: Text(
                                "Confirm".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: (presenter.applying)
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

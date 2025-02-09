import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';
import 'package:ucardtemp/Scenes/HomePage/Entity/MycardsModel.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
import '../Presenter/CardSettingPresenter.dart';

class CardSettingView extends StatelessWidget {
  final CardSettingPresenter presenter;

  ScrollController _scrollController = ScrollController();

  bool _switchFlag = false;
  String cardName = '';
  final TextEditingController _cardNameController =
      TextEditingController(text: '');
  StreamController<int> streamController = StreamController.broadcast();

  //当前选择的卡片
  int _currentPageIndex = 0;

  CardSettingView(this.presenter);

  AppTheme _theme = AppTheme.dark;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
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
            "Card settings".tr(),
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
        body: StreamBuilder<int>(
            stream: streamController.stream,
            builder: (context, snapshot) {
              return Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  color: theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : AppStatus.shared.bgBlackColor,
                  child: SafeArea(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPageIndexView(context),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 15, right: 15, top: 16),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 30,
                            child: Text(
                              'My cards'.tr(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppStatus.shared.textGreyColor,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _buildCardsView(context),
                        _buildCardName(context),
                        _buildHideName(context),
                        _buildUserInfoView(context),
                        Expanded(
                            child: Column(
                          children: [Spacer(), CancellationButton(context)],
                        )),
                      ],
                    ),
                  ),
                ),
              );
            }),
      );
    });
  }

  //指示器
  Widget _buildPageIndexView(BuildContext context) {
    if (presenter.cardsList.length < 2) {
      return Container();
    }
    var lineWidth =
        MediaQuery.of(context).size.width / presenter.cardsList.length;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(presenter.cardsList.length, (i) {
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

  Widget _buildCardsView(BuildContext context) {
    if (presenter.cardsList.isEmpty) {
      return Container();
    }
    return Container(
      height: 184.0 / 327 * (MediaQuery.of(context).size.width - 40),
      width: (MediaQuery.of(context).size.width),
      child: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              _currentPageIndex = index;
              streamController.add(0);
            },
            scrollDirection: Axis.horizontal,
            children: presenter.cardsList.map((element) {
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
                          child: Image.asset(
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
                        visible: element.img1.isNotEmpty,
                        child: Positioned(
                          child: Image.network(element.img1),
                          left: 20,
                          top: 18,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Visibility(
                        visible: element.img2.isNotEmpty,
                        child: Positioned(
                          child: Image.network(element.img2),
                          top: 45,
                          left: (MediaQuery.of(context).size.width - 136) / 2,
                          width: 100,
                          height: 100,
                        ),
                      ),
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
                        visible: element.hide_name == 1 ? false : true,
                        child: Positioned(
                          child: Text(
                            element.card_name,
                            style: TextStyle(
                                color: _theme == AppTheme.light
                                    ? AppStatus.shared.bgBlackColor
                                    : AppStatus.shared.bgWhiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                          left: 20,
                          bottom: 22,
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
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardName(BuildContext context) {
    if (presenter.cardsList.isEmpty) {
      return Container();
    }
    MycardsModel m = presenter.cardsList[_currentPageIndex];
    String cardName = m.card_name;
    if (m.card_name.isEmpty) {
      // if (m.card_type == "master") {
      cardName = 'Create'.tr();
      // }
    }
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 15, right: 15),
      child: InkWell(
        onTap: () {
          // if (m.card_type == "master") {
          showCardNameContentView(context);
          // }
        },
        child: Container(
          height: 48,
          child: Row(
            children: [
              Text(
                'Name'.tr(),
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
                  cardName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppStatus.shared.textGreyColor,
                  ),
                ),
              ),
              Visibility(
                visible: true,
                // visible: m.card_type == "master",
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Image.asset(A.assets_mine_arrow_right),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHideName(BuildContext context) {
    if (presenter.cardsList.isEmpty) {
      return Container();
    }
    MycardsModel m = presenter.cardsList[_currentPageIndex];
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Container(
        height: 48,
        child: Row(
          children: [
            Text(
              'Hide name'.tr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
              ),
            ),
            Spacer(),
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                activeColor: AppStatus.shared.bgBlueColor,
                trackColor: const Color.fromRGBO(169, 169, 169, 1),
                thumbColor: Colors.white,
                value: m.hide_name == 1 ? true : false,
                onChanged: (value) {
                  //更新名字状态
                  presenter.cardsList[_currentPageIndex].hide_name =
                      value ? 1 : 0;
                  streamController.add(0);
                  presenter.setCardPressed(
                      context, m.card_order, '', value ? 1 : 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoView(BuildContext context) {
    if (presenter.cardsList.isEmpty) {
      return Container();
    }
    MycardsModel m = presenter.cardsList[_currentPageIndex];
    return Visibility(
      visible: false,
      // visible: m.card_type == "visa",
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: InkWell(
          onTap: () {
            presenter.toCardUserInfoPage(context);
          },
          child: Container(
            height: 48,
            child: Row(
              children: [
                Text(
                  'User information'.tr(),
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
                  padding: EdgeInsets.only(right: 16),
                  child: Image.asset(A.assets_mine_arrow_right),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget CancellationButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showUpdateEmailPhoneDiolog(context);
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: Center(
          child: Text(
            "Cancel card".tr(),
            style: TextStyle(color: AppStatus.shared.bgBlueColor, fontSize: 16),
          ),
        ),
      ),
    );
  }

  //底部弹窗
  showCardNameContentView(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.68),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context2, StateSetter mystate) {
            return Container(
              decoration: BoxDecoration(
                  color: ColorsUtil.hexColor(0x252525),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CloseButtonView(context),
                  cardnameInputView(context),
                  SureButtonWidget(context),
                ],
              ),
            );
          });
        }).whenComplete(() {});
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
                "Name".tr(),
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
                  cardName = "";
                  _cardNameController.text = cardName;
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, color: Colors.white, size: 24)),
          )
        ],
      ),
    );
  }

  Widget cardnameInputView(BuildContext context) {
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
              obscureText: false,
              autofocus: true,
              controller: _cardNameController,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 15),
                  border: InputBorder.none,
                  hintText: "Please enter name".tr(),
                  hintStyle: TextStyle(color: AppStatus.shared.textGreyColor)),
              onChanged: (text) {
                cardName = text;
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
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
              //调用接口修改卡名
              presenter.cardsList[_currentPageIndex].card_name =
                  _cardNameController.text;
              streamController.add(0);
              presenter.setCardPressed(
                  context,
                  presenter.cardsList[_currentPageIndex].card_order,
                  _cardNameController.text,
                  presenter.cardsList[_currentPageIndex].hide_name);
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

  //取消弹窗
  showUpdateEmailPhoneDiolog(BuildContext context) {
    var content = 'Cancel card note'.tr() +
        "\$${presenter.cardsList[_currentPageIndex].close_fee} ${presenter.cardsList[_currentPageIndex].close_fee_unit}" +
        "Cancel card note1".tr();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 210),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context2, StateSetter mystate) {
            return Container(
              decoration: BoxDecoration(
                  color: ColorsUtil.hexColor(0x2E2E2E),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: _buildInfoDialogContent(context, content),
            );
          });
        }).whenComplete(() {});
  }

  Widget _buildInfoDialogContent(BuildContext context, String content) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Text(
              content,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
                  child: InkWell(
                    onTap: () {
                      //确认
                      String cardOrder =
                          presenter.cardsList[_currentPageIndex].card_order;
                      presenter.cardDeleteConfirm(context, cardOrder);
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
                      //取消
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
}

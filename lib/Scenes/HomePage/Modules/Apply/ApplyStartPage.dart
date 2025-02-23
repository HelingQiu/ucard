import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_lifecycle/flutter_page_lifecycle.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Entity/CardTypeModel.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Modules/ApplyUserInfo/ApplyUserInfoBuilder.dart';

import '../../../../Common/ColorUtil.dart';
import '../../../../Common/ShowMessage.dart';
import '../../../../Data/AppStatus.dart';
import '../../../../Data/UserInfo.dart';
import '../../../../Network/Api.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';
import 'Builder/ApplyBuilder.dart';
import 'Modules/AddressInfo/AddressSingleton.dart';

class ApplyStartPage extends StatefulWidget {
  @override
  ApplyStartPageState createState() => ApplyStartPageState();
}

class ApplyStartPageState extends State<ApplyStartPage> {
  List<CardTypeModel> virtualModels = [];
  List<CardTypeModel> physicalModels = [];
  var selectIndex = 1;

  @override
  void initState() {
    super.initState();
    getCardtypesData();
  }

  //卡类型
  Future<Map> fetchCardtypes() async {
    var result = await Api()
        .post1("/api/card/cardtypes", {"lang": AppStatus.shared.lang}, true);
    debugPrint("cardtypes = $result");

    var dic = json.decode(result);
    if (dic != null) {
      var data = dic["data"];
      if (data != null) {
        return data;
      }
    }
    return {};
  }

  getCardtypesData() async {
    var data = await fetchCardtypes();
    debugPrint('cardtypes $data');

    var virtualList = data["virtual"];
    var physicalList = data["physical"];

    virtualList.forEach((element) {
      if (element is Map<String, dynamic>) {
        var model = CardTypeModel.parse(element);
        if (model.service == 1) {
          model.isPhysial = false;
        } else {
          model.isPhysial = true;
        }
        virtualModels.add(model);
      }
    });

    physicalList.forEach((element) {
      if (element is Map<String, dynamic>) {
        var model = CardTypeModel.parse(element);
        model.isPhysial = true;
        physicalModels.add(model);
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  AppTheme _theme = AppTheme.dark;

  bool isSelectHK = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      var tempList = virtualModels;
      if (selectIndex == 0) {
        tempList = virtualModels;
      } else {
        tempList = physicalModels;
      }
      // AddressSingleton.shared.shippingDict = null;
      // AddressSingleton.shared.mailingDict = null;
      // AddressSingleton.shared.residentialDict = null;
      return PageLifecycle(
        stateChanged: (appear) {
          if (appear) {
            AddressSingleton.shared.shippingDict = null;
            AddressSingleton.shared.mailingDict = null;
            AddressSingleton.shared.residentialDict = null;
          }
        },
        child: Scaffold(
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
          body: Container(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgWhiteColor
                : AppStatus.shared.bgBlackColor,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   height: 32,
                  // ),
                  Container(
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
                            selectIndex = 1;
                            setState(() {});
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: selectIndex == 0
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
                                Text("Physical Card".tr()),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            selectIndex = 0;
                            setState(() {});
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: selectIndex == 0
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
                                Text("Virtual Card".tr()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: tempList.map((element) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: InkWell(
                          onTap: () {
                            //
                            // if (element.cardType == 'visa') {
                            //   if (UserInfo.shared.email == "" ||
                            //       UserInfo.shared.phone == "") {
                            //     showDialog(
                            //         context: context,
                            //         builder: (_) {
                            //           return ShowMessage(
                            //               2,
                            //               "Please bind mobile phone/email first"
                            //                   .tr(),
                            //               dismissSeconds: 2,
                            //               styleType: 1,
                            //               width: 257);
                            //         });
                            //     return;
                            //   }
                            // }
                            if (UserInfo.shared.isKycVerified != 1 &&
                                AppStatus.shared.withdrawWithoutKyc == false) {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return ShowMessage(
                                        2,
                                        "Please Complete Identity Verification First"
                                            .tr(),
                                        dismissSeconds: 2,
                                        styleType: 1,
                                        width: 257);
                                  });
                              return;
                            }
                            if (element.toApplyUser == 1) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ApplyUserInfoBuilder(element).scene));
                              return;
                            }
                            if (selectIndex == 0) {
                              if (element.service == 3) {
                                showSafetyPinDiolog(context, element);
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ApplyBuilder(element).scene));
                              }
                            } else {
                              showSafetyPinDiolog(context, element);
                            }
                          },
                          child: _buildCell(
                              context,
                              element.cardType == 'visa'
                                  ? A.assets_apply_visa_logo1
                                  : A.assets_apply_master_card,
                              element.cardType == 'visa'
                                  ? 'Visa(${element.currency})'
                                  : element.cardType == 'master'
                                      ? 'Mastercard(${element.currency})'
                                      : 'UnionPay(${element.currency})',
                              element.cardDes),
                        ),
                      );
                    }).toList(),
                  ),
                  // Expanded(child: Container()),
                  // _buildSubmitButton(context),
                  // Container(
                  //   height: 40,
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCell(
      BuildContext context, String imageName, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
            color: _theme == AppTheme.light
                ? AppStatus.shared.bgGreyLightColor
                : AppStatus.shared.bgDarkGreyColor,
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.only(top: 25, bottom: 20, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(imageName),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                content,
                style: TextStyle(
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgBlackColor
                        : AppStatus.shared.bgWhiteColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
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
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  showSafetyPinDiolog(BuildContext context, CardTypeModel model) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 300),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context1, StateSetter mystate) {
            return Container(
              decoration: BoxDecoration(
                  color: ColorsUtil.hexColor(0x2E2E2E),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: safetyPinBottomView(context1, model, mystate),
            );
          });
        }).whenComplete(() {});
  }

  Widget safetyPinBottomView(
      BuildContext context, CardTypeModel model, StateSetter mystate) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Question:'.tr(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              'What is your current country or region of residence?'.tr(),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            Text(
              'Answer:'.tr(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 6,
            ),
            InkWell(
              onTap: () {
                mystate(() => isSelectHK = true);
              },
              child: Row(
                children: [
                  Image.asset(
                    isSelectHK
                        ? A.assets_physical_selected
                        : A.assets_phycail_unselected,
                    width: 20,
                    height: 20,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Hong Kong,China'.tr(),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () {
                mystate(() => isSelectHK = false);
              },
              child: Row(
                children: [
                  Image.asset(
                    isSelectHK
                        ? A.assets_phycail_unselected
                        : A.assets_physical_selected,
                    width: 20,
                    height: 20,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Other countries or regions'.tr(),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
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
                    padding:
                        const EdgeInsets.only(left: 10, right: 20, top: 30),
                    child: InkWell(
                      onTap: () {
                        //跳转
                        if (isSelectHK) {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ApplyBuilder(model).scene));
                        } else {
                          Navigator.pop(context);
                          Navigator.pop(context);
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
      ),
    );
  }
}

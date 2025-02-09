import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Entity/CardTypeModel.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Modules/ApplyUserInfo/ApplyUserInfoBuilder.dart';

import '../../../../Common/ShowMessage.dart';
import '../../../../Data/AppStatus.dart';
import '../../../../Data/UserInfo.dart';
import '../../../../Network/Api.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';
import 'Builder/ApplyBuilder.dart';

class ApplyStartPage extends StatefulWidget {
  @override
  ApplyStartPageState createState() => ApplyStartPageState();
}

class ApplyStartPageState extends State<ApplyStartPage> {
  List<CardTypeModel> models = [];
  var selectIndex = 0;

  @override
  void initState() {
    super.initState();
    getCardtypesData();
  }

  //卡类型
  Future<List> fetchCardtypes() async {
    var result = await Api()
        .post1("/api/card/cardtypes", {"lang": AppStatus.shared.lang}, true);
    debugPrint("cardtypes = $result");

    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["data"];
      if (code != null) {
        return code;
      }
    }
    return [];
  }

  getCardtypesData() async {
    var list = await fetchCardtypes();
    debugPrint('cardtypes $list');
    list.forEach((element) {
      if (element is Map<String, dynamic>) {
        var model = CardTypeModel.parse(element);
        models.add(model);
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
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
                        onTap:() {
                          selectIndex = 0;
                          setState(() {

                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: selectIndex == 0 ? Color(0xff2369FF):Color(0xff232323),
                          ),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(children: [
                            Image.asset(A.assets_virtual_card),
                            SizedBox(width: 20,),
                            Text("Virtual Card"),
                          ],),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          selectIndex = 1;
                          setState(() {

                          });
                        },
                        child: Container(

                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: selectIndex == 0 ? Color(0xff232323) : Color(0xff2369FF),
                          ),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(children: [
                            Image.asset(A.assets_physical_card),
                            SizedBox(width: 20,),
                            Text("Physical Card"),
                          ],),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                ListView(
                  shrinkWrap: true,
                  children: models.map((element) {
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ApplyBuilder(element).scene));
                        },
                        child: _buildCell(
                            context,
                            element.cardType == 'master'
                                ? A.assets_apply_master_card
                                : A.assets_apply_visa_logo1,
                            element.cardType == 'master'
                                ? 'Mastercard'
                                : 'Visa',
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
}

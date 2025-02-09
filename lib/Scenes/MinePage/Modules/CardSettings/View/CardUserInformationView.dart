import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../Network/Api.dart';
import '../../../../../main.dart';
import '../../../../HomePage/Modules/Apply/Entity/CardUserInfoModel.dart';

class CardUserInformationView extends StatefulWidget {
  @override
  CardUserInformationViewState createState() => CardUserInformationViewState();
}

class CardUserInformationViewState extends State<CardUserInformationView> {
  //数据
  CardUserInfoModel model = CardUserInfoModel("", "", "", "", "", "", "", "");

  AppTheme _theme = AppTheme.dark;

  @override
  void initState() {
    super.initState();
    requestUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            "User information".tr(),
            style: TextStyle(
                fontSize: 18,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEmailView(context),
              _buildPhoneView(context),
              _buildAddressView(context),
              _buildNoteView(context),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEmailView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 15, right: 10),
      child: Container(
        height: 48,
        child: Row(
          children: [
            Text(
              'Email'.tr(),
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
                model.email,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppStatus.shared.textGreyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 15, right: 10),
      child: Container(
        height: 48,
        child: Row(
          children: [
            Text(
              'Phone number'.tr(),
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
                "+${model.phone}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppStatus.shared.textGreyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 25, left: 15, right: 10),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address'.tr(),
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
                child: Column(
                  children: [
                    Text(
                      model.billing_address,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppStatus.shared.textGreyColor,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      model.billing_city,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppStatus.shared.textGreyColor,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      model.billing_state,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppStatus.shared.textGreyColor,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      model.billing_zipcode,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppStatus.shared.textGreyColor,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 15, right: 15),
      child: Text(
        "Userinfo note".tr(),
        maxLines: 10,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppStatus.shared.textGreyColor,
        ),
      ),
    );
  }

  requestUserInfo() async {
    await fetchUserInfoData();
    setState(() {});
  }

  fetchUserInfoData() async {
    var result = await Api()
        .post("/api/card/carduserinfo", {"lang": AppStatus.shared.lang}, true);
    debugPrint("${DateTime.now()}  /api/card/carduserinfo = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          if (dic["data"] != null) {
            model = CardUserInfoModel.parse(dic["data"]);
          }
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
          }
        }
      }
    }
  }
}

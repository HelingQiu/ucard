import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ucardtemp/Data/UserInfo.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/HelpCenter/HelpCenterDetail.dart';
import '../../../../Common/AgreementPage.dart';
import '../../../../Data/AppStatus.dart';
import '../../../../Network/Api.dart';
import '../../../../main.dart';

class HelpCenterPage extends StatefulWidget {
  @override
  HelpCenterPageState createState() => HelpCenterPageState();
}

class HelpCenterPageState extends State<HelpCenterPage> {
  List faqList = [];

  AppTheme _theme = AppTheme.dark;

  @override
  void initState() {
    super.initState();
    getHelpList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String path = AppStatus.shared.lang == "EN"
        ? "https://uok5217.zendesk.com/hc/en-gb"
        : AppStatus.shared.lang == "zh-CN"
            ? "https://uok5217.zendesk.com/hc/zh-cn"
            : "https://uok5217.zendesk.com/hc/zh-tw";
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
            "Help center".tr(),
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
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(path)),
          ),
          // child: Column(
          //   children: [
          //     AccountInfo(context),
          //     ListView.builder(
          //       shrinkWrap: true,
          //       itemCount: faqList.length,
          //       itemBuilder: (context, index) {
          //         return Container(
          //           height: 48,
          //           child: GestureDetector(
          //             onTap: () {
          //               Navigator.of(context).push(
          //                 MaterialPageRoute(
          //                   builder: (context) => AgreementPage(
          //                       faqList[index]["title"],
          //                       faqList[index]["href"]),
          //                 ),
          //               );
          //             },
          //             behavior: HitTestBehavior.opaque,
          //             child: Padding(
          //               padding: EdgeInsets.only(left: 15, right: 15),
          //               child: Column(
          //                 children: [
          //                   Container(
          //                     height: 48,
          //                     child: Row(
          //                       children: [
          //                         Expanded(
          //                           child: Text(
          //                             faqList[index]['title'],
          //                             style: TextStyle(
          //                               color: theme == AppTheme.light
          //                                   ? AppStatus.shared.bgBlackColor
          //                                   : AppStatus.shared.bgWhiteColor,
          //                               fontSize: 14,
          //                             ),
          //                           ),
          //                         ),
          //                         Icon(
          //                           Icons.chevron_right,
          //                           color: Colors.grey,
          //                         )
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ],
          // ),
        ),
      );
    });
  }

  getHelpList() async {
    faqList = await fetchHelpList();
    setState(() {});
  }

  Future<List> fetchHelpList() async {
    var result = await Api()
        .post("/api/conf/helplist", {"lang": AppStatus.shared.lang}, false);
    debugPrint("${DateTime.now()}  /api/conf/helplist = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          List data = dic["data"];
          if (data != null && data.isNotEmpty) {
            List<Map<String, dynamic>> list = [];
            data.forEach((element) {
              list.add(element);
            });
            return list;
          }
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
          }
        }
      }
    }
    return [];
  }

  Widget AccountInfo(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              UserInfo.shared.username,
              style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "We are here to assist you".tr(),
              style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              "FAQ".tr(),
              style: TextStyle(
                color: AppStatus.shared.textGreyColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget PrivacyPolicyView(BuildContext context) {
    String url = Api().apiUrl + "/api/otherDetail";
    debugPrint("lang = ${AppStatus.shared.lang}");
    if (AppStatus.shared.lang == "zh-CN") {
      url = url + "?id=34";
    } else if (AppStatus.shared.lang == "zh-TW") {
      url = url + "?id=1";
    } else {
      url = url + "?id=35";
    }

    return Container(
      height: 48,
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) =>
                    AgreementPage("Privacy Policy".tr(), url)));
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                Container(
                  height: 48,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Privacy Policy".tr(),
                          style: TextStyle(
                            color: _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget EarnProductAgreementView(BuildContext context) {
    String url = Api().apiUrl + "/api/otherDetail";
    if (AppStatus.shared.lang == "zh-CN") {
      url = url + "?id=9";
    } else if (AppStatus.shared.lang == "zh-TW") {
      url = url + "?id=19";
    } else {
      url = url + "?id=17";
    }
    return Container(
      height: 48,
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) =>
                    AgreementPage("Earn Product Agreement".tr(), url)));
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                Container(
                  height: 48,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Earn Product Agreement".tr(),
                          style: TextStyle(
                            color: _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget TermsOfServiceAgreementView(BuildContext context) {
    String url = Api().apiUrl + "/api/otherDetail";
    if (AppStatus.shared.lang == "zh-CN") {
      url = url + "?id=4";
    } else if (AppStatus.shared.lang == "zh-TW") {
      url = url + "?id=18";
    } else {
      url = url + "?id=16";
    }
    return Container(
      height: 48,
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) =>
                    AgreementPage("Terms of Service".tr(), url)));
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                Container(
                  height: 48,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Terms of Service".tr(),
                          style: TextStyle(
                            color: _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget WalletAgreementView(BuildContext context) {
    String url = Api().apiUrl + "/api/otherDetail";
    if (AppStatus.shared.lang == "zh-CN") {
      url = url + "?id=30";
    } else if (AppStatus.shared.lang == "zh-TW") {
      url = url + "?id=31";
    } else {
      url = url + "?id=32";
    }
    return Container(
      height: 48,
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) =>
                    AgreementPage("Wallet/Account Agreement".tr(), url)));
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                Container(
                  height: 48,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Wallet/Account Agreement".tr(),
                          style: TextStyle(
                            color: _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

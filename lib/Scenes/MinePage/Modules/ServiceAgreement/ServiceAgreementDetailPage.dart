import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Network/Api.dart';
import '../../../../main.dart';

class ServiceAgreementDetailPage extends StatefulWidget {
  String code;
  String title;
  ServiceAgreementDetailPage(this.code, this.title);

  @override
  ServiceAgreementDetailPageState createState() =>
      ServiceAgreementDetailPageState();
}

class ServiceAgreementDetailPageState
    extends State<ServiceAgreementDetailPage> {
  Map agreementMap = {};

  AppTheme _theme = AppTheme.dark;

  @override
  void initState() {
    super.initState();
    getAgreementDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("helllooooo=====${agreementMap["content"]}");
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
            widget.title,
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
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgWhiteColor
                : AppStatus.shared.bgBlackColor,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  agreementMap['title'],
                  style: TextStyle(
                      color: theme == AppTheme.light
                          ? AppStatus.shared.bgBlackColor
                          : AppStatus.shared.bgWhiteColor,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 20,
                ),
                Html(
                  data: agreementMap["content"],
                  style: {
                    "p": Style(
                        color: theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor),
                  },
                ),
                // InAppWebView(
                //   initialData: InAppWebViewInitialData(
                //       data: faqMap["content"] ?? "1222222"),
                // ),
                // RichText(
                //   text: TextSpan(
                //     text: faqMap["content"],
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }

  getAgreementDetail() async {
    agreementMap = await fetchAgreementDetail();
    setState(() {});
  }

  Future<Map> fetchAgreementDetail() async {
    var result = await Api().post("/api/conf/agreementinfo",
        {"code": widget.code, "lang": AppStatus.shared.lang}, true);
    debugPrint("${DateTime.now()}  fetchAgreementDetail = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          Map data = dic["data"];
          return data;
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
          }
        }
      }
    }
    return {};
  }
}

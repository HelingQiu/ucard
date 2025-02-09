import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Network/Api.dart';
import '../../../../main.dart';

class HelpCenterDetailPage extends StatefulWidget {
  int helpId;
  String title;
  HelpCenterDetailPage(this.helpId, this.title);

  @override
  HelpCenterDetailPageState createState() => HelpCenterDetailPageState();
}

class HelpCenterDetailPageState extends State<HelpCenterDetailPage> {
  Map faqMap = {};

  AppTheme _theme = AppTheme.dark;

  @override
  void initState() {
    super.initState();
    getHelpDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("helllooooo=====${faqMap["content"]}");
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
                  faqMap['title'],
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
                  data: faqMap["content"],
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

  getHelpDetail() async {
    faqMap = await fetchHelpDetail();
    setState(() {});
  }

  Future<Map> fetchHelpDetail() async {
    var result = await Api().post("/api/conf/helpinfo",
        {"id": widget.helpId, "lang": AppStatus.shared.lang}, true);
    debugPrint("${DateTime.now()}  fetchHelpDetail = $result");
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

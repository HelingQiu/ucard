import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import '../Data/AppStatus.dart';
import '../main.dart';

class AgreementPage extends StatefulWidget {
  String title;
  String url;

  AgreementPage(this.title, this.url);

  @override
  AgreementPageState createState() => AgreementPageState();
}

class AgreementPageState extends State<AgreementPage> {
  AppTheme _theme = AppTheme.dark;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late InAppWebViewController inAppWebViewController;

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
            title: Text(widget.title,
                style: TextStyle(
                    fontSize: 18,
                    color: theme == AppTheme.light
                        ? AppStatus.shared.bgBlackColor
                        : AppStatus.shared.bgWhiteColor)),
            backgroundColor: theme == AppTheme.light
                ? AppStatus.shared.bgWhiteColor
                : AppStatus.shared.bgBlackColor,
          ),
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          body: Container(
            color: AppStatus.shared.bgBlackColor,
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
              onLoadStop: (controller, url) async {
                // 加载完成
                inAppWebViewController = controller;
                print("加载地址：$url");
                var html = await controller.getHtml();
                debugPrint("html是：${html.toString().trim()}");
              },
            ),
            // child: WebViewWidget(
            //   // initialUrl: widget.url,
            //   // backgroundColor: theme == AppTheme.light
            //   //     ? AppStatus.shared.bgWhiteColor
            //   //     : AppStatus.shared.bgBlackColor,
            //
            //   controller: WebViewController()
            //     ..loadRequest(Uri.parse(widget.url)),
            // ),
          ));
    });
  }
}

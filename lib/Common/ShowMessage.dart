import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Data/AppStatus.dart';
import 'package:ucardtemp/Common/StringExtension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class ShowMessage extends StatefulWidget {
  String title;
  int type; //1:success  2:fail
  int dismissSeconds;
  int styleType; //0:big default   1: small   2: update new version  3： force update  4: message+button
  double width;
  String content; // styleType:2
  String secondContent; // styleType:2
  String buttonTitle; //styletype :4
  VoidCallback? button1Callback;

  ShowMessage(this.type, this.title,
      {this.dismissSeconds = 3,
      this.styleType = 0,
      this.width = 0,
      this.content = "",
      this.secondContent = "",
      this.buttonTitle = "",
      this.button1Callback = null});

  @override
  ShowMessageState createState() => ShowMessageState();
}

class ShowMessageState extends State<ShowMessage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dismissSeconds > 0 && widget.styleType != 0) {
      Future.delayed(Duration(seconds: widget.dismissSeconds), () {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(true);
        }
      });
    }
    if (widget.styleType == 1) {
      return Dialog(
        // insetPadding: EdgeInsets.zero,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(5),
        // ),
        // elevation: 0,
        backgroundColor: Colors.transparent,
        child: SmallContentBox(context),
      );
    } else if (widget.styleType == 2 || widget.styleType == 3) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0,
        backgroundColor: AppStatus.shared.bgGreyColor,
        child: Type3Content(context),
      );
    } else if (widget.styleType == 4) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0,
        backgroundColor: AppStatus.shared.bgGreyColor,
        child: Type4Content(context),
      );
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      backgroundColor: AppStatus.shared.bgGreyColor,
      child: ContentBox(context),
    );
  }

  Widget ContentBox(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppStatus.shared.bgGreyColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 57,
            width: 57,
            child: Image.asset(widget.type == 1
                ? "assets/show_success.png"
                : "assets/show_fail.png"),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: FittedBox(
              child: Text(
                widget.title == "" ? " " : widget.title,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              fit: BoxFit.scaleDown,
            ),
          )
        ],
      ),
    );
  }

  Widget SmallContentBox(BuildContext context) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.title, style: TextStyle(fontSize: 14)),
      maxLines: null,
      textDirection: ui.TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: widget.width);
    var height = textPainter.height + 24;
    var width = widget.title.textSize(TextStyle(fontSize: 14)).width + 20;
    if (width > widget.width) {
      width = widget.width;
    }
    debugPrint("height = $height   width = $width");
    return Container(
      width: width,
      height: height,
      child: Column(
        children: [
          Container(
              width: width,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color.fromRGBO(63, 70, 105, 1),
                borderRadius: BorderRadius.circular(3),
                // boxShadow: [
                //   BoxShadow(color: Color.fromRGBO(63, 70, 105, 1),offset: Offset(0,10),
                //       blurRadius: 10
                //   ),
                // ]
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    )),
              ))
        ],
      ),
    );
  }

  Widget Type3Content(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: FittedBox(
            child: Text(
              widget.title == "" ? " " : widget.title,
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            fit: BoxFit.scaleDown,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Text(
            widget.content,
            maxLines: 20,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        (widget.secondContent == ""
            ? Container()
            : Padding(
                padding: EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Text(widget.secondContent,
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 20),
              child: ElevatedButton(
                child: SizedBox(
                  width: 80,
                  height: 44,
                  child: Center(
                    child: Text(
                      "Close".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppStatus.shared.bgBlueColor),
                onPressed: () {
                  if (widget.styleType == 2) {
                    AppStatus.shared.canPopAd = true;
                    Navigator.of(context).pop(true);
                    if (widget.button1Callback != null) {
                      widget.button1Callback!();
                    }
                  } else if (widget.styleType == 3) {
                    exit(0);
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 10, top: 10, bottom: 20),
              child: ElevatedButton(
                child: SizedBox(
                  width: 80,
                  height: 44,
                  child: Center(
                    child: Text(
                      "Update".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppStatus.shared.bgBlueColor),
                onPressed: () {
                  jumpToStore();
                },
              ),
            )
          ],
        )
      ],
    ));
  }

  Widget Type4Content(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: FittedBox(
            child: Text(
              widget.title == "" ? " " : widget.title,
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            fit: BoxFit.scaleDown,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Text(
            widget.content,
            maxLines: 20,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        (widget.secondContent == ""
            ? Container()
            : Padding(
                padding: EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Text(widget.secondContent,
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              )),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 5, top: 30, bottom: 20),
          child: ElevatedButton(
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: Center(
                child: Text(
                  widget.buttonTitle == "" ? "OK".tr() : widget.buttonTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
                elevation: 0, backgroundColor: AppStatus.shared.bgBlueColor),
            onPressed: () {
              Navigator.of(context).pop(true);
              if (widget.button1Callback != null) {
                widget.button1Callback!();
              }
            },
          ),
        )
      ],
    ));
  }

  jumpToStore() {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid ? 'com.ucard.application' : '1614125568';
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=?id=$appId"
            : "https://apps.apple.com/app/id/$appId",
      );
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}

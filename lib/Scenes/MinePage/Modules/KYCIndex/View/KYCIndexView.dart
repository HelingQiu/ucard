import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Common/StreamCenter.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/LoginCenter.dart';
import '../../../../../Data/UserInfo.dart';
import '../../../../../main.dart';
import '../Presenter/KYCIndexPresenter.dart';
import 'dart:async';

// import 'package:jumio_mobile_sdk_flutter/jumio_mobile_sdk_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class KYCIndexView extends StatelessWidget {
  final KYCIndexPresenter presenter;
  bool showKyc = false;
  StreamController<int> kycStreamController = StreamController();
  bool begin = false;

  KYCIndexView(this.presenter);

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    if (begin == false) {
      begin = true;
      presenter.fetchAccessToken(context);
    }
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
          centerTitle: true,
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          title: Text(
            "KYC",
            style: TextStyle(
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
        ),
        body: StreamBuilder<int>(
            stream: kycStreamController.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container(
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgWhiteColor
                    : AppStatus.shared.bgBlackColor,
                child: SafeArea(
                    child: Center(
                  child: Text(
                    showKyc ? "" : "Wait...".tr(),
                    style: TextStyle(
                        color: theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        fontSize: 20),
                  ),
                )),
              );
            }),
      );
    });
  }

  Widget BasicKyc(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(187, 209, 255, 1),
              Color.fromRGBO(218, 230, 255, 1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Basic Information".tr(),
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ),
                    Text("Reword: xxx BTC",
                        style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  "Finish >",
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget AdvancedKyc(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(135, 172, 252, 1),
              Color.fromRGBO(181, 204, 255, 1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Advanced Information",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ),
                    Text("Reword: xxx BTC",
                        style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  "Finish >",
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget AddressKyc(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(153, 151, 253, 1),
              Color.fromRGBO(119, 162, 255, 1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verify Address",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ),
                    Text("Reword: xxx BTC",
                        style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  "Finish >",
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showKycView(BuildContext context) {
    showKyc = true;
    kycStreamController.add(1);
    _start(context, UserInfo.shared.kycAuthorizationToken);
  }

  Future<void> _start(BuildContext context, String authorizationToken) async {
    await _logErrors(context, () async {
      // await Jumio.init(authorizationToken, "SG");
      // final result = await Jumio.start({
      //   "background": "#141722",
      //   "primaryColor": "#FFCD00",
      //   "loadingCirclePlain": "#FFCD00",
      //   "textForegroundColor": "#FFFFFF",
      //   "navigationIconColor": "#FFFFFF",
      //   "primaryButtonBackground": "#FFCD00",
      //   "primaryButtonBackgroundPressed": "#B38F00",
      //   "bubbleBackground": "#1A202E",
      //   "bubbleForeground": "#FFFFFF",
      //   "searchBubbleForeground": "FFFFFF"
      // });
      // await _showDialogWithMessage(
      //     "Jumio has completed. Result: $result", context);
    });
  }

  Future<void> _logErrors(
      BuildContext context, Future<void> Function() block) async {
    try {
      await block();
    } catch (error) {
      await _showDialogWithMessage(error.toString(), context, "Error");
    }
  }

  Future<void> _showDialogWithMessage(String message, BuildContext context,
      [String title = "Result"]) async {
    debugPrint("kyc result = $message");
    bool hasError = false;
    if (title == "Error") {
      hasError = true;
    } else if (message.contains("errorCode")) {
      hasError = true;
    }
    if (hasError == false) {
      UserInfo.shared.uploadAccountId();
      LoginCenter().fetchUserInfo();
      StreamCenter.shared.profileStreamController.add(0);
    } else {
      StreamCenter.shared.profileStreamController.add(0);
      Navigator.of(context).pop();
      return;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color.fromRGBO(29, 40, 67, 1),
          child: Container(
            height: 215,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 5),
                  child: Text(
                    hasError ? "Error".tr() : "Complete".tr(),
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    hasError ? message : "Please wait for review".tr(),
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                )),
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text('OK'.tr()),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop(true);
                        }
                        StreamCenter.shared.profileStreamController.add(1);
                        StreamCenter.shared.newUserTaskStreamController.add(1);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

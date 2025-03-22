import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// import 'package:jumio_mobile_sdk_flutter/jumio_mobile_sdk_flutter.dart';
import '../../../../../Data/UserInfo.dart';

class KYCIDVerificationView extends StatefulWidget {
  bool start;

  KYCIDVerificationView(this.start);

  @override
  KYCIDVerificationViewState createState() => KYCIDVerificationViewState();
}

class KYCIDVerificationViewState extends State<KYCIDVerificationView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("KYCIDVerificationViewState start = ${widget.start}");

    return Scaffold(
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                child: Text("Start".tr()),
                onPressed: () {
                  _start(context, UserInfo.shared.kycAuthorizationToken);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  //
  // start() async {
  //   print("kyc start");
  //   Future.delayed(Duration(milliseconds: 300), () {
  //     _start(context, UserInfo.shared.kycAuthorizationToken);
  //   });
  // }

  Future<void> _start(BuildContext context, String authorizationToken) async {
    // await _logErrors(context, () async {
    //   await Jumio.init(authorizationToken, "SG");
    //   final result = await Jumio.start();
    //   await _showDialogWithMessage(
    //       "Jumio has completed. Result: $result", context);
    // });
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
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: Text(message)),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'dart:math';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../../../../Common/ShowMessage.dart';
import '../../../../Common/StreamCenter.dart';
import '../../../../Data/AppStatus.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';
import '../../Entity/AddressModel.dart';

class QrcodeView extends StatefulWidget {
  AddressModel model;
  QrcodeView(this.model) {}

  @override
  QrcodeViewState createState() => QrcodeViewState();
}

class QrcodeViewState extends State<QrcodeView> {
  ScreenshotController screenshotController = ScreenshotController();

  QrcodeViewState();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      screenShot();
    });
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
          body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
              ),
              ContentView(),
              Container(
                height: 40,
              ),
              LogoView(),
            ],
          ),
        ),
      ));
    });
  }

  Widget LogoView() {
    return Container(
      child: Center(
        child: Row(
          children: [
            Spacer(),
            Image.asset(A.assets_wallet_logo),
            SizedBox(
              width: 6,
            ),
            Image.asset(A.assets_wallet_logo_name),
            Spacer()
          ],
        ),
      ),
    );
  }

  Widget ContentView() {
    double width = MediaQuery.of(context).size.width - 20;
    width = min(width, 330);
    String time = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String network = (widget.model.blockchain == "BEP20")
        ? ":BEP20/BNB Smart Chain"
        : ":ERC20/Ethereum";
    return Container(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ColorsUtil.hexColor(0x0D4BD1, alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 34),
              child: Text(
                "USDT",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 28,
            ),
            QrContent(width - 60),
            Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
              child: Text(
                widget.model.address,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: Row(
                children: [
                  Text(
                    "Network".tr() + network,
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                  Spacer(),
                  Text(
                    "$time",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget QrContent(double width) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: QrImageView(
        data: widget.model.address,
        size: width,
        version: 3,
      ),
    );
  }

  screenShot() async {
    if (this.mounted) {
      if (await Permission.storage.request().isGranted) {
        debugPrint("Permission.storage.request().isGranted");
        screenshotController.capture().then((Uint8List? image) {
          if (image != null) {
            saveImage(image);
          }
        });
      } else {
        debugPrint("Permission.storage defy");
      }
    }
  }

  saveImage(Uint8List capturedImage) async {
    final result = await ImageGallerySaver.saveImage(capturedImage);
    bool isSuccess = result["isSuccess"];
    if (isSuccess != null && isSuccess == true) {
      // debugPrint("save image result = $result");
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(1, "Saved to album".tr(),
                styleType: 1, width: 257, dismissSeconds: 2);
          });
    } else {
      // debugPrint("save image  false");
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(2, "Fail to saved image".tr(),
                styleType: 1, width: 257);
          });
    }
    Future.delayed(Duration(seconds: 2))
        .then((value) => {StreamCenter.shared.depositStreamController.add(1)});
  }
}

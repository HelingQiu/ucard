import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_utils/qr_code_utils.dart';
import 'dart:io';

import '../../../../Data/AppStatus.dart';
import '../../../../gen_a/A.dart';
import 'ScanView.dart';

class QrcodeScanView extends StatefulWidget {
  final void Function(String str) scanResult;
  final VoidCallback hide;

  QrcodeScanView(this.scanResult, this.hide);

  @override
  QrcodeScanViewState createState() => QrcodeScanViewState();
}

class QrcodeScanViewState extends State<QrcodeScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  ScanController scancontroller = ScanController();

  QrcodeScanViewState() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (controller != null) {
        if (Platform.isAndroid) {
          controller!.pauseCamera();
        }
        controller!.resumeCamera();
      }
    });
  }

  /// 动态申请权限
  /// 授予权限返回true， 否则返回false
  static Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.camera.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.camera.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // initPermission();
    // Future.delayed(Duration(milliseconds: 300), () {
    //   if (controller != null) {
    //     if (Platform.isAndroid) {
    //       controller!.pauseCamera();
    //     }
    //     controller!.resumeCamera();
    //     debugPrint('hhhhhhhhhh');
    //   }
    // });
    debugPrint('hhhhhhhhhh');
  }

  void initPermission() {
    requestLocationPermission().then((rel) {
      if (!rel) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 40,
        backgroundColor: AppStatus.shared.bgBlackColor,
        title: Text(
          'Scan QR Code'.tr(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: AppStatus.shared.bgBlackColor,
      body: GestureDetector(
        onTap: () {
          widget.hide();
        },
        child: Container(
          color: AppStatus.shared.bgBlackColor,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 128,
              ),
              Container(
                width: 274,
                height: 274,
                child: Stack(
                  children: [
                    Positioned(
                      child: Image.asset(A.assets_scan_topleft),
                      left: 0,
                      top: 0,
                    ),
                    Positioned(
                      child: Image.asset(A.assets_scan_topright),
                      right: 0,
                      top: 0,
                    ),
                    Positioned(
                      child: Image.asset(A.assets_scan_bottomleft),
                      left: 0,
                      bottom: 0,
                    ),
                    Positioned(
                      child: Image.asset(A.assets_scan_bottomright),
                      right: 0,
                      bottom: 0,
                    ),
                    Positioned(
                      left: 4,
                      right: 4,
                      top: 4,
                      bottom: 4,
                      child: Container(
                        width: 268,
                        height: 268,
                        color: Colors.transparent,
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Put the QR code into the box'.tr(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 100,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      scanAlbumButtonPressed();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Stack(
                        children: [
                          Image.asset(A.assets_scan_photo_bg),
                          Center(
                            child: Image.asset(A.assets_scan_photo),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Photo'.tr(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        debugPrint("scanCarame = $result");
        if (result != null && result!.code != null) {
          controller.pauseCamera();
          String c = result!.code!;
          widget.scanResult(c);
          Navigator.of(context).pop();
        }
      });
    });
  }

  scanAlbumButtonPressed() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var data = await QrCodeUtils.decodeFrom(image!.path);
    debugPrint("scanAlbum = $data");
    if (data != null && data != "") {
      String c = data;
      widget.scanResult(c);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Data/AppStatus.dart';
import '../../../../gen_a/A.dart';
import "dart:io" show Platform;

class BiometricsSettingPage extends StatefulWidget {
  @override
  BiometricsSettingPageState createState() => BiometricsSettingPageState();
}

class BiometricsSettingPageState extends State<BiometricsSettingPage> {
  /// 本地认证框架
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    setDonotTip();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppStatus.shared.bgBlackColor,
      body: Stack(
        children: [
          Positioned(
            top: 193,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Image.asset(Platform.isAndroid
                      ? A.assets_ic_finger
                      : A.assets_ic_faceid),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    Platform.isAndroid
                        ? "Set up Touch ID".tr()
                        : "Set up Face ID".tr(),
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height - 188,
            left: 40,
            right: 40,
            child: Column(
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      elevation: null,
                      backgroundColor: MaterialStateProperty.all(
                          AppStatus.shared.bgBlueColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.height - 80,
                      height: 44,
                      child: Center(
                        child: Text(
                          "Continue".tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      //去生物识别
                      bool isSuccess = await authenticate();
                      debugPrint("识别结果：$isSuccess");
                      setSwitchFlag(isSuccess);
                      if (isSuccess) {
                        Navigator.of(context).pop();
                      } else {}
                    }),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      elevation: null,
                      backgroundColor: MaterialStateProperty.all(
                          AppStatus.shared.bgDarkGreyColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.height - 80,
                      height: 44,
                      child: Center(
                        child: Text(
                          "Skip".tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      //
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //去识别
  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
          localizedReason: 'biometrics please'.tr(),
          options: const AuthenticationOptions(
              biometricOnly: true, useErrorDialogs: true, stickyAuth: true));
    } on PlatformException catch (e) {
      debugPrint("authenticate: $e");
      return false;
    }
  }

  //设置本地开关
  void setSwitchFlag(bool flag) async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    perf.setBool("BiometricsFlag", flag);
  }

  //第一次提示后，以后不再提示
  void setDonotTip() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    perf.setBool("first finger", true);
  }
}

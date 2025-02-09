import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';
import "dart:io" show Platform;
import '../../../../Common/NumberPlus.dart';
import '../../../../Data/AppStatus.dart';
import '../../../../Data/UserInfo.dart';
import '../../../../gen_a/A.dart';
import '../../../LoginPage/Builder/LoginBuilder.dart';

class BiometricsUnlockPage extends StatefulWidget {
  @override
  BiometricsUnlockState createState() => BiometricsUnlockState();
}

class BiometricsUnlockState extends State<BiometricsUnlockPage> {
  /// 本地认证框架
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    startBiometrics();
  }

  @override
  void dispose() {
    super.dispose();
  }

  startBiometrics() async {
    bool result = await authenticate();
    if (result) {
      Navigator.of(context).pop();
    }
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
                  GestureDetector(
                    onTap: () async {
                      startBiometrics();
                    },
                    child: Image.asset(Platform.isAndroid
                        ? A.assets_ic_finger
                        : A.assets_ic_faceid),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    UserInfo.shared.email != ""
                        ? NumberPlus.getSecurityEmail(UserInfo.shared.email)
                        : UserInfo.shared.phone != ""
                            ? NumberPlus.getSecurityEmail(UserInfo.shared.phone)
                            : "",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    Platform.isAndroid
                        ? "Touch to unlock with Touch ID".tr()
                        : "Touch to unlock with Face ID".tr(),
                    style: TextStyle(
                        color: AppStatus.shared.textGreyColor, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height - 120,
            left: 40,
            right: 40,
            child: Column(
              children: [
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
                          "Switch to password login".tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      //退出并登录
                      Navigator.of(context).pop();
                      LoginCenter().signOut();
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => LoginBuilder().scene,
                              fullscreenDialog: true))
                          .then((value) {});
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
          localizedReason: "biometrics please".tr(),
          options: const AuthenticationOptions(
              biometricOnly: true, useErrorDialogs: true, stickyAuth: true));
    } on PlatformException catch (e) {
      debugPrint("authenticate: $e");
      return false;
    }
  }
}

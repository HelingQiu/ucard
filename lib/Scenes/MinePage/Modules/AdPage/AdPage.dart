import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Data/UserInfo.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';
import '../Biometrics/BiometricsSettingPage.dart';
import '../Biometrics/BiometricsUnlockPage.dart';

class AdPage extends StatefulWidget {
  @override
  AdPageState createState() => AdPageState();
}

class AdPageState extends State<AdPage> {
  Timer? _timer;
  int times = 1;

  /// 本地认证框架
  final LocalAuthentication auth = LocalAuthentication();

  /// 是否有可用的生物识别技术
  bool _canCheckBiometrics = false;

  ///是否已经打开开关
  bool _switchFlag = false;

  ///是否不再提示
  bool _firstFinger = false;

  @override
  void initState() {
    super.initState();
    beginCountDown();
    _checkBiometrics();
    getSwitchFlag();
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
        backgroundColor: theme == AppTheme.light
            ? AppStatus.shared.bgWhiteColor
            : AppStatus.shared.bgBlackColor,
        body: Container(
          child: Stack(
            children: [
              // Image.network(AppStatus.shared.launchAdImageUrl, fit: BoxFit.fill,),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Image.asset(
                    A.assets_logo_logo_new,
                    width: 80,
                    height: 80,
                  ),
                ),
                // child: CachedNetworkImage(
                //   imageUrl: AppStatus.shared.launchAdImageUrl,
                //   fit: BoxFit.fill,
                //   imageBuilder: (context, imageProvider) => Container(
                //     child: Image(
                //       image: imageProvider,
                //       fit: BoxFit.fill,
                //     ),
                //   ),
                //   color: Colors.green,
                // ),
              ),
              Positioned(
                  top: 70,
                  right: 16,
                  height: 25,
                  width: 60,
                  child: SkipButtonView(context))
            ],
          ),
        ),
      );
    });
  }

  Widget SkipButtonView(BuildContext context) {
    bool showCountDown = false;
    if (times > 0) {
      showCountDown = true;
    }
    return ElevatedButton(
      child: Center(
          child: FittedBox(
        child: Text(
          showCountDown ? "${times}s" : "Close".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : Colors.transparent,
              fontSize: 15),
        ),
        fit: BoxFit.scaleDown,
      )),
      style: ElevatedButton.styleFrom(
          elevation: 0, backgroundColor: Colors.transparent),
      onPressed: () {
        closeButtonPressed();
      },
    );
  }

  beginCountDown() {
    const period = const Duration(seconds: 1);
    times = 1;
    _timer = Timer.periodic(period, (timer) {
      setState(() {
        times--;
      });
      if (times == 0) {
        close();
      }
    });
  }

  cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  close() {
    cancelTimer();
    if (AppStatus.shared.canPopAd) {
      Navigator.pop(context);
      showBiometicsView();
    }
  }

  closeButtonPressed() {
    cancelTimer();
    Navigator.pop(context);
    showBiometicsView();
  }

  void showBiometicsView() {
    if (UserInfo.shared.isLoggedin && _canCheckBiometrics) {
      if (!_switchFlag) {
        if (!_firstFinger) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BiometricsSettingPage(),
              fullscreenDialog: true));
        }
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BiometricsUnlockPage(),
            fullscreenDialog: true));
      }
    }
  }

  ///检查是否有可用的生物识别技术
  Future<Null> _checkBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  //获取本地开关数据
  void getSwitchFlag() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    bool flag = perf.getBool("BiometricsFlag") ?? false;
    bool firstFinger = perf.getBool("first finger") ?? false;
    setState(() {
      _switchFlag = flag;
      _firstFinger = firstFinger;
    });
  }
}

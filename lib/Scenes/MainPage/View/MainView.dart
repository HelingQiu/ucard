import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';
import 'package:ucardtemp/Scenes/MinePage/Builder/MineBuilder.dart';
import 'package:ucardtemp/Scenes/WalletPage/Builder/WalletBuilder.dart';

import '../../../Common/Notification.dart';
import '../../../Common/ShowMessage.dart';
import '../../../Common/StreamCenter.dart';
import '../../../Common/TopAlert.dart';
import '../../../Data/AppStatus.dart';
import '../../../Data/UserInfo.dart';
import '../../../gen_a/A.dart';
import '../../../main.dart';
import '../../HomePage/Builder/HomeBuilder.dart';
import '../../MinePage/Modules/Biometrics/BiometricsSettingPage.dart';
import '../../MinePage/Modules/Biometrics/BiometricsUnlockPage.dart';
import '../../RewardPage/Builder/RewardBuilder.dart';
import '../Presenter/MainPresenter.dart';
import '../Router/MainRouter.dart';

class MainView extends StatefulWidget {
  final MainPresenter presenter;
  late MainViewState state;

  MainView(this.presenter);

  @override
  State<StatefulWidget> createState() {
    AppStatus.shared;
    UserInfo.shared;
    state = MainViewState();
    return state;
  }
}

class MainViewState extends State<MainView> with WidgetsBindingObserver {
  int _tabIndex = 0;
  var _bodys;

  /// 本地认证框架
  final LocalAuthentication auth = LocalAuthentication();

  /// 是否有可用的生物识别技术
  bool _canCheckBiometrics = false;

  ///是否已经打开开关
  bool _switchFlag = false;

  ///是否不再提示
  bool _firstFinger = false;

  MainViewState() {
    Future.delayed(Duration.zero, () {
      if (Platform.isAndroid) {
        checkLaunchAd();
      } else {
        showBiometicsView();
      }
      AppResumed();
    });
    fireBaseMessagingInit();
    //初始化
    _bodys = [
      HomeBuilder().scene,
      WalletBuilder().scene,
      RewardBuilder().scene,
      MineBuilder().scene,
    ];
  }

  @override
  initState() {
    WidgetsBinding.instance.addObserver(this);
  }

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body:
              // Stack(
              //   children: [
              NotificationListener<LoginPageNotification>(
            child: StreamBuilder<Map>(
                stream: StreamCenter.shared.refreshAllStreamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  debugPrint("listen stream refresh all  ${snapshot.data}");
                  if (snapshot.hasData) {
                    var dic = snapshot.data;
                    var type = dic["type"];
                    var content = dic["content"];
                    if (type == "index") {
                      var index = int.parse(content);
                      if (_tabIndex != index) {
                        if (index >= 0 && index <= 3) {
                          changeTabIndex(index);
                        }
                      }
                    } else if (type == "event") {
                      // Future.delayed(const Duration(milliseconds: 100), () {
                      //   // widget.presenter.showEvent(context, content);
                      //   // showDialog(context: context, builder: (_) {
                      //   //   return ShowMessage(1, dic["state"], dismissSeconds: 1,);
                      //   // });
                      // });
                      var messageId = dic["id"];
                      debugPrint("message id is $messageId");
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (messageId != null) {
                          //消息详情
                          widget.presenter
                              .showMessageDetail(context, int.parse(messageId));
                        } else {
                          //消息中心
                          widget.presenter.showNotificationCenter(context);
                        }
                      });
                    } else if (type == "withdraw") {
                      // Future.delayed(const Duration(milliseconds: 100), () {
                      //   if (UserInfo.shared.isLoggedin == true) {
                      //     // widget.presenter.showWithdraw(context);
                      //   }
                      // });
                      var messageId = dic["id"];
                      debugPrint("message id is $messageId");
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (messageId != null) {
                          //消息详情
                          widget.presenter
                              .showMessageDetail(context, int.parse(messageId));
                        } else {
                          //消息中心
                          widget.presenter.showNotificationCenter(context);
                        }
                      });
                    } else if (type == "deposit") {
                      // Future.delayed(const Duration(milliseconds: 100), () {
                      //   if (UserInfo.shared.isLoggedin == true) {
                      //     // widget.presenter.showDeposit(context);
                      //   }
                      // });
                      var messageId = dic["id"];
                      debugPrint("message id is $messageId");
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (messageId != null) {
                          //消息详情
                          widget.presenter
                              .showMessageDetail(context, int.parse(messageId));
                        } else {
                          //消息中心
                          widget.presenter.showNotificationCenter(context);
                        }
                      });
                    } else if (type == "newusertask") {
                      // Future.delayed(const Duration(milliseconds: 100), () {
                      //   // widget.presenter.showNewUserTask(context);
                      // });
                      var messageId = dic["id"];
                      debugPrint("message id is $messageId");
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (messageId != null) {
                          //消息详情
                          widget.presenter
                              .showMessageDetail(context, int.parse(messageId));
                        } else {
                          //消息中心
                          widget.presenter.showNotificationCenter(context);
                        }
                      });
                    } else if (type == "invites") {
                      // Future.delayed(const Duration(milliseconds: 100), () {
                      //   // widget.presenter.showInvites(context);
                      // });
                      var messageId = dic["id"];
                      debugPrint("message id is $messageId");
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (messageId != null) {
                          //消息详情
                          widget.presenter
                              .showMessageDetail(context, int.parse(messageId));
                        } else {
                          //消息中心
                          widget.presenter.showNotificationCenter(context);
                        }
                      });
                    } else if (type == "kyc") {
                      // Future.delayed(const Duration(milliseconds: 100), () {
                      //   // widget.presenter.showKyc(context);
                      // });
                      var messageId = dic["id"];
                      debugPrint("message id is $messageId");
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (messageId != null) {
                          //消息详情
                          widget.presenter
                              .showMessageDetail(context, int.parse(messageId));
                        } else {
                          //消息中心
                          widget.presenter.showNotificationCenter(context);
                        }
                      });
                    } else if (type == "notification") {
                      var messageId = dic["id"];
                      debugPrint("message id is $messageId");
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (messageId != null) {
                          //消息详情
                          widget.presenter
                              .showMessageDetail(context, int.parse(messageId));
                        } else {
                          //消息中心
                          widget.presenter.showNotificationCenter(context);
                        }
                      });
                    } else if (type == 'deleteDialog') {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        // widget.presenter.showDeleteView(context);
                      });
                    } else if (type == "inAppUrl") {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        // widget.presenter.showUrlPage(context, content);
                      });
                    } else if (type == "outAppUrl") {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        // widget.presenter.openOutAppUrl(context, content);
                      });
                    } else if (type == "store") {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        // widget.presenter.jumpToStore();
                      });
                    }
                  }
                  if (_tabIndex == 0) {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      StreamCenter.shared.homeStreamController.add(1);
                    });
                  } else if (_tabIndex == 1) {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      StreamCenter.shared.withdrawStreamController.add(1);
                    });
                  } else if (_tabIndex == 2) {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      StreamCenter.shared.rewardStreamController.add(1);
                    });
                  } else if (_tabIndex == 3) {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      StreamCenter.shared.profileStreamController.add(1);
                    });
                  }
                  return _bodys[_tabIndex];
                }),
            onNotification: (LoginPageNotification note) {
              debugPrint("get notification");
              if (note is LoginPageNotification) {
                MainRouter().showLogin(context);
              }
              return true;
            },
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: theme == AppTheme.light
                  ? AppStatus.shared.bgWhiteColor
                  : AppStatus.shared.bgBlackColor,
            ),
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Image.asset(
                      theme == AppTheme.light
                          ? A.assets_card_n_black
                          : A.assets_home_normal,
                      width: 32,
                      height: 32,
                    ),
                    activeIcon: Image.asset(
                      A.assets_home_selected,
                      width: 32,
                      height: 32,
                    ),
                    label: "Ucard".tr()),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      theme == AppTheme.light
                          ? A.assets_wallet_n_black
                          : A.assets_wallet_normal,
                      width: 32,
                      height: 32,
                    ),
                    activeIcon: Image.asset(
                      A.assets_wallet_selected,
                      width: 32,
                      height: 32,
                    ),
                    label: "Wallet".tr()),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      theme == AppTheme.light
                          ? A.assets_reward_n_black
                          : A.assets_reward_normal,
                      width: 32,
                      height: 32,
                    ),
                    activeIcon: Image.asset(
                      A.assets_reward_selected,
                      width: 32,
                      height: 32,
                    ),
                    label: "Reward".tr()),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      theme == AppTheme.light
                          ? A.assets_my_n_black
                          : A.assets_mine_normal,
                      width: 32,
                      height: 32,
                    ),
                    activeIcon: Image.asset(
                      A.assets_mine_selected,
                      width: 32,
                      height: 32,
                    ),
                    label: "My".tr())
              ],
              unselectedItemColor: AppStatus.shared.textGreyColor,
              selectedLabelStyle: TextStyle(fontSize: 10),
              unselectedLabelStyle: TextStyle(fontSize: 10),
              // fixedColor: Colors.fromRGBO(35, 105, 255, 1),
              type: BottomNavigationBarType.fixed,
              currentIndex: _tabIndex,
              onTap: (index) {
                if (!UserInfo.shared.isLoggedin && (index == 1 || index == 2)) {
                  debugPrint("111111111111111");
                  MainRouter().showLogin(context);
                } else {
                  StreamCenter.shared.refreshAllStreamController
                      .add({"type": "index", "content": "$index"});
                  setState(() {
                    _tabIndex = index;
                  });
                  AppStatus.shared.checkConnectStatus(context, needCheck: true);
                }
              },
            ),
          ),
        ),
      );
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'.tr()),
        content: Text('Do you want to exit an App'.tr()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'.tr()),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        AppResumed();
        break;
      case AppLifecycleState.paused:
        AppGotoBackground();
        break;
      case AppLifecycleState.detached:
      // TODO: Handle this case.
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  checkLaunchAd() async {
    print('hello finger0');
    AppStatus.shared.launchAdImageUrl =
        'https://img0.baidu.com/it/u=925843206,3288141497&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=769';
    if (AppStatus.shared.launchAdImageUrl != "") {
      print('hello finger1');
      MainRouter().showLaunchAd(context);
    }
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

  fireBaseMessagingInit() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
            sound: true,
            badge: true,
            alert: true,
            provisional: false,
            carPlay: false,
            criticalAlert: false);
    print('用户授予权限结果: ${settings.authorizationStatus}');
    final fcmToken = await FirebaseMessaging.instance.getToken();

    debugPrint("fcmToken = $fcmToken");
    if (fcmToken != null && fcmToken != "") {
      UserInfo.shared.fcmToken = fcmToken;
      debugPrint("UserInfo.shared.isLoggedin = ${UserInfo.shared.isLoggedin}");
      if (UserInfo.shared.isLoggedin) {
        LoginCenter().updateFCMToken(UserInfo.shared.fcmToken);
      }
    }

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        badge: true,
        alert: true,
        sound:
            true); //presentation options for Apple notifications when received in the foreground.

    FirebaseMessaging.onMessage.listen((message) async {
      //打开app的情况下收到
      debugPrint('Got a message whilst in the FOREGROUND!');
      return;
    }).onData((data) {
      debugPrint('Got a DATA message whilst in the FOREGROUND!');
      debugPrint('data from stream: ${data.data}');
      if (Platform.isAndroid) {
        if (data.data != null && data.data.isNotEmpty) {
          String title = data.data["pushTitle"] ?? "";
          String content = data.data["pushContent"] ?? "";
          TopAlert().showTopAlert(context, title, content, () {
            pushNotificationParse(data.data);
          });
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      //后台收到，点击进入收到
      debugPrint('NOTIFICATION MESSAGE TAPPED');
      return;
    }).onData((data) {
      debugPrint('NOTIFICATION MESSAGE TAPPED');
      debugPrint('data from stream2: ${data.data}');

      if (data.data != null && data.data.isNotEmpty) {
        pushNotificationParse(data.data);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        if (message.data != null && message.data.isNotEmpty) {
          pushNotificationParse(message.data);
        }
      }
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (Firebase.apps.isEmpty) await Firebase.initializeApp();
    debugPrint(
        "Handling a background message: ${message.messageId}   ${message.data}");
  }

  AppResumed() async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      FlutterAppBadger.updateBadgeCount(0);
      FlutterAppBadger.removeBadge();
    }
  }

  AppGotoBackground() {}

  changeTabIndex(int index) async {
    // debugPrint("change index $index");
    Future.delayed(const Duration(milliseconds: 100), () {
      _tabIndex = index;
      setState(() {});
    });
  }

  pushNotificationParse(Map<String, dynamic> dic) {
    var type = dic["type"];
    var content = dic["content"];
    if (type != null && type != "") {
      if (type == "notification") {
        var messageId = dic["id"];
        // if (messageId != null && messageId is int) {
        //   StreamCenter.shared.refreshAllStreamController.add(
        //       {"type": "notification", "content": content, "id": messageId});
        // } else {
        if (content != null && content != "") {
          StreamCenter.shared.refreshAllStreamController.add(
              {"type": "notification", "content": content, "id": messageId});
        } else {
          StreamCenter.shared.refreshAllStreamController
              .add({"type": "notification", "id": messageId});
        }
        // }
      } else if (type == "event") {
        if (content != null && content != "") {
          StreamCenter.shared.refreshAllStreamController
              .add({"type": "event", "content": content});
        }
      } else if (type == "inAppUrl" || type == "outAppUrl") {
        if (content != null && content != "") {
          StreamCenter.shared.refreshAllStreamController
              .add({"type": type, "content": content});
        }
      } else if (type == "store") {
        if (content != null && content != "") {
          StreamCenter.shared.refreshAllStreamController.add({"type": "store"});
        }
      }
    }
  }

  showAppVersionRemindView(int update, String content, String secondeContent) {
    int styleType = 2;
    if (update == 2) {
      styleType = 3;
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return ShowMessage(
            1,
            "New Version Is Available".tr(),
            dismissSeconds: 0,
            styleType: styleType,
            content: content,
            secondContent: secondeContent,
            button1Callback: () {
              //if want to close ad
            },
          );
        });
  }
}

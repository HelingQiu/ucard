import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Data/UserInfo.dart';

// import 'package:ucard/Model/AreaCodeModel.dart';
// import 'package:ucard/Model/EarnModel.dart';
import 'package:ucardtemp/Network/Api.dart';

// import 'package:uollar/Model/CoinInfoModel.dart';
// import 'package:uollar/Model/CoinMarketInfoModel.dart';
// import 'package:uollar/Scenes/Common/CoinMarketCapApi.dart';
// import 'package:uollar/Scenes/Common/CoingeckoApi.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:ucardtemp/Common/ShowMessage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:device_info_plus/device_info_plus.dart';
import "dart:io" show Platform;

import '../Common/ColorUtil.dart';
import '../Model/AreaCodeModel.dart';
import '../Scenes/HomePage/Modules/Apply/Entity/AmericanStateModel.dart';

class AppStatus {
  static AppStatus shared = new AppStatus._internal();

  //固定账号
  String specialAccount = "zhao0309@163.com";

  bool simpleMode = true;
  List<AreaCodeModel> areaCodes = [];

  // List<CoinInfoModel> coins = [];
  String registerAgreementUrl = "";
  List<String> marketSymbols =
      []; //market symbols from /api/index,  then get price,history form cmc, display in homepage
  List<String> selectedSymbols =
      []; // marketSymbols + self-selected,  display in market page
  // List<EarnModel> earns = []; //home earns from /api/index
  // List<CoinMarketInfoModel> marketCoins = []; //market 1-100 coins
  String historyPeriod = "1 Day";
  List<String> historyDisplayPeriods = ["1 Day", "1 Week", "1 Month", "1 Year"];
  Map<String, int> historyPeriodMap = {
    "1 Day": 600,
    "1 Week": 3600,
    "1 Month": 86400,
    "1 Year": 2592000
  };
  double unitWidth = 20; //kline view
  bool colorGreenUp = true;
  List<String> languages = ["en-US", "zh-HK", "zh-CN"];
  List<String> displayLanguages = ["English", "繁體中文", "简体中文"];
  String lang = "EN"; //EN, zh-cn, zh-TW
  String kycAccountId = "175v9s1ajjs0bs0826u8ve7iig";
  String kycSecret = "1f0342vrkthqj01iocg2lbkb8c56qjkhfu2r4badfmh9bfcmendv";
  String launchAdImageUrl = "";
  String versionNumber = "1.2.7";
  int minPrecisionNum = 2;
  bool purchaseWithoutKyc = false;
  bool withdrawWithoutKyc = false;
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Map currencyNames = {};
  String identifier = "";
  String remindedVersion = "";
  String appstoreVersion = "";
  String newVersionShowContent = "";
  bool canPopAd = true; // if need update, open ad can't pop

  //洲
  AmericanStateModel stateModel = AmericanStateModel("", "");

  //国家
  CountryModel countryModel = CountryModel("", "", "");

  factory AppStatus() {
    return shared;
  }

  AppStatus._internal() {
    start();
  }

  start() async {
    await getSavedData();
    await getSystem();
    connectStatus();
    // fetchOtherDetail();
    fetchCurrencyNames();
  }

  Future getSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    selectedSymbols = await prefs.getStringList("selectedSymbols") ?? [];
    colorGreenUp = await prefs.getBool("colorGreenUp") ?? true;
    launchAdImageUrl = await prefs.getString("LaunchAd") ?? "";
    remindedVersion = await prefs.getString("RemindedVersion") ?? "";
  }

  void saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedSymbols', selectedSymbols);
    await prefs.setBool("colorGreenUp", colorGreenUp);
  }

  void saveReminded() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("RemindedVersion", remindedVersion);
  }

  void connectStatus() async {
    connectivityResult =
        (await (Connectivity().checkConnectivity())) as ConnectivityResult;
    debugPrint("connectivityResult = $connectivityResult");
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          debugPrint("connectivityResult = $result");
          connectivityResult = result;
        } as void Function(List<ConnectivityResult> event)?);
  }

  checkConnectStatus(BuildContext context, {bool needCheck = false}) async {
    if (needCheck) {
      connectivityResult =
          (await (Connectivity().checkConnectivity())) as ConnectivityResult;
    }
    if (connectivityResult == ConnectivityResult.none) {
      if (!needCheck) {
        connectivityResult =
            (await (Connectivity().checkConnectivity())) as ConnectivityResult;
      }
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(2, "No network".tr(), styleType: 1, width: 257);
          });
    }
  }

  Future<List<AreaCodeModel>> fetchAreaCodes() async {
    if (areaCodes.length > 0) {
      return areaCodes;
    }
    var result = await Api().post("/api/getCountrys", {}, false);
    debugPrint("getcountrys = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          List data = dic["data"];
          if (data != null && data.isNotEmpty) {
            data.forEach((element) {
              var c = AreaCodeModel.parse(element as Map<String, dynamic>);
              areaCodes.add(c);
            });
          }
        } else {
          String message = dic["message"];
          if (message != null) {
            debugPrint("message = $message");
          }
        }
      }
    }
    return areaCodes;
  }

  fetchCurrencyNames() async {
    var result = await Api().post("/api/currency", {}, false);
    debugPrint("currencynames = $result");
    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code != null) {
        if (code == 200) {
          Map data = dic["data"];
          if (data != null && data.isNotEmpty) {
            currencyNames = data;
          }
        }
      }
    }
  }

  fetchOtherDetail() async {
    var str = await Api().get("/api/otherDetail", "id=100", false);
    debugPrint("fetchOtherDetail result = $str");
  }

  fetchLaunchAd() async {
    var result = await Api().post("/api/ad/list", {"lang": lang}, false);
    debugPrint("fetchLaunchAd = $result");

    var dic = json.decode(result);
    if (dic != null) {
      var code = dic["status_code"];
      if (code == 200) {
        var data = dic["data"];
        if (data != null && data is Map) {
          var ads = data["ads"];
          if (ads != null && ads is List && ads.length > 0) {
            var ad = ads[0];
            if (ad != null && ad is Map) {
              var imageUrl = ad["image"];
              if (imageUrl != null) {
                if (imageUrl != launchAdImageUrl) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString("LaunchAd", imageUrl);
                }
              }
            }
          }
        }
      }
    }
  }

  int findHistoryPeriod(String displayPeriod) {
    return historyPeriodMap[displayPeriod]!;
  }

  List<String> addMarketSymbol(String symbol) {
    if (marketSymbols.contains(symbol)) {
      return marketSymbols;
    }
    marketSymbols.add(symbol);
    saveMarketSymbols();
    return marketSymbols;
  }

  List<String> addMarketSymbols(List<String> symbols, bool isTopCoins) {
    var coins = selectedSymbols;
    if (isTopCoins) {
      coins = symbols + selectedSymbols;
    } else {
      coins = selectedSymbols + symbols;
    }
    selectedSymbols = coins.toSet().toList();
    saveMarketSymbols();
    return selectedSymbols;
  }

  saveMarketSymbols() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedSymbols', selectedSymbols);
  }

  Locale getLocale(String language) {
    List lang = language.split('-');
    var la = Locale(lang[0], lang[1]);
    debugPrint("language = ${language},   getLocale  ${la}");
    return la;
  }

  setLang(Locale locale) {
    lang = "EN";

    String localeStr = "$locale";
    debugPrint("localeStr = $localeStr");
    if (localeStr == "zh-CN" || localeStr == "zh_cn" || localeStr == "zh_CN") {
      lang = "zh-CN";
    } else if (localeStr == "zh-HK" ||
        localeStr == "zh-TW" ||
        localeStr == "zh_HK" ||
        localeStr == "zh_TW") {
      lang = "zh-TW";
    } else {
      lang = "EN";
    }
  }

  String getCurrencyName(String currency, String lang) {
    //EN , zh-CN, zh-TW
    var names = currencyNames[currency];
    if (names != null) {
      if (lang.toLowerCase() == "zh-cn" || lang.toLowerCase() == "zh-tw") {
        return names[lang] ?? "";
      }
      return names["EN"] ?? "";
    }

    return "";
  }

  String getCoinLogo(String coinSymbol) {
    return "assets/coin_${coinSymbol.toLowerCase()}2.png";
  }

  String getCoinLogo2(String coinSymbol) {
    return "assets/coin_${coinSymbol.toLowerCase()}.png";
  }

  String getCoinLogo3(String coinSymbol) {
    return "assets/coin_${coinSymbol.toLowerCase()}3.png";
  }

  // int priceSize(String currency) {
  //   if (currency == "USD") {
  //     return 2;
  //   }
  //   for (var coin in coins) {
  //     if (coin.currency == currency) {
  //       return coin.priceIncrement;
  //     }
  //   }
  //   return 8;
  // }

  // int precisionNum(String currency) {
  //   if (currency == "USD") {
  //     return 2;
  //   }
  //   for (var coin in coins) {
  //     if (coin.currency == currency) {
  //       return coin.precisionNum;
  //     }
  //   }
  //   return 8;
  // }
  //
  // int quantitySize(String currency) {
  //   for (var coin in coins) {
  //     if (coin.currency == currency) {
  //       return coin.quantityIncrement;
  //     }
  //   }
  //   return 4;
  // }

  getSystem() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        var info = await deviceInfoPlugin.androidInfo;
        identifier = info.id ?? "";
        print("identifier = ${identifier}");
      } else if (Platform.isIOS) {
        var info = await deviceInfoPlugin.iosInfo;
        identifier = info.identifierForVendor ?? "";
      }
    } catch (error) {
      debugPrint("getSystem err ${error}");
    }
  }

  Color bgBlackColor = ColorsUtil.hexColor(0x121212); //#141722
  Color bgDarkGreyColor = ColorsUtil.hexColor(0xffffff, alpha: 0.12); //#1A202E
  Color bgGreyColor = ColorsUtil.hexColor(0x232323,
      alpha: 1); // Color bgGreyColor = Color.fromRGBO(25, 25, 25, 1);
  Color bgBlueColor = ColorsUtil.hexColor(0x2369FF, alpha: 1); //#

  Color bgBlueGreyColor = Color.fromRGBO(31, 45, 78, 1);

  Color textGreyColor = Color.fromRGBO(137, 137, 137, 1); //#9DA3B1
  Color bgYellowColor = Color.fromRGBO(255, 205, 0, 1); //  #FFCD00
  Color filterColor = Color.fromRGBO(56, 73, 112, 1);
  Color bgWhiteColor = Colors.white;
  Color bgWhiteColorAlpha7 = ColorsUtil.hexColor(0xFFFFFF, alpha: 0.7);

  Color bgGreyLightColor = ColorsUtil.hexColor(0x000000, alpha: 0.12);

  List<Color> bgGradientColors = [
    Color.fromRGBO(28, 96, 241, 1),
    Color.fromRGBO(8, 66, 196, 1)
  ];

  String meet4AddBlank(String val) {
    String newStr = '';
    while (val.isNotEmpty) {
      String subStr = val.substring(0, min(val.length, 4));
      newStr += subStr;
      if (subStr.length == 4 && newStr.length < 15) {
        newStr += ' ';
      }
      val = val.substring(min(val.length, 4));
    }
    return newStr;
  }

  String meet4AddBlankAndHide(String val) {
    val = val.substring(0, 4) + '*' * 8 + val.substring(12);
    String newStr = "";
    while (val.isNotEmpty) {
      String subStr = val.substring(0, min(val.length, 4));
      newStr += subStr;
      if (subStr.length == 4 && newStr.length < 15) {
        newStr += ' ';
      }
      val = val.substring(min(val.length, 4));
    }
    return newStr;
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucardtemp/Data/AppStatus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ucardtemp/Data/UserInfo.dart';
import 'Common/Firebase_options.dart';
import 'Scenes/MainPage/Builder/MainBuilder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

int lightMode = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  UserInfo.shared.getSavedData();
  print("dddddddd");
  print(UserInfo.shared.lightMode);

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {
      // empty debugPrint implementation in the release mode
    };
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(EasyLocalization(
        child: BlocProvider(create: (context) => ThemeCubit(), child: MyApp()),
        supportedLocales: [
          Locale('zh', 'HK'),
          Locale('zh', 'CN'),
          Locale('en', 'US')
        ],
        path: 'local',
        fallbackLocale: Locale('en', 'US'),
        // Locale('en', 'US'),    //Locale('zh', 'CN'),
        assetLoader: JsonAssetLoader()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (context, state) {
          // emit(AppTheme.dark);
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
            },
            child: MaterialApp(
              routes: <String, WidgetBuilder>{
                // "/FiatList": (BuildContext context) =>
                // new TransferListBuilder(0).scene,
                // "/Withdraw": (BuildContext context) => WithdrawBuilder().scene
              },
              title: 'Ucard',
              debugShowCheckedModeBanner: false,
              theme: UserInfo.shared.lightMode == 0
                  ? ThemeData.dark()
                  : ThemeData.light(),
              // darkTheme: UserInfo.shared.lightMode == 0
              //     ? ThemeData.dark()
              //     : ThemeData.light(),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              navigatorObservers: [],
              //路由监听
              locale: context.locale,
              home: MainBuilder().scene,
              builder: (context, widget) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget!,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class JsonAssetLoader extends AssetLoader {
  String getLocalePath(String basePath, Locale locale) {
    debugPrint("getLocalePath  basePath = $basePath,  locale = $locale");
    AppStatus.shared.setLang(locale);
    return '$basePath/${localeToString(locale, separator: "-")}.json';
  }

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    var localePath = getLocalePath(path, locale);
    debugPrint('----  locale = $locale,   localePath = $localePath');
    var dic = json.decode(await rootBundle.loadString(localePath));
    return json.decode(await rootBundle.loadString(localePath));
  }
}

enum AppTheme {
  light,
  dark,
}

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit()
      : super(UserInfo.shared.lightMode == 0 ? AppTheme.dark : AppTheme.light);

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == AppTheme.light) {
      emit(AppTheme.dark);
      prefs.setInt("lightMode", 0);
      UserInfo.shared.lightMode = 0;
    } else {
      emit(AppTheme.light);
      prefs.setInt("lightMode", 1);
      UserInfo.shared.lightMode = 1;
    }
    print(UserInfo.shared.lightMode);
  }
}

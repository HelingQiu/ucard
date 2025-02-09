import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../gen_a/A.dart';

//Locale('zh', 'HK'), Locale('zh', 'CN'), Locale('en', 'US'

class LanguagePage extends StatefulWidget {
  @override
  LanguagePageState createState() => LanguagePageState();
}

class LanguagePageState extends State<LanguagePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Language".tr(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppStatus.shared.bgBlackColor,
      ),
      backgroundColor: AppStatus.shared.bgBlackColor,
      body: Container(
        color: AppStatus.shared.bgBlackColor,
        child: ListView.builder(
          itemCount: AppStatus.shared.languages.length,
          itemBuilder: (context, index) {
            String lang = AppStatus.shared.languages[index];
            bool isSameLanguage =
                ("${context.locale}" == lang.replaceAll("-", "_"));
            return Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          AppStatus.shared.displayLanguages[index],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                        IconButton(
                            onPressed: () {
                              langPressed(context, lang);
                            },
                            icon: Image.asset(
                              isSameLanguage
                                  ? A.assets_mine_lan_selected
                                  : A.assets_mine_lan_normal,
                              width: 20,
                              height: 20,
                              fit: BoxFit.fill,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  langPressed(BuildContext context, String language) async {
    //  debugPrint("set language = $language");
    List lang = language.split('-');
    var la = Locale(lang[0], lang[1]);
    await context.setLocale(la);
    AppStatus.shared.setLang(la);
    setState(() {});
  }
}

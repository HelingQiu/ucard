import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Data/UserInfo.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';

//Locale('zh', 'HK'), Locale('zh', 'CN'), Locale('en', 'US'

class LightModePage extends StatefulWidget {
  @override
  LightModePageState createState() => LightModePageState();
}

class LightModePageState extends State<LightModePage> {
  int selectIndex = UserInfo.shared.lightMode == 0 ? 1 : 0;
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
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, theme) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor, //修改颜色
            ),
            elevation: 0,
            title: Text(
              "Light Mode".tr(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor),
            ),
            backgroundColor: theme == AppTheme.light
                ? AppStatus.shared.bgWhiteColor
                : AppStatus.shared.bgBlackColor,
          ),
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          body: Container(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgWhiteColor
                : AppStatus.shared.bgBlackColor,
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                print(theme);
                // if (theme == AppTheme.light) {
                //   selectIndex == 0;
                // } else {
                //   selectIndex == 1;
                // }
                print("sssss${selectIndex}");
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
                              index == 0 ? "Light".tr() : "Dark".tr(),
                              style: TextStyle(
                                  color: theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor,
                                  fontSize: 16),
                            )),
                            IconButton(
                                onPressed: () {
                                  if (selectIndex != index) {
                                    selectIndex = index;
                                    langPressed(context, index);
                                  } else {}
                                },
                                icon: Image.asset(
                                  (selectIndex == index)
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
      },
    );
  }

  langPressed(BuildContext context, int index) async {
    //  debugPrint("set language = $language");
    context.read<ThemeCubit>().toggleTheme();
    setState(() {});
  }
}

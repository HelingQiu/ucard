import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Common/ShowMessage.dart';
import '../../../../Data/AppStatus.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';

class ContactusPage extends StatefulWidget {
  @override
  ContactusPageState createState() => ContactusPageState();
}

class ContactusPageState extends State<ContactusPage> {
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
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor, //修改颜色
          ),
          elevation: 0,
          title: Text(
            "Contact us".tr(),
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
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        //
                        Clipboard.setData(
                            const ClipboardData(text: 'service@uok.top'));
                        showDialog(
                            context: context,
                            builder: (_) {
                              return ShowMessage(2, 'Copy to Clipboard'.tr(),
                                  styleType: 1, width: 257);
                            });
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              'Email2'.tr(),
                              style: TextStyle(
                                  color: theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor,
                                  fontSize: 16),
                            )),
                            Text(
                              'service@uok.top',
                              style: TextStyle(
                                  color: AppStatus.shared.textGreyColor,
                                  fontSize: 14),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Image.asset(
                              A.assets_mine_contact_copy,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        //
                        Clipboard.setData(
                            const ClipboardData(text: '@UOK_card'));
                        showDialog(
                            context: context,
                            builder: (_) {
                              return ShowMessage(2, 'Copy to Clipboard'.tr(),
                                  styleType: 1, width: 257);
                            });
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              'Telegram'.tr(),
                              style: TextStyle(
                                  color: theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor,
                                  fontSize: 16),
                            )),
                            Text(
                              '@UOK_card',
                              style: TextStyle(
                                  color: AppStatus.shared.textGreyColor,
                                  fontSize: 14),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Image.asset(
                              A.assets_mine_contact_copy,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

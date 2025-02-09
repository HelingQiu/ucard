import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';

class TopupSuccessPage extends StatefulWidget {
  String receivedAmout = '';
  TopupSuccessPage(this.receivedAmout);

  @override
  TopupSuccessPageState createState() => TopupSuccessPageState();
}

class TopupSuccessPageState extends State<TopupSuccessPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 4)).then((value) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
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
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: AppStatus.shared.bgBlackColor,
        // ),
        backgroundColor: theme == AppTheme.light
            ? AppStatus.shared.bgWhiteColor
            : AppStatus.shared.bgBlackColor,
        body: Container(
          color: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(A.assets_topup_success),
                  Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Text(
                      'Topup Success'.tr(),
                      style: TextStyle(
                          color: theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      widget.receivedAmout,
                      style: TextStyle(
                          color: theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, left: 43, right: 43),
                    child: Text(
                      'Topup success note'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppStatus.shared.textGreyColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: InkWell(
        onTap: () {
          //
        },
        child: Container(
          height: 44,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppStatus.shared.bgBlueColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              "Top up".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';
import '../../Entity/MycardsModel.dart';
import '../Topup/Builder/TopupBuilder.dart';

class ApplyEndPage extends StatefulWidget {
  String cardType = '';
  int cardLevel = 1;
  String cardName = '';
  String level_name = '';
  String card_order = '';
  ApplyEndPage(this.cardType, this.cardLevel, this.cardName, this.level_name,
      this.card_order);

  @override
  ApplyEndPageState createState() => ApplyEndPageState();
}

class ApplyEndPageState extends State<ApplyEndPage> {
  @override
  void initState() {
    super.initState();
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
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor, //修改颜色
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Apply".tr(),
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
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: Text(
                    'My cards'.tr() + '(${widget.level_name})',
                    style: TextStyle(
                        color: theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                _buildUcardInfoView(context),
                Expanded(child: Container()),
                _buildSubmitButton(context),
                _buildLaterButton(context),
                Container(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildUcardInfoView(BuildContext context) {
    String cardBg = '';
    if (widget.cardLevel == 1) {
      cardBg = A.assets_home_first_card_bg;
    } else if (widget.cardLevel == 2) {
      cardBg = A.assets_home_second_card_bg;
    } else if (widget.cardLevel == 3) {
      cardBg = A.assets_home_third_card_bg;
    } else {
      cardBg = A.assets_home_forth_card_bg;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 22, top: 25),
      child: Container(
        child: Stack(
          children: [
            ClipRRect(
              child: Image.asset(
                cardBg,
                fit: BoxFit.fill,
                height: 190,
                width: MediaQuery.of(context).size.width - 44,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            Positioned(
              left: 20,
              top: 190 / 2 - 10,
              child: Text(
                '\$ 0.00',
                style: TextStyle(
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgBlackColor
                        : AppStatus.shared.bgWhiteColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
            ),
            Positioned(
              child: Text(
                widget.cardName,
                style: TextStyle(
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgBlackColor
                        : AppStatus.shared.bgWhiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              ),
              left: 20,
              bottom: 22,
            ),
            Positioned(
              child: Image.asset(A.assets_home_ucard_logo),
              left: 20,
              top: 18,
            ),
            Positioned(
              child: Image.asset(widget.cardType == 'master'
                  ? A.assets_apply_master_card
                  : A.assets_apply_visa_card),
              right: 20,
              bottom: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: InkWell(
        onTap: () {
          //
          MycardsModel model = MycardsModel(
            widget.card_order,
            widget.cardType,
            widget.cardLevel,
            widget.level_name,
            widget.cardName,
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            0,
            0,
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
          );
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TopupBuilder(model).scene));
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

  //Later
  Widget _buildLaterButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: InkWell(
        onTap: () {
          //
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Container(
          height: 44,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppStatus.shared.bgBlackColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              "Later".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppStatus.shared.textGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

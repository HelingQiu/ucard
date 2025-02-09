import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
import '../Presenter/DetailPresenter.dart';

class DetailView extends StatelessWidget {
  final DetailPresenter presenter;

  StreamController<int> streamController = StreamController.broadcast();

  DetailView(this.presenter);

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor, //修改颜色
          ),
          elevation: 0,
          title: Text(
            "Detail1".tr(),
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
        body: StreamBuilder<int>(
          stream: streamController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var billAmt = "";
            var transAmt = "";
            var rightContent = "";
            if (presenter.model.isCredit == "1") {
              billAmt =
                  "+${presenter.model.billCurrencyAmt} ${presenter.model.billCurrency}";
              transAmt =
                  "+${presenter.model.transCurrencyAmt} ${presenter.model.transCurrency}";
              rightContent = "Permission".tr();
            } else {
              billAmt =
                  "-${presenter.model.billCurrencyAmt} ${presenter.model.billCurrency}";
              transAmt =
                  "-${presenter.model.transCurrencyAmt} ${presenter.model.transCurrency}";
              rightContent = "Consumption".tr();
            }
            return Container(
              color: theme == AppTheme.light
                  ? AppStatus.shared.bgWhiteColor
                  : AppStatus.shared.bgBlackColor,
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 56,
                    ),
                    Text(
                      billAmt,
                      style: TextStyle(
                          color: theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      rightContent,
                      style: TextStyle(
                          color: theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 56,
                    ),
                    _buildCell(
                        context, 'To', presenter.model.merchantName, true),
                    SizedBox(
                      height: 20,
                    ),
                    _buildCell(context, 'Transaction ID',
                        presenter.model.cardId, true),
                    SizedBox(
                      height: 20,
                    ),
                    _buildCell(context, 'Actual amount', transAmt, false),
                    SizedBox(
                      height: 20,
                    ),
                    _buildCell(
                        context, 'Date', presenter.model.settleDate, false),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildCell(
      BuildContext context, String title, String content, bool showCopy) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        child: Row(
          children: [
            Expanded(
                child: Text(
              title.tr(),
              style: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14),
            )),
            Text(
              content,
              style: TextStyle(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 5,
            ),
            Visibility(
              visible: showCopy,
              child: Image.asset(
                A.assets_mine_contact_copy,
              ),
            )
          ],
        ),
      ),
    );
  }
}

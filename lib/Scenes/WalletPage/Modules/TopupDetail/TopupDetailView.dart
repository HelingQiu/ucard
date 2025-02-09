import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucardtemp/Common/NumberPlus.dart';
import 'package:ucardtemp/Scenes/WalletPage/Entity/CardRechargeDetailModel.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Data/UserInfo.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';
import '../../Entity/TransferDetailModel.dart';
import 'TopupDetailPresenter.dart';

class TopupDetailView extends StatelessWidget {
  final TopupDetailPresenter presenter;
  CardRechargeDetailModel model = CardRechargeDetailModel(
      "", 0, "", "", "", "", "", "", "", "", "", 0, DateTime.now());

  TopupDetailView(this.presenter);

  StreamController<int> controller = StreamController.broadcast();

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor, //修改颜色
          ),
          elevation: 0,
          centerTitle: false,
          toolbarHeight: 40,
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          title: Text(
            "Top-Up Detail".tr(),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
        ),
        backgroundColor: theme == AppTheme.light
            ? AppStatus.shared.bgWhiteColor
            : AppStatus.shared.bgBlackColor,
        body: StreamBuilder<int>(
          stream: controller.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (model.card_type.isEmpty) {
              return Container();
            }
            String imageName = "";
            String statusStr = "";
            if (model.status == 0) {
              imageName = A.assets_withdraw_progress;
              statusStr = "Top-up progress".tr();
            } else if (model.status == 1) {
              imageName = A.assets_wallet_completed;
              statusStr = "Top-up completed".tr();
            } else {
              imageName = A.assets_wallet_failed;
              statusStr = "Top-up fail".tr();
            }
            double moneynum = double.parse(model.money);
            String money =
                "${NumberPlus.displayNumber(moneynum, "")} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : model.money_currency}";

            // DateTime datetime = DateTime.parse(model.created_at);
            // String time =
            //     DateFormat("yyyy-MM-dd HH:mm:ss").format(datetime.toUtc());

            String time =
                DateFormat("yyyy-MM-dd HH:mm:ss").format(model.created_at_int);

            return Container(
              color: theme == AppTheme.light
                  ? AppStatus.shared.bgWhiteColor
                  : AppStatus.shared.bgBlackColor,
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 48,
                    ),
                    Image.asset(imageName),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      statusStr,
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
                      money,
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
                    _buildCell(context, 'Received',
                        "${model.received_money} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : model.received_money_currency}"),
                    SizedBox(
                      height: 20,
                    ),
                    _buildCell(context, 'Fee',
                        '${model.fee} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : model.fee_currency}'),
                    SizedBox(
                      height: 20,
                    ),
                    _buildCell(context, "Card No.", model.card_no),
                    SizedBox(
                      height: 20,
                    ),
                    _buildCell(context, 'Time', time),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildCell(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.tr(),
              style: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                content,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgBlackColor
                        : AppStatus.shared.bgWhiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateModel(CardRechargeDetailModel m) {
    debugPrint("view updateModel ${m.money_currency} ${m.money}");
    model = m;
    controller.add(0);
  }
}

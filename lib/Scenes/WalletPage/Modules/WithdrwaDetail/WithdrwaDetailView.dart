import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucardtemp/Common/NumberPlus.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Data/UserInfo.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';
import '../../Entity/TransferDetailModel.dart';
import 'WithdrwaDetailPresenter.dart';

class WithdrwaDetailView extends StatelessWidget {
  final WithdrwaDetailPresenter presenter;
  int type;
  TransferDetailModel model =
      TransferDetailModel(0, "", "", "", "", 0, 0, "", "", 0);

  WithdrwaDetailView(this.presenter, this.type);

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
            type == 1 ? "Withdraw Detail".tr() : "Deposit Detail".tr(),
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
            if (model.currency == "") {
              return Container();
            }
            String imageName = "";
            if (model.statusType == -1) {
              imageName = A.assets_wallet_failed;
            } else if (model.statusType == 0) {
              imageName = A.assets_withdraw_progress;
            } else {
              imageName = A.assets_wallet_completed;
            }
            String money = "";
            double moneynum = double.parse(model.money);
            if (type == 1) {
              money =
                  "-${NumberPlus.displayNumber(moneynum, "")} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : model.currency}";
            } else {
              money =
                  "+${NumberPlus.displayNumber(moneynum, "")} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : model.currency}";
            }
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
                      model.status,
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
                    Visibility(
                        visible: type == 1,
                        child: _buildCell(context, 'Network fee',
                            "${model.gas} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : model.currency}")),
                    SizedBox(
                      height: 20,
                    ),
                    _buildCell(context, 'Network', '${model.blockchain}'),
                    SizedBox(
                      height: 20,
                    ),
                    _buildCell(
                        context,
                        type == 1 ? "Withdraw Address" : "Deposit Address",
                        model.address),
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                        visible: type != 1,
                        child: _buildCell(context, 'Hash', "${model.txid}")),
                    SizedBox(
                      height: 20,
                    ),
                    _buildCell(context, 'Time',
                        "${DateFormat("yyyy/MM/dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(model.time * 1000))}"),
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

  updateModel(TransferDetailModel m) {
    debugPrint("view updateModel ${m.currency} ${m.money}");
    model = m;
    controller.add(0);
  }
}

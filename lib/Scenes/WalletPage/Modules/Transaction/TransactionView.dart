import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loadmore/loadmore.dart';
import 'package:ucardtemp/Scenes/WalletPage/Entity/TransCardrechargeModel.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../Data/UserInfo.dart';
import '../../../../gen_a/A.dart';
import '../../../../main.dart';
import 'TransactionPresenter.dart';

class TransactionView extends StatelessWidget {
  final TransactionPresenter presenter;

  TransactionView(this.presenter);

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
            'Transaction details'.tr(),
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
          builder: (context, snapshot) {
            return Container(
              color: theme == AppTheme.light
                  ? AppStatus.shared.bgWhiteColor
                  : AppStatus.shared.bgBlackColor,
              child: SafeArea(
                child: Stack(
                  children: [
                    _buildNodataView(context),
                    _buildHistoryListView(context),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  //历史列表
  Widget _buildHistoryListView(BuildContext context) {
    return EasyRefresh(
      header: MaterialHeader(),
      footer: MaterialFooter(),
      onRefresh: () async {
        debugPrint("111111111111111");
        await presenter.fetchRefreshList();
      },
      onLoad: () {
        presenter.fetchMoreList();
        if (!presenter.hasMore) {
          return IndicatorResult.noMore;
        }
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: presenter.records.length,
        itemBuilder: (context, index) {
          TransCardrechargeModel model = presenter.records[index];
          // DateTime datetime = DateTime.parse(model.created_at);
          // String time =
          //     DateFormat("yyyy-MM-dd HH:mm:ss").format(datetime.toUtc());
          String time =
              DateFormat("yyyy-MM-dd HH:mm:ss").format(model.created_at_int);

          return Container(
            height: 60,
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        getHeadImage(model.trans_code),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          model.trans_code_str,
                          style: TextStyle(
                              color: _theme == AppTheme.light
                                  ? AppStatus.shared.bgBlackColor
                                  : AppStatus.shared.bgWhiteColor,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${model.flag}${model.money} ${(UserInfo.shared.email == AppStatus.shared.specialAccount) ? "USD" : model.currency}",
                      style: TextStyle(
                          color: _theme == AppTheme.light
                              ? AppStatus.shared.bgBlackColor
                              : AppStatus.shared.bgWhiteColor,
                          fontSize: 15),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      time,
                      style: TextStyle(
                          color: AppStatus.shared.textGreyColor, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getHeadImage(String trans_code) {
    if (trans_code == "T01") {
      //充值成功或者失败
      return Image.asset(
        _theme == AppTheme.light
            ? A.assets_notifi_deposit_black
            : A.assets_notification_deposit,
        fit: BoxFit.fitWidth,
      );
    } else if (trans_code == "T02") {
      //提现成功或者失败
      return Image.asset(
        _theme == AppTheme.light
            ? A.assets_notifi_withdraw_black
            : A.assets_notification_withdraw,
        fit: BoxFit.fitWidth,
      );
    } else if (trans_code == "T03") {
      //提现退款
      return Image.asset(
        _theme == AppTheme.light
            ? A.assets_notifi_withdraw_black
            : A.assets_notification_withdraw,
        fit: BoxFit.fitWidth,
      );
    } else if (trans_code == "T31") {
      //推荐奖励
      return Image.asset(
        _theme == AppTheme.light
            ? A.assets_notifi_reward_black
            : A.assets_notification_reward,
        fit: BoxFit.fitWidth,
      );
    } else if (trans_code == "T11" || trans_code == "T12") {
      //卡充值
      return Container(
        width: 36,
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(A.assets_trans_bg),
            Image.asset(A.assets_Group_39916),
          ],
        ),
      );
    } else {
      //其他的
      return Container(
        width: 36,
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(A.assets_trans_bg),
            Image.asset(A.assets_Group_39917),
          ],
        ),
      );
    }
  }

  Widget _buildNodataView(BuildContext context) {
    return Visibility(
      visible: presenter.records.isEmpty,
      child: Container(
        height: MediaQuery.of(context).size.height - 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(A.assets_ucard_nodata),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "No data  ".tr(),
                style: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

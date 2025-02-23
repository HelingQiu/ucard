import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../Common/ColorUtil.dart';
import '../../../../../Common/DatePicker/date_picker.dart';
import '../../../../../Common/DatePicker/date_picker_theme.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/UserInfo.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
import '../../../Entity/SettlementModel.dart';
import '../Presenter/BillPresenter.dart';

class BillView extends StatelessWidget {
  final BillPresenter presenter;

  StreamController<int> streamController = StreamController.broadcast();

  BillView(this.presenter);

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return StreamBuilder<int>(
          stream: streamController.stream,
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor, //修改颜色
                ),
                elevation: 0,
                title: Text(
                  "Bill".tr(),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: _theme == AppTheme.light
                          ? AppStatus.shared.bgBlackColor
                          : AppStatus.shared.bgWhiteColor),
                ),
                backgroundColor: _theme == AppTheme.light
                    ? AppStatus.shared.bgWhiteColor
                    : AppStatus.shared.bgBlackColor,
              ),
              backgroundColor: _theme == AppTheme.light
                  ? AppStatus.shared.bgWhiteColor
                  : AppStatus.shared.bgBlackColor,
              body: Column(
                children: [
                  _buildCardInfo(context),
                  Expanded(
                    child: _buildTransactionList(),
                  ),
                  _buildDownloadButton(),
                ],
              ),
            );
          });
    });
  }

  Widget _buildCardInfo(BuildContext context) {
    String cardNo = presenter.model.card_no;
    if (cardNo.isEmpty) {
      cardNo = '';
    }
    DateFormat dateFormat = DateFormat("yyyy-MM");
    String dateTime = dateFormat.format(presenter.selectTime);
    return Card(
      margin: const EdgeInsets.all(16),
      color: Color(0xff232323),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  presenter.model.card_type == 'master' ? "Master" : "VISA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  AppStatus.shared.meet4AddBlank(cardNo),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                showDateDiolog(context);
              },
              child: Container(
                height: 32,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                  color: Color(0xff232323),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateTime,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Image.asset(A.assets_date_icon),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    final transactions = List.generate(
        3,
        (index) => _TransactionItem(
              type: 'FEE',
              amount: -10.00,
              time: '2022-06-08 20:01:01',
            ));

    return EasyRefresh(
      header: MaterialHeader(),
      footer: MaterialFooter(),
      onRefresh: () async {
        await presenter.getSettlementData();
      },
      onLoad: () {
        presenter.getSettlementMoreData();
        if (!presenter.hasMore) {
          return IndicatorResult.noMore;
        }
      },
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: presenter.settleMentList.length,
          // separatorBuilder: (context, index) => Divider(color: Colors.grey[400]),
          itemBuilder: (context, index) {
            SettlementModel item = presenter.settleMentList[index];
            var billAmt = "";
            var transAmt = "";
            var rightContent = "";
            if (item.isCredit == "1") {
              //@account
              if (UserInfo.shared.email == AppStatus.shared.specialAccount) {
                billAmt = "+${item.billCurrencyAmt} USD";
                transAmt = "+${item.transCurrencyAmt} USD";
              } else {
                billAmt = "+${item.billCurrencyAmt} ${item.billCurrency}";
                transAmt = "+${item.transCurrencyAmt} ${item.transCurrency}";
              }
              rightContent = "Permission".tr();
            } else {
              //@account
              if (UserInfo.shared.email == AppStatus.shared.specialAccount) {
                billAmt = "-${item.billCurrencyAmt} USD";
                transAmt = "-${item.transCurrencyAmt} USD";
              } else {
                billAmt = "-${item.billCurrencyAmt} ${item.billCurrency}";
                transAmt = "-${item.transCurrencyAmt} ${item.transCurrency}";
              }

              rightContent = "Consumption".tr();
            }
            double bot =
                (presenter.settleMentList.length == index - 1) ? 20.0 : 0.0;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Card(
                // margin: const EdgeInsets.all(16),
                color: Color(0xff232323),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.merchantName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            billAmt,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            transAmt,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            rightContent,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            item.settleDate,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildDownloadButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff2369FF),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: () async {
          DateFormat dateFormat = DateFormat("yyyy-MM");
          String dateTime = dateFormat.format(presenter.selectTime);
          String url = await presenter.downPressed(
              presenter.model.card_order, dateTime, presenter.currentPage);
          print("url is ${url}");
          launchUrlString(url, mode: LaunchMode.externalApplication);
        },
        child: const Text(
          'Download Bill',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  //日期弹窗
  showDateDiolog(BuildContext context) {
    DatePicker.showDatePicker(context,
        minDateTime: DateTime(2021, 1, 01),
        maxDateTime: DateTime.now(),
        dateFormat: "yyyy-MM",
        initialDateTime: presenter.selectTime,
        pickerMode: DateTimePickerMode.date,
        pickerTheme: DateTimePickerTheme(
          backgroundColor: _theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : ColorsUtil.hexColor(0x252525),
          confirmTextStyle: TextStyle(
              color: AppStatus.shared.bgWhiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w500),
          titleHeight: 44,
          pickerHeight: 217,
          itemTextStyle: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ), onConfirm: (date, list) {
      debugPrint('select time $date, $list');
      presenter.selectTime = date;
      streamController.add(0);
      presenter.getSettlementData();
    });
    return;
  }
}

class _TransactionItem {
  final String type;
  final double amount;
  final String time;

  _TransactionItem({
    required this.type,
    required this.amount,
    required this.time,
  });
}

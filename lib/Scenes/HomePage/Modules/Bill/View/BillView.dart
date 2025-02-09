import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Common/ColorUtil.dart';
import '../../../../../Common/DatePicker/date_picker.dart';
import '../../../../../Common/DatePicker/date_picker_theme.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
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

  }

  Widget _buildCardInfo(BuildContext context) {
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
            Row(children: [
              const Text(
                'VISA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                '*******6786',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
            ],),
            const SizedBox(height: 10),
            InkWell(
              onTap: (){
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
                  ],),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    final transactions = List.generate(3, (index) => _TransactionItem(
      type: 'FEE',
      amount: -10.00,
      time: '2022-06-08 20:01:01',
    ));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: transactions.length,
      // separatorBuilder: (context, index) => Divider(color: Colors.grey[400]),
      itemBuilder: (context, index) => ListTile(
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
                      transactions[index].type,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${transactions[index].amount.toStringAsFixed(2)}USD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${transactions[index].amount.toStringAsFixed(2)}USD',
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
                      '${transactions[index].amount.toStringAsFixed(2)}USD',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${transactions[index].amount.toStringAsFixed(2)}USD',
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
      ),
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
        onPressed: () {},
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
          // StreamCenter.shared.homeStreamController.add(0);
          // MycardsModel m = presenter.models[_currentPageIndex];
          // presenter.getSettlementData(m);
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